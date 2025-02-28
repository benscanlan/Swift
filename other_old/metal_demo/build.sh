#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Print functions
print_status() { echo -e "${BLUE}[STATUS]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Directories
BUILD_DIR="build"
BIN_DIR="bin"
mkdir -p $BUILD_DIR $BIN_DIR

# Compile shaders
print_status "Compiling Metal shaders..."
for shader in shaders/*.metal; do
    if [ -f "$shader" ]; then
        basename=$(basename "$shader" .metal)
        xcrun -sdk macosx metal -c "$shader" -o "$BUILD_DIR/$basename.air" || print_error "Failed to compile shader"
        xcrun -sdk macosx metallib "$BUILD_DIR/$basename.air" -o "$BUILD_DIR/$basename.metallib" || print_error "Failed to create metallib"
    fi
done

# Compile C++ code
print_status "Compiling C++ code..."
clang++ -std=c++17 \
    src/main.cpp \
    -framework Metal \
    -framework Foundation \
    -framework QuartzCore \
    -framework CoreGraphics \
    -o "bin/metal_demo" || print_error "Failed to compile C++ code"

print_success "Build completed successfully!"
print_status "Binary location: bin/metal_demo"
