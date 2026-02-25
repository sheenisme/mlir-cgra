#!/bin/bash
# run_all.sh - automation script to run all experiment models
# Author: Claude Code
# Note: This script runs all test models under the experiments directory.
#       It is flexible and supports custom models, variants, and test scripts.

set -euo pipefail

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
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

# Help / usage
print_help() {
    cat << EOF
Usage: $0 [options]

Options:
    -h, --help          Show this help message
    -m, --model MODEL   Run only the specified models (comma-separated, e.g. "MiniLM,Sentence-BERT")
    -s, --script SCRIPT Specify the test script to run (e.g. "script4x4.sh", default: all)
    -l, --list          List available models and test scripts
    --dry-run           Print commands to run without executing them

Examples:
    $0                    # Run all test scripts for all models
    $0 -m MiniLM          # Run all test scripts for MiniLM only
    $0 -s script4x4.sh    # Run script4x4.sh for all models
    $0 --dry-run          # Show what would be run
    $0 --list             # List available configurations

EOF
}

# Check dependencies
check_dependencies() {
    local missing_deps=()

    for cmd in mlir-opt soda-opt mlir-translate llc clang++; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Please ensure the project is built and environment variables are set (run 'source setup_env.sh')"
        return 1
    fi

    log_info "All dependencies are installed"
    return 0
}

# Set up environment
setup_environment() {
    local env_script="../setup_env.sh"

    if [[ -f "$env_script" ]]; then
        log_info "Sourcing environment script..."
        source "$env_script" 2>/dev/null || {
            log_warning "Failed to source environment script; continuing..."
        }
    else
        log_warning "Environment script not found: $env_script"
        log_warning "Ensure MLIR/LLVM tools are on PATH"
    fi
}

# Test configurations
# Format: Model names (these should correspond to subdirectories under experiments/)
declare -a TEST_CONFIGS=(
    "MiniLM"
    "Sentence-BERT"
    "CamemBERT"
    "VIT"
)

# Test script configurations
declare -a TEST_SCRIPTS=(
    "script8x8.sh"
    "script8x8-doublebuffer.sh"
    "script4x4.sh"
    "script4x4-doublebuffer.sh"
)

# Run single test
run_single_test() {
    local model="$1"
    local dry_run="${2:-false}"
    local target_script="${3:-all}"
    local model_py_dir="./$model/model"
    local cgra_dir="./$model/cgra"

    # 1. Run Python script to generate linalg.mlir (if exists)
    if [[ -d "$model_py_dir" ]]; then
        py_script=$(find "$model_py_dir" -maxdepth 1 -name "*.py" -type f | head -n 1)
        if [[ -n "$py_script" ]]; then
            if [[ "$dry_run" == "true" ]]; then
                log_info "dry-run: skipping Python generation step ($py_script)"
            else
                log_info "Generating linalg.mlir from: $py_script"
                if python3.9 "$py_script"; then
                    log_info "linalg.mlir generated successfully"
                else
                    log_error "Failed to generate linalg.mlir: $py_script"
                    return 1
                fi
            fi
        fi
        # 2. mv 02-linalg.mlir to cgra_dir (if exists)
            if [[ -f 02-linalg.mlir && -d "$cgra_dir" ]]; then
                mv -f 02-linalg.mlir "$cgra_dir/02-linalg.mlir"
                log_info "Moved 02-linalg.mlir to: $cgra_dir"
            fi
    fi
    # 3. cd to cgra_dir and run test scripts
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
                log_info "Starting test: $model - $script_name"
                pushd "$cgra_dir" > /dev/null
                # For dry-run, skip Python generation but still execute the script
                if [[ ! -x "$script_name" ]]; then
                    chmod +x "$script_name"
                fi
                if bash "$script_name"; then
                    log_info "Script executed successfully: $script_name"
                else
                    log_error "Script execution failed: $script_name"
                    popd > /dev/null
                    return 1
                fi
                popd > /dev/null
                log_info "Completed test: $model - $script_name"
                log_info "========================================"
                echo ""
            else
                log_warning "Script not found: $script_path"
            fi
        done
    fi
    return 0
}

# Main function to run all tests
main() {
    local models_filter=""
    local target_script="all"
    local list_mode=false
    local dry_run=false

    # Parse command-line arguments
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
                log_error "Unknown option: $1"
                print_help
                exit 1
                ;;
        esac
    done

    # List available models and scripts if requested
    if [[ "$list_mode" == "true" ]]; then
        echo "Available models:"
        for m in "${TEST_CONFIGS[@]}"; do echo "  - $m"; done
        echo "Available test scripts:"
        for s in "${TEST_SCRIPTS[@]}"; do echo "  - $s"; done
        exit 0
    fi

    log_info "Starting to run all test models..."
    log_info "Target test script: $target_script"

    # Set up environment (skip for dry-run)
    if [[ "$dry_run" != "true" ]]; then
        setup_environment
    fi

    # Check dependencies (unless dry-run)
    if [[ "$dry_run" != "true" ]]; then
        check_dependencies || exit 1
    fi

    # Prepare to run tests
    local success_count=0
    local failure_count=0
    declare -a failed_tests=()
    declare -a test_descriptions=()

    # Only run tests for models that match the filter (if provided)
    # For each model, run the specified test script(s)
    set +e
    for model in "${TEST_CONFIGS[@]}"; do
        # If models_filter is set, only run models that match the filter
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
                log_info "Skipping model (filtered): $model"
                continue
            fi
        fi

        echo "========================================"
        log_info "Processing model: $model"

        # Run the test and capture the result
        ( run_single_test "$model" "$dry_run" "$target_script" )
        rc=$?
        log_info "Test '$model' returned code: $rc"

        if [[ $rc -eq 0 ]]; then
            ((success_count++))
        else
            ((failure_count++))
            failed_tests+=("$model")
        fi
    done

    set -e

    # Print summary of results
    log_info "Test Summary:"
    log_info "  Total tests: $((success_count + failure_count))"
    log_info "  Passed: $success_count"
    log_info "  Failed: $failure_count"

    if [[ $failure_count -gt 0 ]]; then
        log_error "Failed tests:"
        for test in "${failed_tests[@]}"; do
            log_error "  - $test"
        done
        exit 1
    else
        log_info "All tests passed!"
        exit 0
    fi
}

# Run main function
main "$@"