#!/bin/bash
# MLIR-CGRA构建脚本
# 此脚本用于构建MLIR-CGRA项目及其依赖（LLVM/MLIR）
# 使用方法: ./build.sh [选项]

set -e

# 默认配置
DEFAULT_LLVM_SRC_DIR="$PWD/llvm-project"
DEFAULT_LLVM_BUILD_DIR="$PWD/build_llvm"
DEFAULT_LLVM_INSTALL_DIR="$PWD/install_llvm"
DEFAULT_SODA_BUILD_DIR="$PWD/build_soda"
DEFAULT_SODA_INSTALL_DIR="$PWD/install_soda"
REQUIRED_LLVM_COMMIT="99020b3c73c1e22fa388be8fd0c44391d40b3a38"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数定义
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    print_info "检查系统依赖..."
    local missing_deps=()

    # 检查基本构建工具
    for cmd in cmake ninja git; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    # 检查Python相关
    if ! command -v python3.9 &> /dev/null; then
        print_warning "未找到python3.9，Python绑定可能无法正常工作"
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "缺少以下依赖: ${missing_deps[*]}"
        print_info "请安装缺失的依赖后再运行此脚本"
        exit 1
    fi

    print_info "所有依赖已安装"
}

setup_llvm_source() {
    local llvm_src_dir="$1"

    if [ ! -d "$llvm_src_dir" ]; then
        print_info "LLVM源代码目录不存在，正在克隆..."
        git clone https://github.com/llvm/llvm-project.git "$llvm_src_dir"
    else
        print_info "使用现有的LLVM源代码目录: $llvm_src_dir"
        git submodule update --init --recursive
    fi

    # 进入目录检查commit
    cd "$llvm_src_dir"
    local current_commit=$(git rev-parse HEAD 2>/dev/null || echo "")

    if [ "$current_commit" != "$REQUIRED_LLVM_COMMIT" ]; then
        print_info "检出所需的LLVM commit: $REQUIRED_LLVM_COMMIT"
        git fetch origin
        git checkout "$REQUIRED_LLVM_COMMIT"
    else
        print_info "LLVM已在正确的commit上: $REQUIRED_LLVM_COMMIT"
    fi

    cd - > /dev/null
}

build_llvm() {
    local llvm_src_dir="$1"
    local build_dir="$2"
    local install_dir="$3"

    print_info "开始构建LLVM/MLIR..."
    print_info "源代码目录: $llvm_src_dir"
    print_info "构建目录: $build_dir"
    print_info "安装目录: $install_dir"

    # 创建目录
    mkdir -p "$build_dir"
    mkdir -p "$install_dir"

    # 构建LLVM/MLIR
    cd "$build_dir"

    print_info "配置CMake..."
    cmake -GNinja \
        "$llvm_src_dir/llvm" \
        -DCMAKE_INSTALL_PREFIX="$install_dir" \
        -DLLVM_INSTALL_UTILS=ON \
        -DLLVM_ENABLE_PROJECTS="mlir" \
        -DLLVM_TARGETS_TO_BUILD="host" \
        -DLLVM_INCLUDE_TOOLS=ON \
        -DLLVM_BUILD_TOOLS=ON \
        -DLLVM_INCLUDE_TESTS=ON \
        -DMLIR_INCLUDE_TESTS=ON \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DLLVM_ENABLE_ASSERTIONS=On \
        -DLLVM_BUILD_EXAMPLES=OFF

    print_info "编译并安装..."
    cmake --build . --target opt mlir-opt mlir-translate mlir-cpu-runner install

    cd - > /dev/null

    print_info "LLVM/MLIR构建完成"
}

build_soda() {
    local soda_src_dir="$1"
    local build_dir="$2"
    local install_dir="$3"
    local llvm_build_dir="$4"
    local llvm_install_dir="$5"

    print_info "开始构建MLIR-CGRA (SODA)..."
    print_info "源代码目录: $soda_src_dir"
    print_info "构建目录: $build_dir"
    print_info "安装目录: $install_dir"
    print_info "LLVM构建目录: $llvm_build_dir"
    print_info "LLVM安装目录: $llvm_install_dir"

    # 验证LLVM构建
    if [ ! -f "$llvm_build_dir/bin/llvm-lit" ]; then
        print_error "找不到llvm-lit: $llvm_build_dir/bin/llvm-lit"
        print_error "请确保LLVM构建成功完成"
        exit 1
    fi

    if [ ! -f "$llvm_install_dir/lib/cmake/mlir/MLIRTargets.cmake" ]; then
        print_error "找不到MLIRTargets.cmake: $llvm_install_dir/lib/cmake/mlir/MLIRTargets.cmake"
        print_error "请确保LLVM安装成功完成"
        exit 1
    fi

    # 创建目录
    mkdir -p "$build_dir"

    # 构建SODA
    cd "$build_dir"

    print_info "配置CMake..."
    cmake -GNinja \
        "$soda_src_dir" \
        -DCMAKE_INSTALL_PREFIX="$install_dir" \
        -DCMAKE_BUILD_TYPE=Debug \
        -DLLVM_EXTERNAL_LIT="$llvm_build_dir/bin/llvm-lit" \
        -DMLIR_DIR="$llvm_install_dir/lib/cmake/mlir"

    print_info "编译..."
    cmake --build . --target soda-opt soda-translate mlir-runner AllocaNamer XMLWriter VhlsLLVMRewriter install

    cd - > /dev/null

    print_info "MLIR-CGRA构建完成"
}

