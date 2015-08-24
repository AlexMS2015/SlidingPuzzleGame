//
//  GridPosition.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GridPosition.h"

@implementation GridPosition

+(Position)getPositionFromValue:(NSValue *)value
{
    Position pos;
    if ([value isKindOfClass:[NSValue class]]) {
        [value getValue:&pos];
    }
    
    return pos;
}

+(int)indexOfPosition:(Position)position inGridOfSize:(GridSize)gridSize
{
    return gridSize.columns * position.row + position.column;
}

+(Position)positionForIndex:(int)index inGridOfSize:(GridSize)gridSize
{
    return (Position){index / gridSize.columns, index % gridSize.columns};
}

+(BOOL)position:(Position)pos1 isAdjacentToPosition:(Position)pos2
{
    if (abs(pos1.row - pos2.row) <= 1 && abs(pos1.column - pos2.column) <= 1) {
        return (pos1.row == pos2.row) ^ (pos1.column == pos2.column);
    }
    
    return NO;
}

+(BOOL)position:(Position)pos1 isEqualToPosition:(Position)pos2
{
    return pos1.row == pos2.row && pos1.column == pos2.column;
}

@end
