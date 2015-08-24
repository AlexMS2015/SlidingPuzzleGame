//
//  GridInterface.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#ifndef GameHouse_GridInterface_h
#define GameHouse_GridInterface_h

typedef struct {
    int row;
    int column;
}Position;

typedef struct {
    int rows;
    int columns;
}GridSize;

BOOL PositionsAreEqual(Position pos1, Position pos2);
Position PositionFromValue(NSValue *value);
Position PositionForIndexInGridOfSize(int index, GridSize gridSize);
int IndexOfPositionInGridOfSize(Position position, GridSize gridSize);
BOOL PositionsAreAdjacent(Position pos1, Position pos2);

#endif
