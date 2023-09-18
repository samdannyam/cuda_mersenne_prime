#include <iostream>
#include <cuda_runtime.h>

// Kernel function to fill the device array with true values (1)
__global__ void fillValues(bool *array, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        array[idx] = true;
    }
}

void fillSize(int arraySize){
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

    //calculate
    

    // Clean up
    cudaFree(d_array);
    delete[] h_array;
}
int main() {
    int max= 100000000;
    for(int i=82589933; i<max; i+=2){
        fillSize(i);
    }

    return 0;
}
