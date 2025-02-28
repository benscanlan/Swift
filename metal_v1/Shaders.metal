#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float2 texCoords [[attribute(1)]];
};

struct RasterizerData {
    float4 position [[position]];
    float2 texCoords;
};

vertex RasterizerData vertexShader(const VertexIn vertices [[stage_in]]) {
    RasterizerData out;
    out.position = vertices.position;
    out.texCoords = vertices.texCoords;
    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {
    float3 color = float3(in.texCoords.x, in.texCoords.y, 0.5);
    return float4(color, 1.0);
}


