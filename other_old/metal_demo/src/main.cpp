
#include <QuartzCore/QuartzCore.hpp>
#include <iostream>
#include <Metal/Metal.h> // For C
// OR
#include <MetalKit/MetalKit.hpp> // For C++


int main() {
    MTL::Device* device = MTL::CreateSystemDefaultDevice();
    if (!device) {
        std::cerr << "Failed to create Metal device\n";
        return -1;
    }
    
    std::cout << "Metal device created: " << device->name()->utf8String() << std::endl;
    
    // Create command queue
    MTL::CommandQueue* commandQueue = device->newCommandQueue();
    if (!commandQueue) {
        std::cerr << "Failed to create command queue\n";
        return -1;
    }
    
    std::cout << "Command queue created successfully\n";
    
    // Cleanup
    commandQueue->release();
    device->release();
    
    return 0;
}
