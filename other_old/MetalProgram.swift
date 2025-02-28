import Foundation
import MetalKit
import CoreImage

let device = MTLCreateSystemDefaultDevice()!
let commandQueue = device.makeCommandQueue()!

// Create a texture to draw into
let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: 800, height: 600, mipmapped: false)
descriptor.usage = [.shaderWrite, .shaderRead]
let texture = device.makeTexture(descriptor: descriptor)!

// Create a command buffer
let commandBuffer = commandQueue.makeCommandBuffer()!
let blitEncoder = commandBuffer.makeBlitCommandEncoder()!

// Calculate the clear color as UInt32 for RGBA8Unorm
let clearColor = MTLClearColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1)
let redComponent = UInt8(clearColor.red * 255)
let greenComponent = UInt8(clearColor.green * 255)
let blueComponent = UInt8(clearColor.blue * 255)
let alphaComponent = UInt8(clearColor.alpha * 255)
let clearValue: UInt32 = (UInt32(alphaComponent) << 24) | (UInt32(blueComponent) << 16) | (UInt32(greenComponent) << 8) | UInt32(redComponent)

// Fill the texture with the clear color
blitEncoder.fill(buffer: texture.makeBufferView(), range: 0..<texture.length, value: UInt8(clearValue & 0xFF))

blitEncoder.endEncoding()

commandBuffer.commit()
commandBuffer.waitUntilCompleted()

// Save the texture to a PNG file
if let cgImage = CIContext(mtlDevice: device).createCGImage(MTLTextureToCIImage(texture: texture), from: CGRect(x: 0, y: 0, width: texture.width, height: texture.height)) {
    let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
    if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
        try! pngData.write(to: URL(fileURLWithPath: "output.png"))
    }
}

print("Image saved as output.png")

func MTLTextureToCIImage(texture: MTLTexture) -> CIImage {
    return CIImage(mtlTexture: texture, options: nil)!
}

