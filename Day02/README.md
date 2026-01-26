# Day 02: Thread Indexing

## Grid

* A **GPU** has multiple **Streaming Multiprocessors (SMs)** (physical hardware).

* A **Grid** is the complete collection of all blocks you launch in a kernel call.
  - Grid exists at the **software/logical level**
  - When you write `<<<numBlocks, threadsPerBlock>>>`, you're defining the grid size
  - Example: `<<<100, 256>>>` creates a grid with 100 blocks

* The **GPU scheduler** distributes blocks from the grid across available SMs.
  - Multiple blocks from the grid can run on one SM simultaneously
  - Blocks are assigned to SMs dynamically (you don't control which block goes where)

* An **SM** can execute multiple **blocks** simultaneously (from the grid).
```
GPU (Physical Device)
│
├── Grid (Logical organization of ALL blocks in your kernel launch)
│   │
│   ├── SM 0 (Physical hardware)
│   │   ├── Block 0 (assigned to this SM)
│   │   │   ├── Warp 0 (threads 0-31)
│   │   │   ├── Warp 1 (threads 32-63)
│   │   │   ├── Warp 2 (threads 64-95)
│   │   │   └── ... (up to 1024 threads per block)
│   │   ├── Block 3 (also assigned to this SM)
│   │   └── Block 7 (also assigned to this SM)
│   │
│   ├── SM 1 (Physical hardware)
│   │   ├── Block 1 (assigned to this SM)
│   │   ├── Block 4 (also assigned to this SM)
│   │   └── Block 8 (also assigned to this SM)
│   │
│   ├── SM 2 (Physical hardware)
│   │   ├── Block 2 (assigned to this SM)
│   │   ├── Block 5 (also assigned to this SM)
│   │   └── Block 9 (also assigned to this SM)
│   │
│   └── ... more SMs
```

## Key Built-in Variables

CUDA provides special built-in variables inside kernels:

| Variable | Type | Description | 
|----------|------|-------------|
| `threadIdx` | `uint3` | Thread index within its block (access via `.x`, `.y`, `.z`) | 
| `blockIdx` | `uint3` | Block index within the grid (access via `.x`, `.y`, `.z`) |
| `blockDim` | `dim3` | Number of threads per block (access via `.x`, `.y`, `.z`) | 
| `gridDim` | `dim3` | Number of blocks in the grid (access via `.x`, `.y`, `.z`) | 

**Note:** The variable names are `threadIdx`, `blockIdx`, `blockDim`, and `gridDim` (not `threadIdx.x` - that's how you access the x component).

### Data Type Definitions
```cpp
// uint3 definition
struct uint3 {
    unsigned int x;
    unsigned int y;
    unsigned int z;
};

// dim3 definition
struct dim3 {
    unsigned int x;
    unsigned int y;
    unsigned int z;
    
    // Constructor with default values
    __host__ __device__ dim3(unsigned int x = 1, unsigned int y = 1, unsigned int z = 1)
        : x(x), y(y), z(z) {}
};
```

Both `uint3` and `dim3` are **almost the same thing** - both hold three numbers (x, y, z). 
The difference is just **how you use them**:

- **`dim3`** is used **by you** (the programmer) when launching kernels to specify sizes
- **`uint3`** is used **by CUDA** to provide index/position information to kernels
- You can only **read** values from `threadIdx` and `blockIdx` (which are `uint3`)
- You **specify** values for grid and block dimensions using `dim3`

### Bottom Line

- **`dim3`** = You tell CUDA "how many" (**sizes/dimensions**)
- **`uint3`** = CUDA tells each thread "you are number..." (**positions/indices**)

---

## Why Thread Indexing Matters

Without proper indexing, all threads would execute the same code on the same data - no parallelism!

**With indexing**, each thread gets a unique ID and processes its own data element:
```
Thread 0 → processes data[0]
Thread 1 → processes data[1]
Thread 2 → processes data[2]
...
```

## The Most Important Formula in CUDA
```cpp
int idx = blockIdx.x * blockDim.x + threadIdx.x;
           ↑              ↑              ↑
           |              |              |
     Which block?   Threads per    Thread within
                       block          block
```

### Breaking Down the Formula

- `blockIdx.x * blockDim.x` = How many threads came before this block
- `+ threadIdx.x` = Add this thread's position within its block
- Result: Unique global index for each thread

### Visual Example

Imagine we have 3 blocks, each with 4 threads:
```
Block 0:          Block 1:          Block 2:
Thread 0 → idx 0  Thread 0 → idx 4  Thread 0 → idx 8
Thread 1 → idx 1  Thread 1 → idx 5  Thread 1 → idx 9
Thread 2 → idx 2  Thread 2 → idx 6  Thread 2 → idx 10
Thread 3 → idx 3  Thread 3 → idx 7  Thread 3 → idx 11
```

**Calculation Examples:**

- **Block 1, Thread 2:** `idx = 1 * 4 + 2 = 6`
- **Block 2, Thread 3:** `idx = 2 * 4 + 3 = 11`

---

## Code Example

To see the implementation in action, check out [ThreadIndexing.cu](./ThreadIndexing.cu)

This example demonstrates:
- How to calculate global thread indices
- How `blockIdx`, `threadIdx`, and `blockDim` work together
- How each thread gets a unique ID


## Key Takeaways

1. **Grid** = All blocks you launch (software concept)
2. **SMs** = Physical processors that execute blocks (hardware)
3. **Built-in variables** tell each thread its position
4. **Global index formula:** `idx = blockIdx.x * blockDim.x + threadIdx.x`
5. Each thread uses its unique index to process different data
