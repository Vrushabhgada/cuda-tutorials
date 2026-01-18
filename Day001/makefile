# Makefile for compiling GpuInfo.cu

# Target name
all: GpuInfo HelloWorld

# How to build the target
GpuInfo: GpuInfo.cu
	nvcc GpuInfo.cu -o GpuInfo

HelloWorld: HelloWorld.cu
	nvcc HelloWorld.cu -o HelloWorld

# Optional: clean up executable
clean:
	rm -f GpuInfo
	rm -f HelloWorld
