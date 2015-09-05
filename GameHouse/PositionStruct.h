//
//  PositionStruct.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

typedef struct {
    int row, column;
}Position;

BOOL PositionsAreEqual(Position pos1, Position pos2);
BOOL PositionsAreAdjacent(Position pos1, Position pos2);