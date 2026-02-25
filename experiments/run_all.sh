#!/bin/bash
# run_all.sh - 运行所有测试模型的自动化脚本
# 作者: Claude Code
# 说明: 此脚本用于自动运行experiments目录下的所有测试模型。
#       配置灵活，支持自定义模型、变体和测试脚本。

set -euo pipefail

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "${BLUE}[DEBUG]${NC} $1"
    fi
}

# 帮助信息
print_help() {
    cat << EOF
用法: $0 [选项]

选项:
  -h, --help          显示此帮助信息
  -m, --model MODEL   只运行指定的模型（逗号分隔，如 "MiniLM,Sentence-BERT"）
  -s, --script SCRIPT 指定运行的脚本 (如 "script4x4.sh"，默认: all 运行所有)
  -l, --list          列出所有可用的模型和测试脚本
  --dry-run           只显示将要运行的命令，不实际执行

示例:
  $0                    # 运行所有模型的所有测试脚本
  $0 -m MiniLM          # 只运行MiniLM模型的所有测试脚本
  $0 -s script4x4.sh    # 所有模型只运行 script4x4.sh
  $0 --dry-run          # 显示将要运行的命令
  $0 --list             # 列出所有配置

EOF
}

# 检查依赖
check_dependencies() {
    local missing_deps=()

    for cmd in mlir-opt soda-opt mlir-translate llc clang++; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "缺少以下依赖: ${missing_deps[*]}"
        log_info "请确保已经构建项目并设置环境变量（运行 'source setup_env.sh'）"
        return 1
    fi

    log_info "所有依赖已安装"
    return 0
}

# 设置环境
setup_environment() {
    local env_script="../setup_env.sh"

    if [[ -f "$env_script" ]]; then
        log_info "设置环境变量..."
        source "$env_script" 2>/dev/null || {
            log_warning "无法source环境脚本，继续执行..."
        }
    else
        log_warning "未找到环境设置脚本: $env_script"
        log_warning "请确保MLIR/LLVM工具在PATH中"
    fi
}

# 配置数据
# 格式: 模型名称
declare -a TEST_CONFIGS=(
    "MiniLM"
    "Sentence-BERT"
    "CamemBERT"
    "VIT"
)

# 测试脚本配置
declare -a TEST_SCRIPTS=(
    "script8x8.sh"
    "script8x8-doublebuffer.sh"
    "script4x4.sh"
    "script4x4-doublebuffer.sh"
)

# 运行单个测试
run_single_test() {
    local model="$1"
    local dry_run="${2:-false}"
    local target_script="${3:-all}"
    local model_py_dir="./$model/model"
    local cgra_dir="./$model/cgra"

    # 1. 运行model目录下的Python脚本（只取第一个py文件）
    if [[ -d "$model_py_dir" ]]; then
        py_script=$(find "$model_py_dir" -maxdepth 1 -name "*.py" -type f | head -n 1)
        if [[ -n "$py_script" ]]; then
            if [[ "$dry_run" == "true" ]]; then
                log_info "dry-run: 跳过 python 生成步骤（$py_script）"
            else
                log_info "生成linalg.mlir: $py_script"
                if python3.9 "$py_script"; then
                    log_info "linalg.mlir生成成功"
                else
                    log_error "linalg.mlir生成失败: $py_script"
                    return 1
                fi
            fi
        fi
        # 2. mv 02-linalg.mlir到cgra目录
        if [[ -f 02-linalg.mlir && -d "$cgra_dir" ]]; then
            mv -f 02-linalg.mlir "$cgra_dir/02-linalg.mlir"
            log_info "已移动02-linalg.mlir到: $cgra_dir"
        fi
    fi
    # 3. cd到cgra目录，执行配置的测试脚本
    if [[ -d "$cgra_dir" ]]; then
        local scripts_to_run=()
        if [[ "$target_script" == "all" ]]; then
            scripts_to_run=("${TEST_SCRIPTS[@]}")
        else
            scripts_to_run=("$target_script")
        fi

        for script_name in "${scripts_to_run[@]}"; do
            script_path="$cgra_dir/$script_name"
            if [[ -f "$script_path" ]]; then
                log_info "========================================"
                log_info "开始测试: $model - $script_name"
                pushd "$cgra_dir" > /dev/null
                # 对于 dry-run，跳过 python 生成，但仍实际执行脚本
                if [[ ! -x "$script_name" ]]; then
                    chmod +x "$script_name"
                fi
                if bash "$script_name"; then
                    log_info "脚本执行成功: $script_name"
                else
                    log_error "脚本执行失败: $script_name"
                    popd > /dev/null
                    return 1
                fi
                popd > /dev/null
                log_info "完成测试: $model - $script_name"
                log_info "========================================"
                echo ""
            else
                log_warning "未找到脚本: $script_path"
            fi
        done
    fi
    return 0
}

