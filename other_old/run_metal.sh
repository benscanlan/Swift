#!/bin/bash

# Compile the Metal program
swiftc -o MetalProgram MetalProgram.swift -framework MetalKit -framework CoreImage

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful."
    # Run the compiled Metal program
    ./MetalProgram
else
    echo "Compilation failed."
fi
