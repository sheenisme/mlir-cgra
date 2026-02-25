#!/bin/bash
# MLIR-CGRA build script
# Builds MLIR-CGRA and its dependencies (LLVM/MLIR)
# Usage: ./build.sh [options]

set -e

# Default directories
DEFAULT_LLVM_SRC_DIR="$PWD/llvm-project"
DEFAULT_LLVM_BUILD_DIR="$PWD/build_llvm"
DEFAULT_LLVM_INSTALL_DIR="$PWD/install_llvm"
DEFAULT_SODA_BUILD_DIR="$PWD/build_soda"
DEFAULT_SODA_INSTALL_DIR="$PWD/install_soda"
REQUIRED_LLVM_COMMIT="99020b3c73c1e22fa388be8fd0c44391d40b3a38"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions definition
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
    print_info "Checking system dependencies..."
    local missing_deps=()

    # Check for required commands
    for cmd in cmake ninja git; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    # Check for Python 3.9 (for MLIR Python bindings)
    if ! command -v python3.9 &> /dev/null; then
        print_warning "python3.9 not found; Python bindings may not work correctly"
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_info "Please install the missing dependencies and re-run this script"
        exit 1
    fi

    print_info "All dependencies are installed"
}

setup_llvm_source() {
    local llvm_src_dir="$1"

    if [ ! -d "$llvm_src_dir" ]; then
        print_info "LLVM source directory not found; cloning..."
        git clone https://github.com/llvm/llvm-project.git "$llvm_src_dir"
    else
        print_info "Using existing LLVM source directory: $llvm_src_dir"
        git submodule update --init --recursive
    fi

    # Ensure we are on the required commit
    cd "$llvm_src_dir"
    local current_commit=$(git rev-parse HEAD 2>/dev/null || echo "")

    if [ "$current_commit" != "$REQUIRED_LLVM_COMMIT" ]; then
            print_info "Checking out required LLVM commit: $REQUIRED_LLVM_COMMIT"
        git fetch origin
        git checkout "$REQUIRED_LLVM_COMMIT"
    else
            print_info "LLVM already at required commit: $REQUIRED_LLVM_COMMIT"
    fi

    cd - > /dev/null
}

build_llvm() {
    local llvm_src_dir="$1"
    local build_dir="$2"
    local install_dir="$3"

    print_info "Starting LLVM/MLIR build..."
    print_info "Source directory: $llvm_src_dir"
    print_info "Build directory: $build_dir"
    print_info "Install directory: $install_dir"

    # Create build and install directories
    mkdir -p "$build_dir"
    mkdir -p "$install_dir"

    # BUILD LLVM/MLIR
    cd "$build_dir"

    print_info "Configuring CMake..."
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

    print_info "Building and installing..."
    cmake --build . --target opt mlir-opt mlir-translate mlir-cpu-runner install

    cd - > /dev/null

    print_info "LLVM/MLIR build complete"
}

build_soda() {
    local soda_src_dir="$1"
    local build_dir="$2"
    local install_dir="$3"
    local llvm_build_dir="$4"
    local llvm_install_dir="$5"

    print_info "Starting MLIR-CGRA (SODA) build..."
    print_info "Source directory: $soda_src_dir"
    print_info "Build directory: $build_dir"
    print_info "Install directory: $install_dir"
    print_info "LLVM build directory: $llvm_build_dir"
    print_info "LLVM install directory: $llvm_install_dir"

    # Check for required LLVM tools and MLIR CMake config
    if [ ! -f "$llvm_build_dir/bin/llvm-lit" ]; then
        print_error "llvm-lit not found: $llvm_build_dir/bin/llvm-lit"
        print_error "Please ensure LLVM was built successfully"
        exit 1
    fi

    if [ ! -f "$llvm_install_dir/lib/cmake/mlir/MLIRTargets.cmake" ]; then
        print_error "MLIRTargets.cmake not found: $llvm_install_dir/lib/cmake/mlir/MLIRTargets.cmake"
        print_error "Please ensure LLVM installation completed successfully"
        exit 1
    fi

    # Create build directory
    mkdir -p "$build_dir"

    # Build SODA
    cd "$build_dir"

    print_info "Configuring CMake..."
    cmake -GNinja \
        "$soda_src_dir" \
        -DCMAKE_INSTALL_PREFIX="$install_dir" \
        -DCMAKE_BUILD_TYPE=Debug \
        -DLLVM_EXTERNAL_LIT="$llvm_build_dir/bin/llvm-lit" \
        -DMLIR_DIR="$llvm_install_dir/lib/cmake/mlir"

    print_info "Building..."
    cmake --build . --target soda-opt soda-translate mlir-runner AllocaNamer XMLWriter VhlsLLVMRewriter install

    cd - > /dev/null

    print_info "MLIR-CGRA (SODA) build complete"
}