# 主函数
main() {
    local models_filter=""
    local target_script="all"
    local list_mode=false
    local dry_run=false

    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_help
                exit 0
                ;;
            -m|--model)
                models_filter="$2"
                shift 2
                ;;
            -s|--script)
                target_script="$2"
                shift 2
                ;;
            -l|--list)
                list_mode=true
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            *)
                log_error "未知选项: $1"
                print_help
                exit 1
                ;;
        esac
    done

    # 列出配置并退出
    if [[ "$list_mode" == "true" ]]; then
        echo "可用模型:"
        for m in "${TEST_CONFIGS[@]}"; do echo "  - $m"; done
        echo "可用测试脚本:"
        for s in "${TEST_SCRIPTS[@]}"; do echo "  - $s"; done
        exit 0
    fi

    log_info "开始运行所有测试模型..."
    log_info "目标测试脚本: $target_script"

    # 设置环境（dry-run时跳过）
    if [[ "$dry_run" != "true" ]]; then
        setup_environment
    fi

    # 检查依赖（除非dry-run）
    if [[ "$dry_run" != "true" ]]; then
        check_dependencies || exit 1
    fi

    # 准备测试列表
    local success_count=0
    local failure_count=0
    declare -a failed_tests=()
    declare -a test_descriptions=()

    # 只遍历TEST_CONFIGS数组
    # 为确保单个测试的失败不会因为 set -e 导致主脚本退出，暂时关闭 set -e 在整个循环期间
    set +e
    for model in "${TEST_CONFIGS[@]}"; do
        # 如果用户提供了 -m/--model 过滤，则跳过不在列表中的模型
        if [[ -n "$models_filter" ]]; then
            skip=true
            IFS=',' read -ra mf <<< "$models_filter"
            for m in "${mf[@]}"; do
                # trim surrounding whitespace from filter element
                m_trim=$(echo "$m" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                if [[ "$m_trim" == "$model" ]]; then
                    skip=false
                    break
                fi
            done
            if [[ "$skip" == "true" ]]; then
                log_info "跳过模型（过滤）： $model"
                continue
            fi
        fi

        echo "========================================"
        log_info "准备测试: $model"

        # 使用子 shell 运行每个测试，防止被测试脚本或子函数中的 exit 意外终止主脚本
        ( run_single_test "$model" "$dry_run" "$target_script" )
        rc=$?
        log_info "测试 '$model' 返回码: $rc"

        if [[ $rc -eq 0 ]]; then
            ((success_count++))
        else
            ((failure_count++))
            failed_tests+=("$model")
        fi
    done

    # 恢复 set -e（之后的清理/退出需要严格失败处理）
    set -e

    # 打印摘要
    log_info "测试摘要:"
    log_info "  总测试数: $((success_count + failure_count))"
    log_info "  通过: $success_count"
    log_info "  失败: $failure_count"

    if [[ $failure_count -gt 0 ]]; then
        log_error "失败的测试:"
        for test in "${failed_tests[@]}"; do
            log_error "  - $test"
        done
        exit 1
    else
        log_info "所有测试通过!"
        exit 0
    fi
}

# 运行主函数
main "$@"