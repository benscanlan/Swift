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
                            constant float4x4 &modelMatrix [[buffer(1)]]) {
    VertexOut out;
    float4 position = float4(vertices[vertexID].position, 1.0);
    out.position = modelMatrix * position;
    out.color = vertices[vertexID].color;
    return out;
}

fragment float4 fragmentShader(VertexOut in [[stage_in]]) {
    return in.color;
}

