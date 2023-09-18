#include <iostream>
#include <cuda_runtime.h>

// Kernel function to fill the device array with true values (1)
__global__ void fillTrueValues(bool *array, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        array[idx] = true;
    }
}

int main() {
    int arraySize = 1000;
    size_t arrayBytes = arraySize * sizeof(bool);

    // Allocate device memory
    bool *d_array;
    cudaMalloc((void**)&d_array, arrayBytes);

    // Set grid and block sizes
    int blockSize = 256;
    int gridSize = (arraySize + blockSize - 1) / blockSize;

    // Launch the kernel to fill the array with true values
    fillTrueValues<<<gridSize, blockSize>>>(d_array, arraySize);

    // Copy the result back to the host if needed
    bool *h_array = new bool[arraySize];
    cudaMemcpy(h_array, d_array, arrayBytes, cudaMemcpyDeviceToHost);

    print
    for(int i=0;i<arraySize;i++)
        std::cout<<h_array[i];

    // Clean up
    cudaFree(d_array);
    delete[] h_array;

    return 0;
}