setup_environment() {
    local llvm_install_dir="$1"
    local soda_install_dir="$2"
    local llvm_build_dir="$3"
    local soda_build_dir="$4"

    print_info "Setting up environment variables..."

    # Create setup_env.sh
    cat > setup_env.sh << EOF
#!/bin/bash
# MLIR-CGRA environment setup script

export LLVM_BUILD_DIR="$llvm_build_dir"
export SODA_BUILD_DIR="$soda_build_dir"
export LLVM_INSTALL_DIR="$llvm_install_dir"
export SODA_INSTALL_DIR="$soda_install_dir"

# Add LLVM tools to PATH
export PATH="\$LLVM_INSTALL_DIR/bin:\$PATH"

# Add SODA tools to PATH
export PATH="\$SODA_INSTALL_DIR/bin:\$PATH"

# Python Path for MLIR Python bindings (if installed)
export PYTHONPATH="\$SODA_INSTALL_DIR/python:\$PYTHONPATH"

echo "Environment setup complete"
echo "LLVM build dir: \$LLVM_BUILD_DIR"
echo "SODA build dir: \$SODA_BUILD_DIR"
echo "LLVM install dir: \$LLVM_INSTALL_DIR"
echo "SODA install dir: \$SODA_INSTALL_DIR"
EOF

    chmod +x setup_env.sh

    print_info "Environment setup script created: setup_env.sh"
    print_info "Run 'source setup_env.sh' to apply the environment"
}

print_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --llvm-src-dir DIR      LLVM source directory (default: $DEFAULT_LLVM_SRC_DIR)"
    echo "  --llvm-build-dir DIR    LLVM build directory (default: $DEFAULT_LLVM_BUILD_DIR)"
    echo "  --llvm-install-dir DIR  LLVM install directory (default: $DEFAULT_LLVM_INSTALL_DIR)"
    echo "  --soda-build-dir DIR    SODA build directory (default: $DEFAULT_SODA_BUILD_DIR)"
    echo "  --soda-install-dir DIR  SODA install directory (default: $DEFAULT_SODA_INSTALL_DIR)"
    echo "  --skip-llvm             Skip LLVM build (use prebuilt LLVM)"
    echo "  --skip-soda             Skip SODA build"
    echo "  --help                  Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                            # Full build with defaults"
    echo "  $0 --skip-llvm                # Build only SODA (assumes LLVM is built)"
    echo "  $0 --llvm-build-dir /tmp/llvm_build  # Use custom build directory"
}

# Argument parsing
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
            print_error "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Main build process
print_info "Starting MLIR-CGRA build process"
print_info "Current directory: $PWD"

# Check dependencies
check_dependencies

# Handle LLVM build
if [ "$SKIP_LLVM" = false ]; then
    setup_llvm_source "$LLVM_SRC_DIR"
    build_llvm "$LLVM_SRC_DIR" "$LLVM_BUILD_DIR" "$LLVM_INSTALL_DIR"
else
    print_info "Skipping LLVM build; using prebuilt LLVM at $LLVM_INSTALL_DIR"
fi

# Handle SODA build
if [ "$SKIP_SODA" = false ]; then
    build_soda "$PWD" "$SODA_BUILD_DIR" "$SODA_INSTALL_DIR" "$LLVM_BUILD_DIR" "$LLVM_INSTALL_DIR"
else
    print_info "Skipping SODA build; using prebuilt SODA at $SODA_INSTALL_DIR"
fi

# Set up environment variables
if [ "$SKIP_SODA" = false ]; then
    setup_environment "$LLVM_INSTALL_DIR" "$SODA_INSTALL_DIR" "$LLVM_BUILD_DIR" "$SODA_BUILD_DIR"
fi

print_info "Build process complete!"
print_info "Next steps:"
print_info "1. Run 'source setup_env.sh' to set up environment variables"
print_info "2. Check README.md for instructions on running examples"
print_info "3. Run tests: cd $SODA_BUILD_DIR && ctest --output-on-failure"