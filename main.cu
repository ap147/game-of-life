#include <iostream>
#include <math.h>
#include <stdio.h>

__device__ float *a;

// Kernel function to add the elements of two arrays
__global__
void add(int n, float *x, float *y)
{
	  int index = threadIdx.x;
	  int stride = blockDim.x;

  for (int i = index; i < n; i += stride)
    y[i] = x[i] + y[i];
}

__global__
void print(int size, int *x, int *y, int *alive)
{
	  int index = threadIdx.x;
	  int stride = blockDim.x;

	  for (int i = index; i < size; i += stride)
	  printf("COUNT : %d -- x : %d, y : %d , alive : %d \n", x[i], y[i], alive[i]);
}

__global__
void printBoard(int size, int *alive)
{
	int count = 0;
	// initialize x and y arrays on the host
	for (int y = 0; y < size; y++) {
		for(int x = 0; x < size; x++){
			if(alive[count] == 1){
				printf(" x ");
			}
			else{
				printf(" . ");
			}
			count++;
		}
		printf(" \n");
	}
}

__global__
void getIndex(int x, int y, int size){
	int result;
	result = y * size;
	result = result + x;
}

int main(void)
{
  int *xPos, *yPos, *alive, *nextState;
  int size = 30;
  int amount = size * size;
  int count = 0;


  // Allocate Unified Memory – accessible from CPU or GPU
  cudaMallocManaged(&xPos, amount*sizeof(int));
  cudaMallocManaged(&yPos, amount*sizeof(int));
  cudaMallocManaged(&alive, amount*sizeof(int));
  cudaMallocManaged(&nextState, amount*sizeof(int));

  // initialize x and y arrays on the host
  for (int y = 0; y < size; y++) {
	  for(int x = 0; x < size; x++){
		  xPos[count] = x;
		  yPos[count] = y;
		  alive[count] = 0;
		  nextState[count] = 0;
		  count++;
	  }
  }

  // Get GPU to do this.
  int result;
	result = 0 * size;
	result = result + 1;
	alive[result] = 1;

	result = 1 * size;
	result = result + 2;
	alive[result] = 1;

	result = 2 * size;
	result = result + 0;
	alive[result] = 1;

	result = 2 * size;
	result = result + 1;
	alive[result] = 1;

	result = 2 * size;
	result = result + 2;
	alive[result] = 1;

  printBoard<<<1, 1>>>(size, alive);

  // setupGlider<<<1,1>>>(xPos, yPos, alive);
  // Wait for GPU to finish before accessing on host
  cudaDeviceSynchronize();

  // Free memory
  cudaFree(xPos);
  cudaFree(yPos);
  cudaFree(alive);
  cudaFree(nextState);

  return 0;
}

