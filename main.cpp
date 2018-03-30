//
//  main.cpp
//  GameofLife
//
//  Created by Amarjot Parmar on 29/03/18.
//  Copyright © 2018 Amarjot Parmar. All rights reserved.
//

#include <iostream>
#include <unistd.h>

class cell{

public:
int alive;
int nextState;
};

class board {

public:
// x, y
int rows;
int columns;
cell **cells;

int printBoard() {
for (int y = 0; y < columns; y++) {
for (int x = 0; x < rows; x++) {
if (cells[y][x].alive == 1){
std::cout << " x ";
}else{
std::cout << " . ";
}

}
std::cout << "" << std::endl;
}
std::cout << "" << std::endl;
return 0;
}

int populateBoard() {
std::cout << "Populating Board" << std::endl;

cells = new cell *[rows];
for (int i = 0; i < rows; ++i) {
cells[i] = new cell[columns];
cells[i][rows].alive = 0;
cells[i][rows].nextState = 0;
}
printBoard();

cells[0][1].alive = 1;
cells[1][2].alive = 1;
cells[2][0].alive = 1;
cells[2][1].alive = 1;
cells[2][2].alive = 1;

return 0;
}

int checkLeft(int x, int y) {

int xNeighbour;
// 1
if (x == 0) {
xNeighbour = rows - 1;
}// 2
else {
xNeighbour = x - 1;
}

if (cells[y][xNeighbour].alive == 1) {
return 1;
} else {
return 0;
}
}

int checkRight(int x, int y) {

int xNeighbour;
//1
if (x == (rows - 1)) {
xNeighbour = 0;
}//2
else {
xNeighbour = x + 1;
}
if (cells[y][xNeighbour].alive == 1) {
return 1;
} else {
return 0;
}
}

int checkTop(int x, int y) {
int yNeighbour;

// 1
if (y == 0) {
yNeighbour = columns - 1;
}// 2
else {
yNeighbour = y - 1;
}

if (cells[yNeighbour][x].alive == 1) {
return 1;
} else {
return 0;
}
}

int checkBottom(int x, int y) {
int yNeighbour;

// 1
if (y == (columns - 1)) {
yNeighbour = 0;
}// 2
else {
yNeighbour = y + 1;
}

if (cells[yNeighbour][x].alive == 1) {
return 1;
} else {
return 0;
}
}

int checkDiagonalTL(int x, int y) {
int neighbourX;
int neighbourY;
// 1
if (y == 0 && x == 0) {
neighbourX = rows - 1;
neighbourY = columns - 1;
}
// 2
else if (y == 0) {
neighbourX = x - 1;
neighbourY = columns - 1;
}
// 3
else if (x == 0) {
neighbourX = rows - 1;
neighbourY = y - 1;
}
// 4
else {
neighbourX = x - 1;
neighbourY = y - 1;
}

if (cells[neighbourY][neighbourX].alive == 1) {
return 1;
} else {
return 0;
}
}

int checkDiagonalTR(int x, int y) {
int neighbourX;
int neighbourY;
// 1
if (y == 0 && x == (rows - 1)) {
neighbourX = 0;
neighbourY = columns - 1;
}
// 2
else if (y == 0) {
neighbourX = x + 1;
neighbourY = columns - 1;
}
// 3
else if (x == rows - 1) {
neighbourX = 0;
neighbourY = y - 1;
}
// 4
else {
neighbourX = x + 1;
neighbourY = y - 1;
}

if (cells[neighbourY][neighbourX].alive == 1) {
return 1;
} else {
return 0;
}
}

int checkDiagonalBL(int x, int y) {
int neighbourX;
int neighbourY;
// 1
if (y == columns - 1 && x == 0) {
neighbourX = rows - 1;
neighbourY = 0;
}// 2
else if (y == (rows - 1)) {
neighbourX = x - 1;
neighbourY = 0;
}
// 3
else if (x == 0) {
neighbourX = rows - 1;
neighbourY = y + 1;
}
// 4
else {
neighbourX = x - 1;
neighbourY = y + 1;
}

if (cells[neighbourY][neighbourX].alive == 1) {
return 1;
} else {
return 0;
}
}

int checkDiagonalBR(int x, int y) {
int neighbourX;
int neighbourY;
// 1
if (y == (columns - 1) && x == (rows - 1)) {
neighbourX = 0;
neighbourY = 0;
}
// 2
else if (y == (rows - 1)) {
neighbourX = x + 1;
neighbourY = 0;
}
// 3
else if (x == (rows - 1)) {
neighbourX = 0;
neighbourY = y + 1;
}
// 4
else {
neighbourX = x + 1;
neighbourY = y + 1;
}

if (cells[neighbourY][neighbourX].alive == 1) {
return 1;
} else {
return 0;
}
}

int getAmountofNeighbours(int x, int y) {
int neighbours = 0;

neighbours = neighbours + checkLeft(x, y);
neighbours = neighbours + checkDiagonalTL(x, y);
neighbours = neighbours + checkTop(x, y);
neighbours = neighbours + checkDiagonalTR(x, y);
neighbours = neighbours + checkRight(x, y);
neighbours = neighbours + checkDiagonalBR(x, y);
neighbours = neighbours + checkBottom(x, y);
neighbours = neighbours + checkDiagonalBL(x, y);

return neighbours;
}

void cellNextCycle(int x, int y) {

int neighbours = getAmountofNeighbours(x, y);
/*
Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
Any live cell with two or three live neighbours lives on to the next generation.
Any live cell with more than three live neighbours dies, as if by overpopulation.

Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
*/
// Any live cell
if (cells[y][x].alive) {

//Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
if (neighbours < 2) {
cells[y][x].nextState = 0;
}//Any live cell with more than three live neighbours dies, as if by overpopulation.
else if (neighbours == 2 || neighbours == 3) {
cells[y][x].nextState = 1;
}
else if(neighbours > 3){

cells[y][x].nextState = 0;
}
} else {
//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
if (neighbours == 3 && cells[y][x].alive == 0) {
cells[y][x].nextState = 1;
}
}
}


void calculateBoard() {
for (int y = 0; y < columns; y++) {
for (int x = 0; x < rows; x++) {
cellNextCycle(x, y);
}
}

for (int y = 0; y < columns; y++) {
for (int x = 0; x < rows; x++) {
if(cells[y][x].nextState == 1){
cells[y][x].alive = 1;
}else{
cells[y][x].alive = 0;
}

}
}
}
};

int main() {

board Board;
Board.rows = 50;
Board.columns = 50;

Board.populateBoard();
std::cout << "Board Populated : " << std::endl;
Board.printBoard();
int x = 0;
while(x < 20100){
usleep(9000);
std::cout << "Count : " << x << std::endl;
Board.printBoard();
Board.calculateBoard();
x++;
}

return 0;
}





