//
//  GridInterface.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#ifndef GameHouse_GridInterface_h
#define GameHouse_GridInterface_h

/* 
 
Horizontal grid:
 
    1   4   7
    2   5   8
    3   6   9
 
Vertical grid:
 
    1   2   3
    4   5   6
    7   8   9
 */

typedef struct {
    int row;
    int column;
}Position;

typedef struct {
    int rows;
    int columns;
}GridSize;

typedef enum {
    VERTICAL = 0,
    HORIZONTAL = 1,
}Orientation;


Position PositionOfIndexInGrid(int index, GridSize gridSize, Orientation gridOrientation);
int IndexOfPositionInGrid(Position position, GridSize gridSize, Orientation gridOrientation);

//Position PositionForIndexInGridOfSize(int index, GridSize gridSize);
//int IndexOfPositionInGridOfSize(Position position, GridSize gridSize);
BOOL PositionsAreEqual(Position pos1, Position pos2);
//Position PositionFromValue(NSValue *value);
BOOL PositionsAreAdjacent(Position pos1, Position pos2);
NSString *StringFromGridSize(GridSize gridSize);

#endif
