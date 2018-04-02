// Amarjot Singh Parmar
#include <iostream>
#include <math.h>
#include <stdio.h>

__device__
int getIndex(int x, int y, int rows){
	// (size * 3) * y + (x * 3)
	int result;
	result = (rows * 3) * y;
	result = result + (x * 3);
	return result;
}

__device__
void printBoardd(int *gen ,int amountofCells, int rows){

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
__device__
int checkLeft(int index, int *gen, int rows)
{
	int xNeighbour;
	int yNeighbour;
	int x = gen[index];
	int y = gen[index + 1];

	// 1
	if (gen[index] == 0)
	{
		xNeighbour = getIndex(rows - 1, y, rows);
	} // 2
	else
	{
		xNeighbour = index - 3;
	}

	if (gen[xNeighbour + 2] == 1)
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
	int xNeighbour;
	// 1
	if (gen[index] == rows -1)
	{
		xNeighbour = 0;
	} // 2
	else
	{
		xNeighbour = index + 3;
	}

	if (gen[xNeighbour + 2] == 1)
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
	int yNeighbour;
	// 1
	if (gen[index+1] == 0)
	{
		yNeighbour = getIndex(gen[index], columns - 1 , rows);
	} // 2
	else
	{
		yNeighbour = getIndex(gen[index], (gen[index + 1]- 1), rows);
	}

	if (gen[yNeighbour + 2] == 1)
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
	int yNeighbour;

	// 1
	if (gen[index+1] == columns - 1)
	{
		yNeighbour = getIndex(gen[index], 0 , rows);
	} // 2
	else
	{
		yNeighbour = getIndex(gen[index], (gen[index + 1] + 1), rows);
	}
	
	if (gen[yNeighbour + 2] == 1) 
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
	int neighbourIndex;
	int x = gen[index]; 
	int y = gen[index + 1];
	int xNeighbour; 
	int yNeighbour;

	// 1
	if (x == 0 && y == 0)
	{
		xNeighbour = rows - 1;
		yNeighbour = columns - 1;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 2
	else if (y == 0)
	{
		xNeighbour = x - 1;
		yNeighbour = columns - 1;
		neighbourIndex = getIndex(xNeighbour, yNeighbour, rows);
	}
	// 3
	else if (x == 0)
	{
		neighbourIndex = index - 3;//getIndex((rows - 1), gen[index - 2));
	}
	// 4
	else
	{
		xNeighbour = x - 1;
		yNeighbour = y - 1;

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
		neighbourIndex = getIndex(x, y, rows);
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
		neighbourIndex = getIndex(x - 1, y + 1, rows);
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
		neighbourIndex = getIndex(x, y, rows);
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
		neighbourIndex = index + 3;
	}
	// 4
	else
	{
		neighbourIndex = getIndex(x + 1, y + 1, rows);
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
	/*
	printf(" x : %d , y : %d. Check LEft neighbours : %d \n", gen[index], gen[index + 1], neighbours);
	printf(" x : %d , y : %d. Check right neighbours : %d \n", gen[index], gen[index + 1], checkRight(index, gen, rows));
	printf(" x : %d , y : %d. Check Top neighbours : %d \n", gen[index], gen[index + 1], checkTop(index, gen, rows, columns));
	printf(" x : %d , y : %d. Check B neighbours : %d \n", gen[index], gen[index + 1], checkBottom(index, gen, rows, columns));
	printf(" x : %d , y : %d. Check TL neighbours : %d \n", gen[index], gen[index + 1], checkDiagonalTL(index, gen, rows, columns));
	printf(" x : %d , y : %d. Check TR neighbours : %d \n", gen[index], gen[index + 1], checkDiagonalTR(index, gen, rows, columns));
	printf(" x : %d , y : %d. Check BL neighbours : %d \n", gen[index], gen[index + 1], checkDiagonalBL(index, gen, rows, columns));
	printf(" x : %d , y : %d. Check BR neighbours : %d \n", gen[index], gen[index + 1], checkDiagonalBR(index, gen, rows, columns));
	*/
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
	else
	{
		//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
		if (neighbours == 3 && gen[index + 2] == 0)
		{
			newGen[index + 2] = 1;
		}
	}
}

// Gets every cells next value which gets stored in newGen
__global__
void calculateBoard(int *gen, int *newGen, int amountofCells, int switchh, int rows, int columns)
{
	int count = 0;

	for(int x = 0; x < amountofCells; x++){
		cellNextCycle(gen, newGen, count, rows, columns);
		count = count + 3;
	}
	

	for(int x = 0; x < ((amountofCells * 3) -1); x++){
		gen[x] = newGen[x];
	}	
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

void populateArrays(int *gen, int *newGen, int rows, int columns){
	
	int count = 0;
    for (int y = 0; y < columns; y++) {
		for(int x = 0; x < rows; x++){
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

int main(void){
	
	int *gen, *newGen;

	int rows = 50;
	int columns = 50;
	int amountofCells = rows * columns;
	int lengthofArray = ((amountofCells * 2) + amountofCells);
	int loopCount = 0;
	
	printf("User wants %d X %d , Total Cells needed : %d , Array Size : %d \n", rows , columns, amountofCells, lengthofArray);

	// Allocate Unified Memory – accessible from CPU or GPU
    cudaMallocManaged(&gen, lengthofArray*sizeof(int));
	cudaMallocManaged(&newGen, lengthofArray*sizeof(int));

	// populate board
	populateArrays(gen, newGen, rows, columns);

	// set up glider
	setupGlider(gen, newGen, rows);
	cudaDeviceSynchronize();

	// Keep calculating board & printing
	while(loopCount < 30){

		calculateBoard<<<1,1>>>(gen, newGen, amountofCells, loopCount, rows, columns);
		cudaDeviceSynchronize();
		printBoard(gen, lengthofArray, rows);
		
		loopCount++;
	}

	// Wait for GPU to finish before accessing on host
	cudaDeviceSynchronize();

	// Free memory
	cudaFree(gen);
	cudaFree(newGen);

	return 0;
}
	
