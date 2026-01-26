# Makefile for compiling GpuInfo.cu

# Target name
all: errorMessage 

# How to build the target
errorMessage: errorMessage.cu
	nvcc errorMessage.cu -o errorMessage

# Optional: clean up executable
clean:
	rm -f errorMessage
