xcrun -sdk macosx metal -c Shaders.metal -o Shaders.air
xcrun -sdk macosx metallib Shaders.air -o default.metallib
swiftc main.swift -o metal_window -framework Metal -framework MetalKit -framework AppKit
./metal_window
