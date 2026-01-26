# Makefile for compiling GpuInfo.cu

# Target name
all: ThreadIndexing 

# How to build the target
ThreadIndexing: ThreadIndexing.cu
	nvcc ThreadIndexing.cu -o ThreadIndexing

# Optional: clean up executable
clean:
	rm -f ThreadIndexing
