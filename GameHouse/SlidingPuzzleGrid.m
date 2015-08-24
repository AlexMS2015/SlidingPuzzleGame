//
//  SlidingPuzzleGrid.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SlidingPuzzleGrid.h"

@implementation SlidingPuzzleGrid

-(instancetype)initWithSize:(GridSize)gridSize
{
    if (self = [super initWithSize:gridSize]) {
        
        int numTiles = self.gridSize.rows * self.gridSize.columns;
        Position currentPos;
        
        for (int tileValue = 0; tileValue < numTiles - 1; tileValue++) {
            currentPos = [GridPosition positionForIndex:tileValue inGridOfSize:self.gridSize];
            [self setValueAtPosition:currentPos toValue:tileValue+1];
        }
        
        currentPos = [GridPosition positionForIndex:numTiles - 1 inGridOfSize:self.gridSize];
        [self setValueAtPosition:currentPos toValue:0];
        
        /*Position currentPosition;
        int tileValue = 1;
        
        for (currentPosition.row = 0; currentPosition.row < gridSize.rows; currentPosition.row++) {
            for (currentPosition.column = 0; currentPosition.column < gridSize.columns; currentPosition.column++) {
                if (tileValue < (gridSize.rows * gridSize.columns)) {
                    [self setValueAtPosition:[GridPosition gridPositionWithPosition:currentPosition]
                                     toValue:tileValue];
                    tileValue++;
                }
            }
        }
        
        currentPosition.row = gridSize.rows - 1;
        currentPosition.column = gridSize.columns - 1;
        [self setValueAtPosition:[GridPosition gridPositionWithPosition:currentPosition]
                         toValue:tileValue];
        self.positionOfBlankTile = [self positionWithValue:0];*/
    }
    
    return self;
}

-(void)swapBlankTileWithTileAtPosition:(Position)position
{
    [self swapValueAtPosition:position withValueAtPosition:self.positionOfBlankTile];
    self.positionOfBlankTile = [self positionWithValue:0];
}

-(Position)positionOfRandomTileAdjacentToBlankTile
{
    Position blankTilePosition = self.positionOfBlankTile;
    Position adjacentTilePos = blankTilePosition;
    
    int maxRow = self.gridSize.rows - 1;
    int maxCol = self.gridSize.columns - 1;
    
    while ([GridPosition position:blankTilePosition isEqualToPosition:adjacentTilePos]) {
        int randomTile = arc4random() % 4;
        
        if (randomTile == 0 && blankTilePosition.column > 0) {
            adjacentTilePos.column--;
        } else if (randomTile == 1 && blankTilePosition.column < maxCol) {
            adjacentTilePos.column++;
        } else if (randomTile == 2 && blankTilePosition.row > 0) {
            adjacentTilePos.row--;
        } else if (randomTile == 3 && blankTilePosition.row < maxRow) {
            adjacentTilePos.row++;
        }
    }
    
    return adjacentTilePos;
}

@end
