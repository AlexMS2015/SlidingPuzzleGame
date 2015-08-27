//
//  Grid.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 27/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Grid.h"

@interface Grid ()

@property (nonatomic, readwrite) GridSize size;
@property (nonatomic, readwrite) Orientation orientation;

@end

@implementation Grid

-(instancetype)initWithGridSize:(GridSize)size andOrientation:(Orientation)orientation
{
    if (self = [super init]) {
        self.size = size;
        self.orientation = orientation;
    }
    
    return self;
}

-(Position)positionOfIndex:(int)index;
{
    return self.orientation == VERTICAL ?
        (Position){index / self.size.columns, index % self.size.columns} :
        (Position){index % self.size.rows, index / self.size.rows};
}

-(int)indexOfPosition:(Position)position;
{
    return self.orientation == VERTICAL ?
        self.size.columns * position.row + position.column :
        self.size.rows * position.column + position.row;
}

-(NSString *)gridSizeString
{
    return [NSString stringWithFormat:@"%dx%d", self.size.rows, self.size.columns];
}

-(Position)randomPositionAdjacentToPosition:(Position)position
{
    Position adjacentPos = position;
    
    int maxRow = self.size.rows - 1;
    int maxCol = self.size.columns - 1;
    
    while (PositionsAreEqual(position, adjacentPos)) {
        int randomTile = arc4random() % 4;
        
        if (randomTile == 0 && position.column > 0) {
            adjacentPos.column--;
        } else if (randomTile == 1 && position.column < maxCol) {
            adjacentPos.column++;
        } else if (randomTile == 2 && position.row > 0) {
            adjacentPos.row--;
        } else if (randomTile == 3 && position.row < maxRow) {
            adjacentPos.row++;
        }
    }
    
    return adjacentPos;
}

@end
