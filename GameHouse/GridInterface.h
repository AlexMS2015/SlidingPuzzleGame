//
//  GridInterface.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#ifndef GameHouse_GridInterface_h
#define GameHouse_GridInterface_h

/* This interface only supports grids in this format:
 
              column
            1   2   3
        1   -   -   -
 row    2   -   -   -
        3   -   -   -
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
}GridOrientation;

BOOL PositionsAreEqual(Position pos1, Position pos2);
Position PositionFromValue(NSValue *value);
Position PositionForIndexInGridOfSize(int index, GridSize gridSize);
int IndexOfPositionInGridOfSize(Position position, GridSize gridSize);
BOOL PositionsAreAdjacent(Position pos1, Position pos2);
NSString *StringFromGridSize(GridSize gridSize);

#endif
