#!/bin/bash
# MLIR-CGRA环境设置脚本

export LLVM_BUILD_DIR="/home/sheen/workspace/mlir-cgra/build_llvm"
export SODA_BUILD_DIR="/home/sheen/workspace/mlir-cgra/build_soda"
export LLVM_INSTALL_DIR="/home/sheen/workspace/mlir-cgra/install_llvm"
export SODA_INSTALL_DIR="/home/sheen/workspace/mlir-cgra/install_soda"

# 添加LLVM库路径到LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LLVM_BUILD_DIR/lib:$SODA_BUILD_DIR/lib:$LD_LIBRARY_PATH

# 添加LLVM/MLIR工具到PATH
export PATH="$LLVM_INSTALL_DIR/bin:$PATH"

# 添加SODA工具到PATH
export PATH="$SODA_INSTALL_DIR/bin:$PATH"

# Python模块路径
export PYTHONPATH="$SODA_INSTALL_DIR/python:$PYTHONPATH"

echo "环境已设置完成"
echo "LLVM构建目录: $LLVM_BUILD_DIR"
echo "SODA构建目录: $SODA_BUILD_DIR"
echo "LLVM安装目录: $LLVM_INSTALL_DIR"
echo "SODA安装目录: $SODA_INSTALL_DIR"
