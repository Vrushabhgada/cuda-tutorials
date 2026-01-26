/**
 * @file ThreadIndexing.cu
 * @brief Pure thread indexing demonstration - no memory transfers
 * @author Vrushabh Gada
 * @date 19th January 2026
 */

#include <stdio.h>

__global__ void printThreadInfo(void)
{
    // Calculate global thread index
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    printf("Global ID: %2d | Block: %d | Thread in Block: %2d | Formula: %d * %d + %d = %d\n",
           idx,
           blockIdx.x,
           threadIdx.x,
           blockIdx.x, blockDim.x, threadIdx.x,
           idx);
}

int main(void)
{
    int numBlocks = 4;
    int threadsPerBlock = 8;

    printf("Launching %d blocks with %d threads each (Total: %d threads)\n\n",
           numBlocks, threadsPerBlock, numBlocks * threadsPerBlock);

    printf("Understanding: idx = blockIdx.x * blockDim.x + threadIdx.x\n\n");

    // Launch kernel
    printThreadInfo<<<numBlocks, threadsPerBlock>>>();

    // Wait for GPU to finish
    cudaDeviceSynchronize();

    printf("\nNotice how each thread gets a unique global ID from 0 to %d\n",
           numBlocks * threadsPerBlock - 1);

    return 0;
}
