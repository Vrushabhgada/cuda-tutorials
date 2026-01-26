/**
 * @author Vrushabh Gada
 * @file HelloWorld.cu
 * @date 18th January 2026
 * @brief This program demonstrates a simple "Hello World" example using CUDA, showing how to run code on both CPU and GPU.
*/


#include <stdio.h>

// This funtion can be executed on both CPU and GPU (via function call not directly)
__device__ __host__ void helloFromBoth(void)
{
    printf("Hello World from both CPU and GPU!\n");
}




// This funtion can only be executed on the CPU
void helloFromCPU(void)
{
    printf("Hello World from CPU!\n");
}

// This funtion can only be executed on the CPU
__host__ void helloFromCPU2(void)
{
    printf("Hello World from CPU 2!\n");
}

// This funtion can only be executed on the GPU via function call not directly
__device__ void helloFromGPU2(void)
{
    printf("Hello World from GPU 2!\n");
}

// This funtion can only be executed on the GPU
__global__ void helloFromGPU(void)
{
    printf("Hello World from GPU!\n");
    helloFromGPU2();
    helloFromBoth();
}

// The main function - execution starts here
int main(void)
{

    // This function runs on CPU
    helloFromCPU();
    helloFromCPU2();
    helloFromBoth();

    // It is not allwoed to run on CPU
    // helloFromGPU();

    // Launch the kernel with a single block and a single thread
    helloFromGPU<<<1, 1>>>();
    // -------- **NOTE : the following API is used to wait for the GPU to finish its work** --------
    // Wait for the GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // helloFromCPU<<<1,1>>>(); // This is not allowed and will cause a compilation error
    // helloFromBoth<<<1,1>>>(); // This is not allowed and will cause a compilation error

    // Launch the kernel with a two block and a single thread
    helloFromGPU<<<2, 1>>>();

    // Wait for the GPU to finish before accessing on host
    cudaDeviceSynchronize();

    return 0;
}