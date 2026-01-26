/**
 * @file ThreadIndexing.cu
 * @brief Pure thread indexing demonstration - no memory transfers
 * @author Vrushabh Gada
 * @date 19th January 2026
 */


#include <stdio.h>


__global__ void vectorAdd(int* a, int* b, int* c, int n)
{
    // Calculate global thread index
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < n)
    {
        // Perform vector addition
        c[idx] = a[idx] + b[idx];
    }
}

int main(void)
{
    int firstArray[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int secondArray[] = {10, 9, 8, 7, 6, 5, 4, 3, 2, 1};

    int arraySize = sizeof(firstArray) / sizeof(firstArray[0]);

    int* d_firstArray;
    int* d_secondArray;

    // Allocate device(GPU) memory
    cudaMalloc((void**)&d_firstArray, arraySize * sizeof(int));
    cudaMalloc((void**)&d_secondArray, arraySize * sizeof(int));

    // Copy data from host(CPU) to device(GPU)
    cudaMemcpy(d_firstArray, firstArray, arraySize * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_secondArray, secondArray, arraySize * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel with 1 block and arraySize threads
    vectorAdd<<<1, arraySize>>>(d_firstArray, d_secondArray, d_firstArray, arraySize);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // Copy result from device(GPU) to host(CPU)
    cudaMemcpy(firstArray, d_firstArray, arraySize * sizeof(int), cudaMemcpyDeviceToHost);

    // Print the resultant array
    printf("Resultant Array: \n");
    for (int i = 0; i < arraySize; i++)
    {
        printf("%d ", firstArray[i]);
    }
    printf("\n");

    // Free device memory
    cudaFree(d_firstArray);
    cudaFree(d_secondArray);    

    return 0;
}