
/**
 * @file errorMessage.cu
 * @brief Simple example of wrong pointer usage with cudaMalloc
 * @author Vrushabh Gada
 * @date 22nd January 2026
 */
#include <stdio.h>

int main(void)
{
    int *d_array;
    
    // Try to allocate 1 TB (way too much!)
    size_t huge_size = (size_t)1024 * 1024 * 1024 * 1024;  // 1 TB
    
    cudaError_t err = cudaMalloc(&d_array, huge_size);
    
    if (err != cudaSuccess) {
        printf("❌ cudaMalloc failed: %s\n", cudaGetErrorString(err));
        return -1;
    }
    
    printf("✓ d_array = %p\n", (void*)d_array);
    cudaFree(d_array);
    
    return 0;
}
