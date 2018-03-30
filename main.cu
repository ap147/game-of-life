#include <iostream>
#include <math.h>
#include <stdio.h>

__device__ float *a;

// Kernel function to add the elements of two arrays
__global__
void add(int n, float *x, float *y)
{
  for (int i = 0; i < n; i++)
    y[i] = x[i] + y[i];
}

__global__
void print(int size, int *x, int *y, int *alive)
{
  for (int i = 0; i < 9; i++)
	  printf("x : %d, y : %d , alive : %d \n", x[i], y[i], alive[i]);
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
  int size = 3;
  int count = 0<<0;
  const size_t sz = 10 * sizeof(float);
  float *ah;
     cudaMalloc((void **)&ah, sz);
     cudaMemcpyToSymbol("a", &ah, sizeof(float *), size_t(0),cudaMemcpyHostToDevice);

  // Allocate Unified Memory – accessible from CPU or GPU
  cudaMallocManaged(&xPos, size*sizeof(int));
  cudaMallocManaged(&yPos, size*sizeof(int));
  cudaMallocManaged(&alive, size*sizeof(int));
  cudaMallocManaged(&nextState, size*sizeof(int));

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


  // Run kernel on 1M elements on the GPU
  print<<<1, 1>>>(size, xPos, yPos, alive);


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
/*
 *
  getIndex<<<1,1>>>(1, 0, size, result);
  alive[result] = 1;
  getIndex<<<1,1>>>(2, 1, size, result);
  printf("result : %d \n",result);
  alive[result] = 1;
  getIndex<<<1,1>>>(0, 2, size, result);
  alive[result] = 1;
  getIndex<<<1,1>>>(1, 2, size, result);
  alive[result] = 1;
  getIndex<<<1,1>>>(2, 2, size, result);
  alive[result] = 1;

  print<<<1, 1>>>(size, xPos, yPos, alive);
*/
	cudaDeviceSynchronize();
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
