import Metal
import MetalKit
import CoreGraphics

// Initialize Metal device and command queue
guard let device = MTLCreateSystemDefaultDevice() else {
    fatalError("Metal is not supported on this device")
}
let commandQueue = device.makeCommandQueue()!

// Texture dimensions
let width = 512
let height = 512

// Create a texture descriptor for offscreen rendering
let textureDescriptor = MTLTextureDescriptor()
textureDescriptor.pixelFormat = .rgba8Unorm
textureDescriptor.width = width
textureDescriptor.height = height
textureDescriptor.usage = [.renderTarget, .shaderRead]

guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
    fatalError("Failed to create texture")
}

// Create a Metal library and pipeline
let library = device.makeDefaultLibrary()!
let vertexFunction = library.makeFunction(name: "vertex_main")!
let fragmentFunction = library.makeFunction(name: "fragment_main")!

let pipelineDescriptor = MTLRenderPipelineDescriptor()
pipelineDescriptor.vertexFunction = vertexFunction
pipelineDescriptor.fragmentFunction = fragmentFunction
pipelineDescriptor.colorAttachments[0].pixelFormat = textureDescriptor.pixelFormat

let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)

// Create a render pass descriptor
let renderPassDescriptor = MTLRenderPassDescriptor()
renderPassDescriptor.colorAttachments[0].texture = texture
renderPassDescriptor.colorAttachments[0].loadAction = .clear
renderPassDescriptor.colorAttachments[0].storeAction = .store
renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.2, 0.3, 0.4, 1.0) // Background color

// Create a command buffer and render
let commandBuffer = commandQueue.makeCommandBuffer()!
let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
renderEncoder.setRenderPipelineState(pipelineState)

// Draw a simple triangle (example geometry)
let vertices: [Float] = [
    -1.0, -1.0, 0.0, 1.0,  // Bottom-left
     1.0, -1.0, 0.0, 1.0,  // Bottom-right
     0.0,  1.0, 0.0, 1.0   // Top-center
]
let vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Float>.stride * vertices.count, options: [])
renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
renderEncoder.endEncoding()
commandBuffer.commit()
commandBuffer.waitUntilCompleted()

// Read texture data and save to PNG
let bytesPerPixel = 4
let bytesPerRow = bytesPerPixel * width
let pixelData = UnsafeMutableRawPointer.allocate(byteCount: bytesPerRow * height, alignment: bytesPerPixel)

texture.getBytes(pixelData, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)

let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGBitmapInfo.byteOrder32Big.union(.premultipliedLast)
let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

guard let cgImage = context.makeImage() else {
    fatalError("Failed to create CGImage")
}

let url = URL(fileURLWithPath: "./output.png")
let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil)!
CGImageDestinationAddImage(destination, cgImage, nil)
CGImageDestinationFinalize(destination)

print("Image saved to output.png")
pixelData.deallocate()
