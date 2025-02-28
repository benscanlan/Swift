#import <Metal/Metal.h>
#import <Foundation/Foundation.h>
#include <iostream>

int main() {
    @autoreleasepool {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        
        if (!device) {
            std::cerr << "Failed to create Metal device\n";
            return -1;
        }
        
        std::cout << "Successfully created Metal device: " << device.name.UTF8String << std::endl;
    }
    return 0;
}
