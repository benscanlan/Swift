import Metal
import MetalKit
import AppKit

// Basic vertex structure
struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var depthState: MTLDepthStencilState!
    var indexBuffer: MTLBuffer!
    var indexCount: Int = 0
    var rotation: Float = 0
    
    let shaderSource = """
    #include <metal_stdlib>
    using namespace metal;

    struct Vertex {
        float3 position [[attribute(0)]];
        float4 color [[attribute(1)]];
    };

    struct VertexOut {
        float4 position [[position]];
        float4 color;
    };

    vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                                constant Vertex *vertices [[buffer(0)]],
                                constant float4x4 &modelMatrix [[buffer(1)]],
                                constant float4x4 &projectionMatrix [[buffer(2)]]) {
        VertexOut out;
        float4 position = float4(vertices[vertexID].position, 1.0);
        out.position = projectionMatrix * modelMatrix * position;
        out.color = vertices[vertexID].color;
        return out;
    }

    fragment float4 fragmentShader(VertexOut in [[stage_in]]) {
        return in.color;
    }
    """
    
    init(metalView: MTKView) {
        super.init()
        device = metalView.device
        commandQueue = device.makeCommandQueue()
        
        // Enable depth testing
        metalView.depthStencilPixelFormat = .depth32Float
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .lessEqual
        depthDescriptor.isDepthWriteEnabled = true
        depthState = device.makeDepthStencilState(descriptor: depthDescriptor)
        
        // Create vertices for a cube
        let vertices = [
            // Front face (Red)
            Vertex(position: [-0.5, -0.5,  0.5], color: [1, 0, 0, 1]),
            Vertex(position: [ 0.5, -0.5,  0.5], color: [1, 0, 0, 1]),
            Vertex(position: [ 0.5,  0.5,  0.5], color: [1, 0, 0, 1]),
            Vertex(position: [-0.5,  0.5,  0.5], color: [1, 0, 0, 1]),
            
            // Back face (Green)
            Vertex(position: [-0.5, -0.5, -0.5], color: [0, 1, 0, 1]),
            Vertex(position: [ 0.5, -0.5, -0.5], color: [0, 1, 0, 1]),
            Vertex(position: [ 0.5,  0.5, -0.5], color: [0, 1, 0, 1]),
            Vertex(position: [-0.5,  0.5, -0.5], color: [0, 1, 0, 1]),
            
            // Top face (Blue)
            Vertex(position: [-0.5,  0.5, -0.5], color: [0, 0, 1, 1]),
            Vertex(position: [ 0.5,  0.5, -0.5], color: [0, 0, 1, 1]),
            Vertex(position: [ 0.5,  0.5,  0.5], color: [0, 0, 1, 1]),
            Vertex(position: [-0.5,  0.5,  0.5], color: [0, 0, 1, 1]),
            
            // Bottom face (Yellow)
            Vertex(position: [-0.5, -0.5, -0.5], color: [1, 1, 0, 1]),
            Vertex(position: [ 0.5, -0.5, -0.5], color: [1, 1, 0, 1]),
            Vertex(position: [ 0.5, -0.5,  0.5], color: [1, 1, 0, 1]),
            Vertex(position: [-0.5, -0.5,  0.5], color: [1, 1, 0, 1]),
            
            // Right face (Purple)
            Vertex(position: [ 0.5, -0.5, -0.5], color: [1, 0, 1, 1]),
            Vertex(position: [ 0.5,  0.5, -0.5], color: [1, 0, 1, 1]),
            Vertex(position: [ 0.5,  0.5,  0.5], color: [1, 0, 1, 1]),
            Vertex(position: [ 0.5, -0.5,  0.5], color: [1, 0, 1, 1]),
            
            // Left face (Cyan)
            Vertex(position: [-0.5, -0.5, -0.5], color: [0, 1, 1, 1]),
            Vertex(position: [-0.5,  0.5, -0.5], color: [0, 1, 1, 1]),
            Vertex(position: [-0.5,  0.5,  0.5], color: [0, 1, 1, 1]),
            Vertex(position: [-0.5, -0.5,  0.5], color: [0, 1, 1, 1])
        ]
        
        let indices: [UInt16] = [
            0,  1,  2,  2,  3,  0,  // Front
            4,  5,  6,  6,  7,  4,  // Back
            8,  9,  10, 10, 11, 8,  // Top
            12, 13, 14, 14, 15, 12, // Bottom
            16, 17, 18, 18, 19, 16, // Right
            20, 21, 22, 22, 23, 20  // Left
        ]
        
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                       length: vertices.count * MemoryLayout<Vertex>.stride,
                                       options: [])
        
        indexBuffer = device.makeBuffer(bytes: indices,
                                      length: indices.count * MemoryLayout<UInt16>.size,
                                      options: [])
        indexCount = indices.count
        
        // Create shader library and pipeline
        var library: MTLLibrary?
        do {
            library = try device.makeLibrary(source: shaderSource, options: nil)
        } catch {
            fatalError("Failed to create shader library: \(error)")
        }
        
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = metalView.depthStencilPixelFormat
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed to create pipeline state: \(error)")
        }
    }
    
    func draw(in view: MTKView) {
        guard let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        rotation += 0.02
        
        // Create model matrix (rotation and slight tilt)
        var modelMatrix = matrix4x4_rotation(angle: rotation, axis: SIMD3<Float>(0, 1, 0))
        modelMatrix = matrix_multiply(matrix4x4_rotation(angle: 0.5, axis: SIMD3<Float>(1, 0, 0)), modelMatrix)
        
        // Create perspective projection matrix
        let aspect = Float(view.drawableSize.width / view.drawableSize.height)
        var projectionMatrix = matrix4x4_perspective(fovy: Float.pi/3, aspect: aspect, near: 0.1, far: 100.0)
        
        // Move the cube back so we can see it
        modelMatrix.columns.3.z = -2.0
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBytes(&modelMatrix, length: MemoryLayout<float4x4>.size, index: 1)
        renderEncoder.setVertexBytes(&projectionMatrix, length: MemoryLayout<float4x4>.size, index: 2)
        
        renderEncoder.drawIndexedPrimitives(type: .triangle,
                                          indexCount: indexCount,
                                          indexType: .uint16,
                                          indexBuffer: indexBuffer,
                                          indexBufferOffset: 0)
        
        renderEncoder.endEncoding()
        
        if let drawable = view.currentDrawable {
            commandBuffer.present(drawable)
        }
        
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}

