# Day 03: Memory Management

## Host vs Device Memory

In CUDA programming, we work with two separate memory spaces:

| Memory Type     | Location  | Accessible By | Typical Variable Prefix     |
|----|------| ------|--------|
|Host Memory     |CPU RAM    |CPU only       |h_ (e.g., h_array)    |
|Device Memory   |GPU RAM    |GPU only       |d_ (e.g., d_array)    |

### Important Rules

- ❌ CPU cannot directly access GPU memory
- ❌ GPU cannot directly access CPU memory (in general)
- ✅ You must explicitly copy data between host and device
- ✅ Pointers are just addresses - a device pointer is useless on the host!

```
CPU (Host)                           GPU (Device)
┌─────────────────┐                 ┌─────────────────┐
│  Host Memory    │                 │ Device Memory   │
│                 │                 │                 │
│  h_array ───────┼──cudaMemcpy────>│ d_array         │
│  [1,2,3,4,5]    │                 │ [1,2,3,4,5]     │
│                 │<───cudaMemcpy───┤                 │
└─────────────────┘                 └─────────────────┘

```

## 🔧 CUDA Memory Functions
1. `cudaMalloc()` - Allocate GPU Memory

Purpose: Reserve memory on the GPU (like malloc() for CPU).
Syntax:

`cppcudaError_t cudaMalloc(void** devPtr, size_t size);`

Parameters:
- devPtr: Pointer to pointer (address where GPU pointer will be stored)
- size: Number of bytes to allocate


***Example***
```
int *d_array;
int n = 100;
size_t size = n * sizeof(int);

cudaMalloc(&d_array, size);  // Allocate space for 100 integers on GPU
```


2. `cudaMemcpy()` - Copy Data Between Host and Device
Purpose: Transfer data between CPU and GPU memory.
Syntax:
```
cppcudaError_t cudaMemcpy(void* dst, const void* src, size_t count,cudaMemcpyKind kind);
```
Parameters:
- dst: Destination pointer
- src: Source pointer
- count: Number of bytes to copy
- kind: Direction of copy

Copy Directions:

| Direction | Use When | Example |
|----|------| ------|
| cudaMemcpyHostToDevice | CPU → GPU | Sending input data to GPU |
| cudaMemcpyDeviceToHost | GPU → CPU | Getting results from GPU |
| cudaMemcpyDeviceToDevice | GPU → GPU | Copying within GPU memory |
| cudaMemcpyHostToHost | CPU → CPU | Rarely used |

***Example***

```
// Copy data FROM host TO device
cudaMemcpy(d_array, h_array, size, cudaMemcpyHostToDevice);

// Copy data FROM device TO host
cudaMemcpy(h_result, d_result, size, cudaMemcpyDeviceToHost);
```


3. `cudaFree()` - Free GPU Memory

Purpose: Release GPU memory (like free() for CPU).

Syntax:

`cppcudaError_t cudaFree(void* devPtr);`

Example:
```
cppcudaFree(d_array);  // Free GPU memory
```
Key Points:
- Always free GPU memory when done
- GPU memory is limited - memory leaks are serious!
- Only free device pointers, not host pointers