setup_environment() {
    local llvm_install_dir="$1"
    local soda_install_dir="$2"

    print_info "设置环境变量..."

    # 创建环境设置脚本
    cat > setup_env.sh << EOF
#!/bin/bash
# MLIR-CGRA环境设置脚本

export LLVM_INSTALL_DIR="$llvm_install_dir"
export SODA_INSTALL_DIR="$soda_install_dir"

# 添加LLVM/MLIR工具到PATH
export PATH="\$LLVM_INSTALL_DIR/bin:\$PATH"

# 添加SODA工具到PATH
export PATH="\$SODA_INSTALL_DIR/bin:\$PATH"

# Python模块路径
export PYTHONPATH="\$SODA_INSTALL_DIR/python:\$PYTHONPATH"

echo "环境已设置完成"
echo "LLVM安装目录: \$LLVM_INSTALL_DIR"
echo "SODA安装目录: \$SODA_INSTALL_DIR"
echo "工具已添加到PATH"
EOF

    chmod +x setup_env.sh

    print_info "环境设置脚本已创建: setup_env.sh"
    print_info "运行 'source setup_env.sh' 来设置环境"
}

print_usage() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  --llvm-src-dir DIR      LLVM源代码目录 (默认: $DEFAULT_LLVM_SRC_DIR)"
    echo "  --llvm-build-dir DIR    LLVM构建目录 (默认: $DEFAULT_LLVM_BUILD_DIR)"
    echo "  --llvm-install-dir DIR  LLVM安装目录 (默认: $DEFAULT_LLVM_INSTALL_DIR)"
    echo "  --soda-build-dir DIR    SODA构建目录 (默认: $DEFAULT_SODA_BUILD_DIR)"
    echo "  --soda-install-dir DIR  SODA安装目录 (默认: $DEFAULT_SODA_INSTALL_DIR)"
    echo "  --skip-llvm             跳过LLVM构建（使用已构建的LLVM）"
    echo "  --skip-soda             跳过SODA构建"
    echo "  --help                  显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                            # 使用默认设置完全构建"
    echo "  $0 --skip-llvm                # 仅构建SODA（假设LLVM已构建）"
    echo "  $0 --llvm-build-dir /tmp/llvm_build  # 使用自定义构建目录"
}

# 解析命令行参数
SKIP_LLVM=false
SKIP_SODA=false
LLVM_SRC_DIR="$DEFAULT_LLVM_SRC_DIR"
LLVM_BUILD_DIR="$DEFAULT_LLVM_BUILD_DIR"
LLVM_INSTALL_DIR="$DEFAULT_LLVM_INSTALL_DIR"
SODA_BUILD_DIR="$DEFAULT_SODA_BUILD_DIR"
SODA_INSTALL_DIR="$DEFAULT_SODA_INSTALL_DIR"

while [[ $# -gt 0 ]]; do
    case $1 in
        --llvm-src-dir)
            LLVM_SRC_DIR="$2"
            shift 2
            ;;
        --llvm-build-dir)
            LLVM_BUILD_DIR="$2"
            shift 2
            ;;
        --llvm-install-dir)
            LLVM_INSTALL_DIR="$2"
            shift 2
            ;;
        --soda-build-dir)
            SODA_BUILD_DIR="$2"
            shift 2
            ;;
        --soda-install-dir)
            SODA_INSTALL_DIR="$2"
            shift 2
            ;;
        --skip-llvm)
            SKIP_LLVM=true
            shift
            ;;
        --skip-soda)
            SKIP_SODA=true
            shift
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            print_error "未知选项: $1"
            print_usage
            exit 1
            ;;
    esac
done

# 主程序
print_info "开始MLIR-CGRA构建过程"
print_info "当前目录: $PWD"

# 检查依赖
check_dependencies

# 处理LLVM构建
if [ "$SKIP_LLVM" = false ]; then
    setup_llvm_source "$LLVM_SRC_DIR"
    build_llvm "$LLVM_SRC_DIR" "$LLVM_BUILD_DIR" "$LLVM_INSTALL_DIR"
else
    print_info "跳过LLVM构建"
fi

# 处理SODA构建
if [ "$SKIP_SODA" = false ]; then
    build_soda "$PWD" "$SODA_BUILD_DIR" "$SODA_INSTALL_DIR" "$LLVM_BUILD_DIR" "$LLVM_INSTALL_DIR"
else
    print_info "跳过SODA构建"
fi

# 设置环境
if [ "$SKIP_SODA" = false ]; then
    setup_environment "$LLVM_INSTALL_DIR" "$SODA_INSTALL_DIR"
fi

print_info "构建过程完成！"
print_info "下一步："
print_info "1. 运行 'source setup_env.sh' 设置环境变量"
print_info "2. 查看 README.md 了解如何运行示例"
print_info "3. 运行测试: cd $SODA_BUILD_DIR && ctest --output-on-failure"