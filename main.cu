// Amarjot Singh Parmar
#include <iostream>
#include <math.h>
#include <stdio.h>


__global__
void print(int *gen, int amount){
	
	printf("\nPrinting Current Gen Array !! [x,y,alive] \n");
	printf("[\n");

	int count = 0;

	while(count < amount){
		printf("x : %d, y : %d, alive : %d \n", gen[count], gen[count + 1], gen[count + 2]);
		count = count + 3;
	}

	printf("]");
}

// I can do this in parallel right ?
__global__
void printBoard(int *gen ,int amountofCells, int size){

	int count = 0;
	int rowCount = 0;
	printf("\n");
	while(count < amountofCells){
		count++;
		count++;
		if(gen[count] == 0){
			printf(" . ");
		}else{
			printf(" x ");
		}
		rowCount++;

		if(rowCount == size){
			printf("\n");
			rowCount = 0;
		}

		count++;
		
	}
}

// I can do this in parallel right ?
__global__
void populateArrays(int *gen, int *newGen, int size){
	
	int count = 0;
    for (int y = 0; y < size; y++) {
		for(int x = 0; x < size; x++){

			gen[count] = x;
			newGen[count] = x;
			count++;
			gen[count] = y;
			newGen[count] = y;
			count++;
			gen[count] = 0;
			newGen[count] = 0;
			count++;
		}
	}
}

__global__
void getIndex(int x, int y, int size){
	int result;
	result = y * size;
	result = result + x;
}

__global__
void calculateCells(int *gen, int *newGen){

}

int main(void){
	
	int *gen, *newGen;
	int size = 5;
	int amountofCells = size * size;
	int lengthofArray = ((amountofCells * 2) + amountofCells);
	int loopCount = 0;
	
	printf("User wants size : %d , Total Cells needed : %d , Array Size : %d \n", size, (size * size), lengthofArray);

	// Allocate Unified Memory – accessible from CPU or GPU
    cudaMallocManaged(&gen, lengthofArray*sizeof(int));
	cudaMallocManaged(&newGen, lengthofArray*sizeof(int));

	// populate board
	populateArrays<<<1,1>>>(gen, newGen, size);

	// setting up glider

	// Keep calculating board & printing

	while(loopCount < 1){
		printBoard<<<1,1>>>(gen, lengthofArray, size);
		loopCount++;
	}
	
	// Wait for GPU to finish before accessing on host
	cudaDeviceSynchronize();
	// Free memory
	cudaFree(gen);
	cudaFree(newGen);
	return 0;
}

