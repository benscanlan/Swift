import Metal

// Get the default Metal device
guard let device = MTLCreateSystemDefaultDevice() else {
    fatalError("Metal is not supported on this device")
}

// Create a command queue
guard let commandQueue = device.makeCommandQueue() else {
    fatalError("Could not create command queue")
}

// Create the Metal library and get the kernel function
guard let library = device.makeDefaultLibrary(),
      let function = library.makeFunction(name: "hello_kernel") else {
    fatalError("Could not create Metal library or find kernel function")
}

// Create compute pipeline state
guard let computePipelineState = try? device.makeComputePipelineState(function: function) else {
    fatalError("Could not create compute pipeline state")
}

// Create input data
let arrayLength = 10
let bufferSize = arrayLength * MemoryLayout<Float>.stride
guard let outputBuffer = device.makeBuffer(length: bufferSize, options: .storageModeShared) else {
    fatalError("Could not create output buffer")
}

// Create command buffer and encoder
guard let commandBuffer = commandQueue.makeCommandBuffer(),
      let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
    fatalError("Could not create command buffer or encoder")
}

// Configure and dispatch the compute encoder
computeEncoder.setComputePipelineState(computePipelineState)
computeEncoder.setBuffer(outputBuffer, offset: 0, index: 0)
let threadsPerGrid = MTLSize(width: arrayLength, height: 1, depth: 1)
let threadsPerThreadgroup = MTLSize(width: arrayLength, height: 1, depth: 1)
computeEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
computeEncoder.endEncoding()

// Execute command buffer and wait for completion
commandBuffer.commit()
commandBuffer.waitUntilCompleted()

// Read and print results
let outputArray = outputBuffer.contents().bindMemory(to: Float.self, capacity: arrayLength)
print("Results:")
for i in 0..<arrayLength {
    print("Element \(i): \(outputArray[i])")
}

