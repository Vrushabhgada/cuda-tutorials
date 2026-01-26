# Day 04: Error Checking

Till now, while calling any API, we have not checked what it is returning. All CUDA APIs return an error code stating if it is a success or failure.

## CUDA Error Types

### `cudaError_t` Enum

CUDA functions return a `cudaError_t` value indicating success or failure.

**Common Error Codes:**

| Error Code | Meaning | Common Cause |  
|------------|---------|--------------|
| `cudaSuccess` | No error (value = 0) | Everything worked! |
| `cudaErrorMemoryAllocation` | Out of memory | Allocating too much GPU memory |
| `cudaErrorInvalidValue` | Invalid argument | Wrong parameters to function |
| `cudaErrorInvalidDevicePointer` | Bad pointer | Using host pointer on device |
| `cudaErrorLaunchFailure` | Kernel launch failed | Invalid grid/block configuration |
| `cudaErrorInvalidConfiguration` | Invalid kernel config | Too many threads per block |
| `cudaErrorUnknown` | Unknown error | Something very wrong! |

**Full list:** See [CUDA Runtime API Error Codes](https://docs.nvidia.com/cuda/cuda-runtime-api/group__CUDART__TYPES.html#group__CUDART__TYPES_1g3f51e3575c2178246db0a94a430e0038)

---

## Error Checking Functions

### 1. `cudaGetErrorString()` - Get Error Message

Converts error code to human-readable string.

**Syntax:**
```cpp
const char* cudaGetErrorString(cudaError_t error);
```

**Example:**
```cpp
cudaError_t err = cudaMalloc(&d_array, size);
if (err != cudaSuccess) {
    printf("Error: %s\n", cudaGetErrorString(err));
}
```

---

### 2. `cudaGetLastError()` - Check for Kernel Errors

Gets the last error from a kernel launch (clears the error).

**Syntax:**
```cpp
cudaError_t cudaGetLastError(void);
```

**Example:**
```cpp
myKernel<<<blocks, threads>>>(args);
cudaError_t err = cudaGetLastError();
if (err != cudaSuccess) {
    fprintf(stderr, "Kernel launch failed: %s\n", cudaGetErrorString(err));
}
```
