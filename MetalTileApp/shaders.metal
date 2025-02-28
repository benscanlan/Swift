#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
};

vertex Vertex vertex_main(const device float4* vertex_array [[buffer(0)]], uint vid [[vertex_id]]) {
    Vertex out;
    out.position = vertex_array[vid];
    return out;
}

fragment float4 fragment_main() {
    return float4(0.8, 0.2, 0.3, 1.0); // Red color
}
