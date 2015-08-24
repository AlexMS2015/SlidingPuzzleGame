//
//  SPGBoard.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 17/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SPGBoard.h"

@implementation SPGBoard

-(BOOL)blankTileIsAdjacentToTileAtPosition:(Position)position
{
    if (abs(self.positionOfBlankTile.row - position.row) <= 1 &&
        abs(self.positionOfBlankTile.column - position.column) <= 1 &&
        (self.positionOfBlankTile.row == position.row
         || self.positionOfBlankTile.column == position.column)) {
            return YES;
        } else {
            return NO;
        }
}

-(instancetype)initWithNumTiles:(int)numTiles
{
    if (self = [super initWithNumTiles:numTiles]) {
        int numRowsAndCols = sqrt(numTiles);
        
        Position currentPosition;
        int tileValue = 1;
        
        for (currentPosition.row = 0; currentPosition.row < numRowsAndCols; currentPosition.row++) {
            for (currentPosition.column = 0; currentPosition.column < numRowsAndCols; currentPosition.column++) {
                if (tileValue < numTiles) {
                    [self setTileAtPosition:currentPosition withValue:tileValue];
                    tileValue++;
                }
            }
        }
        
        currentPosition.row = sqrt(numTiles) - 1;
        currentPosition.column = sqrt(numTiles) - 1;
        [self setTileAtPosition:currentPosition withValue:0];
        self.positionOfBlankTile = [self positionOfTileWithValue:0];
    }
    
    return self;
}

-(void)swapBlankTileWithTileAtPosition:(Position)position
{
    [self swapTileAtPosition:position withTileAtPosition:self.positionOfBlankTile];
    self.positionOfBlankTile = [self positionOfTileWithValue:0];
}

-(Position)positionOfRandomTileAdjacentToBlankTile
{
    Position blankTilePosition = self.positionOfBlankTile;
    Position adjacentTilePos = blankTilePosition;
    
    int maxCol = sqrt(self.numberOfTiles) - 1;
    int maxRow = sqrt(self.numberOfTiles) - 1;
    
    while ([PuzzleBoard position:adjacentTilePos isEqualToPosition:blankTilePosition]) {
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
