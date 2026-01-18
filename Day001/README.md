# Getting Started with GPU Programming

## GPU Architecture

* A GPU has multiple **Streaming Multiprocessors (SMs)**.
* An SM can execute multiple **blocks** simultaneously.
* An SM can run up to ~1024 **hardware threads** simultaneously across all its blocks.
* A **block** can contain up to 1024 **software threads**.
* A **warp** is a group of **32 threads** (hardware scheduling unit).
* Only **warps** are allowed to context switch. 



## Blocks and Threads Summary

1. **Block**

   * A group of threads.
   * Max threads per block: **1024** (example: GTX 1650).

2. **Thread Count**

   * Should ideally be a **multiple of 32** (warp size = 32).
   * Valid counts: 32, 64, 96, 128, 160, 192, 224, 256, 512, 1024.
   * Recommended: **256 threads per block** (common in practice).
   * Example: If you launch 10 threads, 22 threads of the warp are idle until the 10 finish execution.

3. **Concurrent Execution**

   * Depends on GPU hardware.
   * GTX 1650: ~14,336 threads can run simultaneously.
   * You can launch **millions of threads** in total (hardware handles scheduling).

4. **Number of Blocks**
   * Practically unlimited.


## Important Note on Blocks and Warps

- **A block is always assigned to a single SM.**  
- Example: If a block has **64 threads**, it consists of **2 warps** (warp size = 32).  
- **Both warps of this block will execute on the same SM.**  
- **It will never happen** that one warp of the block runs on SM0 and the other warp runs on SM1.  

- ✅ SMs can run **multiple blocks concurrently**, but **each block never spans multiple SMs**.


To find out how many sm and threads do your GPU have execute [GpuInfo.cu](./GpuInfo.cu)

## Execution Space Qualifiers

Execution space qualifiers define **where a function runs** and **from where it can be called**.

### Types of Qualifiers

| Qualifier             | Runs On   | Called From                         | Notes                                           |
| --------------------- | --------- | ----------------------------------- | ----------------------------------------------- |
| `__global__`          | GPU       | CPU (using `<<<blocks, threads>>>`) | Must return `void`, entry point for GPU kernels |
| `__device__`          | GPU       | GPU only                            | Helper function for GPU code                    |
| `__host__`            | CPU       | CPU only                            | Default for normal C/C++ functions              |
| `__host__ __device__` | CPU & GPU | CPU & GPU                           | Useful for shared utility functions             |

To see the use of the qualifiers, execute [HelloWorld.cu](./HelloWorld.cu)

**Important:**

* `__global__` **cannot** be combined with any other qualifier.
* `__host__ __device__` is the only allowed combination.

---

### Quick Recap

* GPU → Multiple SMs → Each SM → Multiple blocks → Each block → Up to 1024 threads → Threads grouped in warps of 32.
* Always consider **threads per block as multiples of 32** for efficiency.
* **Execution qualifiers** control where functions run and who can call them.

### NOTE
Compiler used: `nvc` (NVIDIA HPC compiler), not `gcc`.
