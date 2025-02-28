import Metal
import MetalKit
import AppKit

// Basic vertex structure with normal for lighting
struct Vertex {
    var position: SIMD3<Float>
    var normal: SIMD3<Float>
    var color: SIMD4<Float>
}

// Uniform buffer for lighting and material properties
struct Uniforms {
    var modelMatrix: float4x4
    var viewProjectionMatrix: float4x4
    var normalMatrix: float3x3
    var cameraPosition: SIMD3<Float>
    var lightPosition: SIMD3<Float>
    var ambientColor: SIMD3<Float>
    var lightColor: SIMD3<Float>
    var metallic: Float
    var roughness: Float
}

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var depthState: MTLDepthStencilState!
    var indexBuffer: MTLBuffer!
    var uniformBuffer: MTLBuffer!
    var indexCount: Int = 0
    var rotation: Float = 0
    private var lastUpdateTime: CFTimeInterval?
    private var metalView: MTKView
    
    let shaderSource = """
    #include <metal_stdlib>
    using namespace metal;

    struct Vertex {
        float3 position [[attribute(0)]];
        float3 normal [[attribute(1)]];
        float4 color [[attribute(2)]];
    };

    struct Uniforms {
        float4x4 modelMatrix;
        float4x4 viewProjectionMatrix;
        float3x3 normalMatrix;
        float3 cameraPosition;
        float3 lightPosition;
        float3 ambientColor;
        float3 lightColor;
        float metallic;
        float roughness;
    };

    struct VertexOut {
        float4 position [[position]];
        float3 worldPosition;
        float3 normal;
        float4 color;
    };

    vertex VertexOut vertexShader(const device Vertex *vertices [[buffer(0)]],
                                constant Uniforms &uniforms [[buffer(1)]],
                                uint vertexID [[vertex_id]]) {
        VertexOut out;
        float4 worldPosition = uniforms.modelMatrix * float4(vertices[vertexID].position, 1.0);
        out.position = uniforms.viewProjectionMatrix * worldPosition;
        out.worldPosition = worldPosition.xyz;
        out.normal = uniforms.normalMatrix * vertices[vertexID].normal;
        out.color = vertices[vertexID].color;
        return out;
    }

    float3 fresnelSchlick(float cosTheta, float3 F0) {
        return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
    }

    float DistributionGGX(float3 N, float3 H, float roughness) {
        float a = roughness * roughness;
        float a2 = a * a;
        float NdotH = max(dot(N, H), 0.0);
        float NdotH2 = NdotH * NdotH;

        float num = a2;
        float denom = (NdotH2 * (a2 - 1.0) + 1.0);
        denom = M_PI_F * denom * denom;

        return num / denom;
    }

    float GeometrySchlickGGX(float NdotV, float roughness) {
        float r = (roughness + 1.0);
        float k = (r * r) / 8.0;

        float num = NdotV;
        float denom = NdotV * (1.0 - k) + k;

        return num / denom;
    }

    float GeometrySmith(float3 N, float3 V, float3 L, float roughness) {
        float NdotV = max(dot(N, V), 0.0);
        float NdotL = max(dot(N, L), 0.0);
        float ggx2 = GeometrySchlickGGX(NdotV, roughness);
        float ggx1 = GeometrySchlickGGX(NdotL, roughness);

        return ggx1 * ggx2;
    }

    fragment float4 fragmentShader(VertexOut in [[stage_in]],
                                 constant Uniforms &uniforms [[buffer(1)]]) {
        float3 N = normalize(in.normal);
        float3 V = normalize(uniforms.cameraPosition - in.worldPosition);
        float3 L = normalize(uniforms.lightPosition - in.worldPosition);
        float3 H = normalize(V + L);

        float3 baseColor = in.color.rgb;
        float3 F0 = mix(float3(0.04), baseColor, uniforms.metallic);

        // Calculate light radiance
        float distance = length(uniforms.lightPosition - in.worldPosition);
        float attenuation = 1.0 / (distance * distance);
        float3 radiance = uniforms.lightColor * attenuation;

        // Cook-Torrance BRDF
        float NDF = DistributionGGX(N, H, uniforms.roughness);
        float G = GeometrySmith(N, V, L, uniforms.roughness);
        float3 F = fresnelSchlick(max(dot(H, V), 0.0), F0);

        float3 numerator = NDF * G * F;
        float denominator = 4.0 * max(dot(N, V), 0.0) * max(dot(N, L), 0.0) + 0.0001;
        float3 specular = numerator / denominator;

        float3 kS = F;
        float3 kD = (float3(1.0) - kS) * (1.0 - uniforms.metallic);

        float NdotL = max(dot(N, L), 0.0);

        // Final color
        float3 ambient = uniforms.ambientColor * baseColor;
        float3 color = ambient + (kD * baseColor / M_PI_F + specular) * radiance * NdotL;

        // HDR tonemapping and gamma correction
        color = color / (color + float3(1.0));
        color = pow(color, float3(1.0/2.2));

        return float4(color, 1.0);
    }
    """
    
    init(metalView: MTKView) {
            self.metalView = metalView // Store the reference
            super.init()
            device = metalView.device
            commandQueue = device.makeCommandQueue()
        
        // Enable depth testing
        metalView.depthStencilPixelFormat = .depth32Float
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .lessEqual
        depthDescriptor.isDepthWriteEnabled = true
        depthState = device.makeDepthStencilState(descriptor: depthDescriptor)
        
        // Create vertices for a cube with normals
        let vertices = createCubeVertices()
        
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
        
        // Create uniform buffer
        var uniforms = Uniforms(  // Changed from 'let' to 'var'
            modelMatrix: matrix_identity_float4x4,
            viewProjectionMatrix: matrix_identity_float4x4,
            normalMatrix: matrix_identity_float3x3,
            cameraPosition: SIMD3<Float>(0, 0, 3),
            lightPosition: SIMD3<Float>(2, 2, 2),
            ambientColor: SIMD3<Float>(0.1, 0.1, 0.1),
            lightColor: SIMD3<Float>(1.0, 1.0, 1.0),
            metallic: 0.8,
            roughness: 0.2
        )
        
        uniformBuffer = device.makeBuffer(bytes: &uniforms,
                                        length: MemoryLayout<Uniforms>.size,
                                        options: [])

        
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
        
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float4
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride * 2
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed to create pipeline state: \(error)")
        }
    }
    
    func createCubeVertices() -> [Vertex] {
        let vertices: [Vertex] = [
            // Front face
            Vertex(position: [-0.5, -0.5,  0.5], normal: [ 0.0,  0.0,  1.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5, -0.5,  0.5], normal: [ 0.0,  0.0,  1.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5,  0.5,  0.5], normal: [ 0.0,  0.0,  1.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [-0.5,  0.5,  0.5], normal: [ 0.0,  0.0,  1.0], color: [0.8, 0.8, 0.8, 1]),
            
            // Back face
            Vertex(position: [-0.5, -0.5, -0.5], normal: [ 0.0,  0.0, -1.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5, -0.5, -0.5], normal: [ 0.0,  0.0, -1.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5,  0.5, -0.5], normal: [ 0.0,  0.0, -1.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [-0.5,  0.5, -0.5], normal: [ 0.0,  0.0, -1.0], color: [0.8, 0.8, 0.8, 1]),
            
            // Top face
            Vertex(position: [-0.5,  0.5, -0.5], normal: [ 0.0,  1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5,  0.5, -0.5], normal: [ 0.0,  1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5,  0.5,  0.5], normal: [ 0.0,  1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [-0.5,  0.5,  0.5], normal: [ 0.0,  1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            
            // Bottom face
            Vertex(position: [-0.5, -0.5, -0.5], normal: [ 0.0, -1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5, -0.5, -0.5], normal: [ 0.0, -1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5, -0.5,  0.5], normal: [ 0.0, -1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [-0.5, -0.5,  0.5], normal: [ 0.0, -1.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            
            // Right face
            Vertex(position: [ 0.5, -0.5, -0.5], normal: [ 1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5,  0.5, -0.5], normal: [ 1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5,  0.5,  0.5], normal: [ 1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [ 0.5, -0.5,  0.5], normal: [ 1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            
            // Left face
            Vertex(position: [-0.5, -0.5, -0.5], normal: [-1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [-0.5,  0.5, -0.5], normal: [-1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [-0.5,  0.5,  0.5], normal: [-1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1]),
            Vertex(position: [-0.5, -0.5,  0.5], normal: [-1.0,  0.0,  0.0], color: [0.8, 0.8, 0.8, 1])
        ]
        return vertices
    }
    
    func updateUniforms() {
        guard let uniformBuffer = uniformBuffer else { return }
        
        var uniforms = Uniforms(
            modelMatrix: matrix4x4_rotation(angle: rotation, axis: SIMD3<Float>(0, 1, 0)),
            viewProjectionMatrix: matrix_identity_float4x4,
            normalMatrix: matrix_identity_float3x3,
            cameraPosition: SIMD3<Float>(0, 0, 3),
            lightPosition: SIMD3<Float>(2 * cos(rotation), 2, 2 * sin(rotation)),
            ambientColor: SIMD3<Float>(0.1, 0.1, 0.1),
            lightColor: SIMD3<Float>(1.0, 1.0, 1.0),
            metallic: 0.8,
            roughness: 0.2
        )
        
        // Update view-projection matrix using stored metalView reference
        let aspect = Float(metalView.drawableSize.width) / Float(metalView.drawableSize.height)
        uniforms.viewProjectionMatrix = matrix4x4_perspective(fovy: Float.pi/3, aspect: aspect, near: 0.1, far: 100.0)
        
        // Move the cube back
        uniforms.modelMatrix.columns.3.z = -2.0
        
        // Calculate normal matrix
        let normalMatrix = matrix3x3_upper_left(uniforms.modelMatrix)
        uniforms.normalMatrix = normalMatrix
        
        memcpy(uniformBuffer.contents(), &uniforms, MemoryLayout<Uniforms>.size)
    }
    
    func draw(in view: MTKView) {
        let currentTime = CACurrentMediaTime()
        if lastUpdateTime == nil {
            lastUpdateTime = currentTime
        }
        let deltaTime = currentTime - (lastUpdateTime ?? currentTime)
        lastUpdateTime = currentTime
        
        rotation += Float(deltaTime)
        
        updateUniforms()
        
        guard let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)
        
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

func matrix3x3_upper_left(_ matrix: float4x4) -> float3x3 {
    return float3x3(
        SIMD3<Float>(matrix.columns.0.x, matrix.columns.0.y, matrix.columns.0.z),
        SIMD3<Float>(matrix.columns.1.x, matrix.columns.1.y, matrix.columns.1.z),
        SIMD3<Float>(matrix.columns.2.x, matrix.columns.2.y, matrix.columns.2.z)
    )
}

// Main application setup
let window = NSWindow(
    contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false
)

window.title = "Metallic Cube"
window.center()

guard let device = MTLCreateSystemDefaultDevice() else {
    fatalError("Metal is not supported on this device")
}

let metalView = MTKView(frame: window.contentView!.bounds)
metalView.device = device
metalView.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
metalView.isPaused = false
metalView.enableSetNeedsDisplay = false
metalView.preferredFramesPerSecond = 60
window.contentView = metalView

let renderer = Renderer(metalView: metalView)
metalView.delegate = renderer

window.makeKeyAndOrderFront(nil)
NSApplication.shared.activate(ignoringOtherApps: true)
NSApplication.shared.run()
