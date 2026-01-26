/**
 * @author Vrushabh Gada
 * @file GpuInfo.cu
 * @date 18th January 2026
 * @brief This program retrieves and displays information about the CUDA-capable GPUs
*/

#include <iostream>
#include <cuda_runtime.h>

int main() {
    int deviceCount = 0;
    // Get the number of CUDA-capable devices
    cudaError_t err = cudaGetDeviceCount(&deviceCount);

    if (err != cudaSuccess) {
        std::cerr << "Error getting device count: " << cudaGetErrorString(err) << std::endl;
        return 1;
    }

    std::cout << "Number of CUDA devices: " << deviceCount << std::endl;

    // Iterate through each device and print its properties
    for (int dev = 0; dev < deviceCount; ++dev) {
        cudaDeviceProp deviceProp;
        cudaGetDeviceProperties(&deviceProp, dev);

        std::cout << "Device " << dev << ": " << deviceProp.name << std::endl;
        std::cout << "  Number of SMs: " << deviceProp.multiProcessorCount << std::endl;
        std::cout << "  Max threads per SM: " << deviceProp.maxThreadsPerMultiProcessor << std::endl;
        std::cout << "  Max threads per block: " << deviceProp.maxThreadsPerBlock << std::endl;
        std::cout << "  Warp size: " << deviceProp.warpSize << std::endl;
        std::cout << "------------------------" << std::endl;
    }

    return 0;
}
