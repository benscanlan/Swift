#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project structure
mkdir -p src/shaders
mkdir -p build

# Create main.cpp if it doesn't exist
if [ ! -f src/main.cpp ]; then
    echo "Creating main.cpp..."
    cat > src/main.cpp << 'EOL'
#import <Metal/Metal.h>
#import <Foundation/Foundation.h>
#include <iostream>

int main() {
    @autoreleasepool {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        
        if (!device) {
            std::cerr << "Failed to create Metal device\n";
            return -1;
        }
        
        std::cout << "Successfully created Metal device: " << device.name.UTF8String << std::endl;
    }
    return 0;
}
EOL
fi

# Create basic shader if it doesn't exist
if [ ! -f src/shaders/shader.metal ]; then
    echo "Creating shader.metal..."
    cat > src/shaders/shader.metal << 'EOL'
#include <metal_stdlib>
using namespace metal;

kernel void compute_function(uint index [[thread_position_in_grid]]) {
    // Basic compute shader
}
EOL
fi

# Compile function
compile() {
    echo -e "${BLUE}[STATUS]${NC} Compiling Metal shaders..."
    xcrun metal -c src/shaders/shader.metal -o build/shader.air || {
        echo -e "${RED}[ERROR]${NC} Failed to compile shader"
        exit 1
    }
    
    xcrun metallib build/shader.air -o build/shader.metallib || {
        echo -e "${RED}[ERROR]${NC} Failed to create metallib"
        exit 1
    }
    
    echo -e "${BLUE}[STATUS]${NC} Compiling C++ code..."
    clang++ -std=c++17 src/main.cpp \
        -framework Metal \
        -framework Foundation \
        -fobjc-arc \
        -isysroot $(xcrun --sdk macosx --show-sdk-path) \
        -o build/program || {
        echo -e "${RED}[ERROR]${NC} Failed to compile C++ code"
        exit 1
    }
    
    echo -e "${GREEN}[SUCCESS]${NC} Build completed successfully!"
}

# Clean function
clean() {
    echo -e "${BLUE}[STATUS]${NC} Cleaning build directory..."
    rm -rf build/*
    echo -e "${GREEN}[SUCCESS]${NC} Clean completed!"
}

# Parse command line arguments
case "$1" in
    "clean")
        clean
        ;;
    "build")
        compile
        ;;
    *)
        compile
        ;;
esac
