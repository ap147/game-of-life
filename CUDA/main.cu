// Amarjot Singh Parmar
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <unistd.h>

__device__
int getIndex(int x, int y, int rows){
	// (size * 3) * y + (x * 3)
	int result;
	result = (rows * 3) * y;
	result = result + (x * 3);
	return result;
}

__device__
int checkLeft(int index, int *gen, int rows)
{
	int indexNeighbour;

	int x = gen[index];
	int y = gen[index + 1];

	// 1
	if (x == 0)
	{
		indexNeighbour = getIndex((rows - 1), y, rows);
	} // 2
	else
	{
		indexNeighbour = getIndex((x - 1), y, rows);
		//indexNeighbour = index - 3;
	}

	if (gen[indexNeighbour + 2] == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int checkRight(int index, int *gen, int rows)
{
	int indexNeighbour;

	int x = gen[index];
	int y = gen[index + 1];

	// 1
	if (x == rows -1)
	{
		indexNeighbour = getIndex(0, y, rows);
	} // 2
	else
	{
		indexNeighbour = getIndex((x + 1), y, rows);
	}

	if (gen[indexNeighbour + 2] == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int checkTop(int index, int *gen, int rows, int columns)
{
	int indexNeighbour;

	int x = gen[index];
	int y = gen[index + 1];
	
	// 1
	if (y == 0)
	{
		indexNeighbour = getIndex(x , columns - 1, rows);
	} // 2
	else
	{
		indexNeighbour = getIndex(x , (y - 1), rows);
	}

	if (gen[indexNeighbour + 2] == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int checkBottom(int index, int *gen, int rows, int columns)
{
	int indexNeighbour;

	int x = gen[index];
	int y = gen[index + 1];;

	// 1
	if (y == columns - 1)
	{
		indexNeighbour = getIndex(x , 0 , rows);
	} // 2
	else
	{
		indexNeighbour = getIndex(x, (y + 1), rows);
	}
	
	if (gen[indexNeighbour + 2] == 1) 
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int checkDiagonalTL(int index, int *gen, int rows, int columns)
{
	int indexNeighbour;

	int x = gen[index];
	int y = gen[index + 1];

	int xNeighbour; 
	int yNeighbour;

	// 1
	if (x == 0 && y == 0)
	{
		xNeighbour = rows - 1;
		yNeighbour = columns - 1;
		indexNeighbour = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 2
	else if (y == 0)
	{
		xNeighbour = x - 1;
		yNeighbour = columns - 1;
		indexNeighbour = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 3
	else if (x == 0)
	{
		indexNeighbour = getIndex((rows -1), y - 1, rows);//index - 3;//getIndex((rows - 1), gen[index - 2));
	}
	// 4
	else
	{
		xNeighbour = x - 1;
		yNeighbour = y - 1;

		indexNeighbour = getIndex(xNeighbour, yNeighbour, rows);
	}

	if (gen[indexNeighbour + 2] == 1) //cells[y][xNeighbour].alive == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int checkDiagonalTR(int index, int *gen, int rows, int columns)
{
	int neighbourIndex;
	int x = gen[index]; 
	int y = gen[index + 1];
	int xNeighbour; 
	int yNeighbour;
	// 1
	if (x == (rows - 1) && y == 0)
	{
		xNeighbour = 0;
		yNeighbour = columns - 1;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 2
	else if (y == 0)
	{
		xNeighbour = x + 1;
		yNeighbour = columns - 1;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 3
	else if (x == (rows - 1))
	{
		xNeighbour = 0;
		yNeighbour = y - 1;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 4
	else
	{
		xNeighbour = x + 1;
		yNeighbour = y -1;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}

	if (gen[neighbourIndex + 2] == 1) //cells[y][xNeighbour].alive == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int checkDiagonalBL(int index, int *gen, int rows, int columns)
{
	int neighbourIndex;
	int x = gen[index]; 
	int y = gen[index + 1];
	int xNeighbour; 
	int yNeighbour;

	// 1
	if (x == 0 && y == (columns -1))
	{
		xNeighbour = rows - 1;
		yNeighbour = 0;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 2
	else if (y == (columns - 1))
	{
		xNeighbour = x - 1;
		yNeighbour = 0;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 3
	else if (x == 0)
	{
		xNeighbour = rows - 1;
		yNeighbour = y + 1;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 4
	else
	{
		neighbourIndex = getIndex((x - 1), (y + 1), rows);
	}

	if (gen[neighbourIndex + 2] == 1) 
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int checkDiagonalBR(int index, int *gen, int rows, int columns)
{
	int neighbourIndex;
	int x = gen[index]; 
	int y = gen[index + 1];
	int xNeighbour; 
	int yNeighbour;

	// 1
	if (x == (rows - 1) && y == (columns -1))
	{
		xNeighbour = 0;
		yNeighbour = 0;
		neighbourIndex = 0;
	}
	// 2
	else if (y == (columns - 1))
	{
		xNeighbour = x + 1;
		yNeighbour = 0;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 3
	else if (x == (rows - 1))
	{
		neighbourIndex = getIndex(0, (y + 1), rows);
	}
	// 4
	else
	{
		neighbourIndex = getIndex((x + 1), (y + 1), rows);
	}

	if (gen[neighbourIndex + 2] == 1) 
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

__device__
int getCellNeighbours(int index, int *gen, int rows, int columns){
	int neighbours = 0;
	neighbours = checkLeft(index, gen, rows);
	neighbours = neighbours + checkRight(index, gen, rows);
	neighbours = neighbours + checkTop(index, gen, rows, columns);
	neighbours = neighbours + checkBottom(index, gen, rows, columns);
	neighbours = neighbours + checkDiagonalTL(index, gen, rows, columns);
	neighbours = neighbours + checkDiagonalTR(index, gen, rows, columns);
	neighbours = neighbours + checkDiagonalBL(index, gen, rows, columns);
	neighbours = neighbours + checkDiagonalBR(index, gen, rows, columns);
	
	return neighbours;
}

__device__
void cellNextCycle(int *gen, int *newGen, int index, int rows, int columns){

	int neighbours = 0;
	neighbours = getCellNeighbours(index, gen, rows, columns);
	
	// /printf("\nx : %d , y : %d. neighbours : %d", gen[index], gen[index + 1], neighbours);

	// Any live cell
	if (gen[index + 2] == 1)
	{
		//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
		if (neighbours < 2)
		{
			newGen[index + 2] = 0;
		} //Any live cell with more than three live neighbours dies, as if by overpopulation.
		else if (neighbours == 2 || neighbours == 3)
		{
			newGen[index + 2] = 1;
		}
		else if (neighbours > 3)
		{
			newGen[index + 2] = 0;
		}
	}
	else if (neighbours == 3)
	{
		//printf("DEAD BECOMES ALIVE : x : %d , y : %d \n", gen[index], gen[index + 1]);
		//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
		newGen[index + 2] = 1;
	}
	else{
		newGen[index + 2] = 0;
 	}
}

// Gets every cells next value which gets stored in newGen
__global__
void calculateBoard(int *gen, int *newGen, int amountofCells, int rows, int columns)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;

	if(index >= amountofCells){
		return;
	}
	int count = index * 3;

	cellNextCycle(gen, newGen, count, rows, columns);
}

int getIndexCPU(int x, int y, int rows){
	// (size * 3) * y + (x * 3)
	int result;
	result = (rows * 3) * y;
	result = result + (x * 3);
	return result;
}

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

void printBoard(int *gen ,int amountofCells, int rows){

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

		if(rowCount == rows){
			printf("\n");
			rowCount = 0;
		}
		count++;
	}
}

void setupGlider(int *gen, int *newGen, int rows){

	int index;
	index = getIndexCPU(1,0,rows) + 2;
	gen[index] = 1;
	newGen[index] = 1;

	index = getIndexCPU(2,1,rows) + 2;
	gen[index] = 1;
	newGen[index] = 1;

	index = getIndexCPU(0,2,rows) + 2;
	gen[index] = 1;
	newGen[index] = 1;

	index = getIndexCPU(1,2,rows) + 2;
	gen[index] = 1;
	newGen[index] = 1;

	index = getIndexCPU(2,2,rows) + 2;
	gen[index] = 1;
	newGen[index] = 1;
}

void populateArray(int *gen, int rows, int columns){
	
	int count = 0;
    for (int y = 0; y < columns; y++) {
		for(int x = 0; x < rows; x++){
			gen[count] = x;
			count++;
			gen[count] = y;
			count++;
			gen[count] = 0;;
			count++;
		}
	}
}

int main(void){
	
	int *gen, *newGen;

	int rows = 50;
	int columns = 60;
	int amountofCells = rows * columns;
	int lengthofArray = ((amountofCells * 2) + amountofCells);
	int loopCount = 0;

	int amountOFBlocks = (amountofCells / 1024) + 1; 
	
	printf("User wants %d X %d , Total Cells needed : %d , Array Size : %d \n", rows , columns, amountofCells, lengthofArray);

	// Allocate Unified Memory – accessible from CPU or GPU
    cudaMallocManaged(&gen, lengthofArray*sizeof(int));
	cudaMallocManaged(&newGen, lengthofArray*sizeof(int));

	// populate board
	populateArray(gen, rows, columns);
	populateArray(newGen, rows, columns);
	// set up glider
	setupGlider(gen, newGen, rows);

	cudaDeviceSynchronize();

	// Keep calculating board & printing
	while(loopCount < 300){
		usleep(9000);
		if((loopCount % 2) == 0){
			calculateBoard<<<amountOFBlocks,1024>>>(gen, newGen, amountofCells, rows, columns);
			cudaDeviceSynchronize();
			printBoard(newGen, lengthofArray, rows);
	
		} else{
			calculateBoard<<<amountOFBlocks,1024>>>(newGen, gen, amountofCells, rows, columns);
			cudaDeviceSynchronize();
			printBoard(gen, lengthofArray, rows);
		}

		
		loopCount++;
	}

	// Wait for GPU to finish before accessing on host
	cudaDeviceSynchronize();

	// Free memory
	cudaFree(gen);
	cudaFree(newGen);

	return 0;
}
	
