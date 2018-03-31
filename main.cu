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

__device__
int getIndex(int x, int y, int size){
	// (size * 3) * y + (x * 3)
	int result;
	result = (size * 3) * y;
	result = result + (x * 3);
	return result;
}

__global__ 
void setupGlider(int *gen, int size){

	int index;
	index = getIndex(1,0,size) + 2;
	gen[index] = 1;

	index = getIndex(2,1,size) + 2;
	gen[index] = 1;

	index = getIndex(0,2,size) + 2;
	gen[index] = 1;

	index = getIndex(1,2,size) + 2;
	gen[index] = 1;

	index = getIndex(2,2,size) + 2;
	gen[index] = 1;
}


__device__
int getCellNeighbours(int xPos, int yPos){
	return 0;
}
__device__
void cellNextCycle(int *gen, int *newGen, int n){
	int neighbours = 0;

	  // Any live cell
	if (gen[2]== 1)
	{
		//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
		if (neighbours < 2)
		{
			//cells[y][x].nextState = 0;
		} //Any live cell with more than three live neighbours dies, as if by overpopulation.
		else if (neighbours == 2 || neighbours == 3)
		{
			//cells[y][x].nextState = 1;
		}
		else if (neighbours > 3)
		{
			//cells[y][x].nextState = 0;
		}
	}
	else
	{
		//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
		if (neighbours == 3 && gen[3] == 0)
		{
			//cells[y][x].nextState = 1;
		}
	}
}

// Gets every cells next value which gets stored in newGen
// 
__global__
void calculateBoard(int *gen, int *newGen){





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

	// set up glider
	setupGlider<<<1,1>>>(gen, size);

	// Keep calculating board & printing
	while(loopCount < 1){
		printBoard<<<1,1>>>(gen, lengthofArray, size);
		//calculateBoard<<1,amountofCells>>>(gen, newGen);
		loopCount++;
	}
	
	// Wait for GPU to finish before accessing on host
	cudaDeviceSynchronize();
	// Free memory
	cudaFree(gen);
	cudaFree(newGen);
	return 0;
}

