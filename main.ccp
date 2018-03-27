#include <iostream>

class cell{

public:
    bool alive;
    bool nextState;
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
                if (cells[y][x].alive){
                    std::cout << "[-]";
                }else{
                    std::cout << "[ ]";
                }

            }
            std::cout << "" << std::endl;
        }
        std::cout << "" << std::endl;
        return 0;
    }

    int setBlinker(){
        cells[1][2].alive = true;
        cells[2][2].alive = true;
        cells[3][2].alive = true;
    }

    int setGlider(){
        cells[0][1].alive = true;

        cells[1][2].alive = true;

        cells[2][0].alive = true;
        cells[2][1].alive = true;
        cells[2][2].alive = true;
    }

    int populateBoard() {
        std::cout << "Populating Board" << std::endl;

        cells = new cell *[rows];
        for (int i = 0; i < rows; ++i) {
            cells[i] = new cell[columns];
            cells[i][rows].alive = false;
            cells[i][rows].nextState = false;
        }

        setGlider();

        return 0;
    }

    int checkLeft(int x, int y) {

        int neighbour;
        //left wrap
        if (x == 0) {
            int xSize = rows - 1;
            neighbour = xSize;
        }//mid
        else {
            neighbour = x - 1;
        }

        if (cells[y][neighbour].alive) {
            return 1;
        } else {
            return 0;
        }
    }

    int checkRight(int x, int y) {

        int neighbour;
        //right wrap
        if (x == (rows - 1)) {
            neighbour = 0;
        }//mid
        else {
            neighbour = x + 1;
        }
        if (cells[y][neighbour].alive) {
            return 1;
        } else {
            return 0;
        }
    }

    int checkTop(int x, int y) {
        int neighbour;

        //top wrap
        if (y == 0) {
            neighbour = (columns - 1);
        }//mid
        else {
            neighbour = y - 1;
        }

        if (cells[neighbour][x].alive) {
            return 1;
        } else {
            return 0;
        }
    }

    int checkBottom(int x, int y) {
        int neighbour;

        //bottom wrap
        if (y == (columns - 1)) {
            neighbour = 0;
        }//mid
        else {
            neighbour = y + 1;
        }

        if (cells[neighbour][x].alive) {
            return 1;
        } else {
            return 0;
        }
    }

    int checkDiagonalTL(int x, int y) {
        int neighbourX;
        int neighbourY;

        if (y == 0 && x == 0) {
            neighbourX = rows - 1;
            neighbourY = columns - 1;
        } else if (y == 0) {
            neighbourX = x - 1;
            neighbourY = columns - 1;
        } else if (x == 0) {
            neighbourX = rows - 1;
            neighbourY = y - 1;
        } else {
            neighbourX = x - 1;
            neighbourY = y - 1;
        }

        if (cells[neighbourY][neighbourX].alive) {
            return 1;
        } else {
            return 0;
        }
    }

    int checkDiagonalTR(int x, int y) {
        int neighbourX;
        int neighbourY;

        if (y == columns - 1 && x == rows - 1) {
            neighbourX = 0;
            neighbourY = columns - 1;
        } else if (y == 0) {
            neighbourX = x + 1;
            neighbourY = columns - 1;
        } else if (x == rows - 1) {
            neighbourX = 0;
            neighbourY = y - 1;
        } else {
            neighbourX = x + 1;
            neighbourY = y - 1;
        }

        if (cells[neighbourY][neighbourX].alive) {
            return 1;
        } else {
            return 0;
        }
    }

    int checkDiagonalBL(int x, int y) {
        int neighbourX;
        int neighbourY;

        if (y == columns - 1 && x == 0) {
            neighbourX = rows - 1;
            neighbourY = 0;
        } else if (x == 0) {
            neighbourX = rows - 1;
            neighbourY = y + 1;
        } else if (y == rows - 1) {
            neighbourX = x - 1;
            neighbourY = 0;
        } else {
            neighbourX = x - 1;
            neighbourY = y + 1;
        }

        if (cells[neighbourY][neighbourX].alive) {
            return 1;
        } else {
            return 0;
        }
    }

    int checkDiagonalBR(int x, int y) {
        int neighbourX;
        int neighbourY;

        if (y == columns - 1 && x == rows - 1) {
            neighbourX = 0;      // 2
            neighbourY = 0;
        } else if (x == rows - 1) { // 1
            neighbourX = 0;
            neighbourY = y + 1;
        } else if (y == rows - 1) { // 3
            neighbourX = x + 1;
            neighbourY = 0;
        } else {
            neighbourX = x + 1;
            neighbourY = y + 1;
        }

        if (cells[neighbourY][neighbourX].alive) {
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

    int cellNextCycle(int x, int y) {

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
                cells[y][x].nextState = false;
            }//Any live cell with more than three live neighbours dies, as if by overpopulation.
            else if (neighbours > 3) {
                cells[y][x].nextState = false;
            }
            else if(neighbours == 2 || neighbours == 3){

                cells[y][x].nextState = true;
            }
        } else {
            //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            if (neighbours == 3 && cells[y][x].alive == false) {
                cells[y][x].nextState = true;
            }
        }
    }


    int calculateBoard() {
        for (int y = 0; y < columns; y++) {
            for (int x = 0; x < rows; x++) {
                cellNextCycle(x, y);
            }
        }

        for (int y = 0; y < columns; y++) {
            for (int x = 0; x < rows; x++) {

                cells[y][x].alive = cells[y][x].nextState;
            }
        }
    }

};

int main() {

    board Board;
    Board.rows = 5;
    Board.columns = 5;

    Board.populateBoard();
    int x = 0;
    while(x < 20){
        std::cout << "Count : " << x << std::endl;
        Board.printBoard();
        Board.calculateBoard();
        x++;
    }

    return 0;
}