// Matrix helper functions
func matrix4x4_perspective(fovy: Float, aspect: Float, near: Float, far: Float) -> float4x4 {
    let yScale = 1 / tan(fovy * 0.5)
    let xScale = yScale / aspect
    let zRange = far - near
    let zScale = -(far + near) / zRange
    let wzScale = -2 * far * near / zRange
    
    return float4x4(
        [xScale, 0, 0, 0],
        [0, yScale, 0, 0],
        [0, 0, zScale, -1],
        [0, 0, wzScale, 0]
    )
}

func matrix4x4_rotation(angle: Float, axis: SIMD3<Float>) -> float4x4 {
    let normalized = normalize(axis)
    let cos = cosf(angle)
    let cosp = 1 - cos
    let sin = sinf(angle)
    
    return float4x4(
        [
            cos + cosp * normalized.x * normalized.x,
            cosp * normalized.x * normalized.y + normalized.z * sin,
            cosp * normalized.x * normalized.z - normalized.y * sin,
            0,
        ],
        [
            cosp * normalized.x * normalized.y - normalized.z * sin,
            cos + cosp * normalized.y * normalized.y,
            cosp * normalized.y * normalized.z + normalized.x * sin,
            0,
        ],
        [
            cosp * normalized.x * normalized.z + normalized.y * sin,
            cosp * normalized.y * normalized.z - normalized.x * sin,
            cos + cosp * normalized.z * normalized.z,
            0,
        ],
        [0, 0, 0, 1]
    )
}

// Main application setup
let window = NSWindow(
    contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false
)

window.title = "3D Metal Cube"
window.center()

guard let device = MTLCreateSystemDefaultDevice() else {
    fatalError("Metal is not supported on this device")
}

let metalView = MTKView(frame: window.contentView!.bounds)
metalView.device = device
metalView.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
// Remove this line as it prevents continuous rendering
// metalView.enableSetNeedsDisplay = true
// Add these lines instead:
metalView.isPaused = false
metalView.enableSetNeedsDisplay = false
metalView.preferredFramesPerSecond = 60

window.contentView = metalView

let renderer = Renderer(metalView: metalView)
metalView.delegate = renderer

window.makeKeyAndOrderFront(nil)
NSApplication.shared.activate(ignoringOtherApps: true)
NSApplication.shared.run()
