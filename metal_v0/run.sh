xcrun -sdk macosx metal -c kernel.metal -o kernel.air
xcrun -sdk macosx metallib kernel.air -o default.metallib
swiftc main.swift -o hello_metal
./hello_metal
