#include <metal_stdlib>
using namespace metal;

kernel void hello_kernel(device float *output [[buffer(0)]],
                        uint id [[thread_position_in_grid]]) {
    output[id] = float(id) * 2.0; // Simple multiplication operation
}
