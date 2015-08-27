//
//  SPGrid.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 26/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SPGrid.h"

@interface SPGrid ()

@property (strong, nonatomic) NSMutableArray *solvedTiles;

@end

@implementation SPGrid

-(instancetype)initWithSize:(GridSize)gridSize andOrientation:(Orientation)orientation
{
    self = [super initWithSize:gridSize andOrientation:orientation andObjects:nil];
    
    if (self) {
        self.objects = [NSArray arrayWithArray:self.solvedTiles];
    }
    
    return self;
}

-(void)swapBlankTileWithTileAtPosition:(Position)position
{
    [self swapObjectAtPosition:position withObjectAtPosition:self.positionOfBlankTile];
}

// MOVE THIS TO THE GRIDINTERFACE AND GET RID OF THIS CLASS ENTIRELY!!!!
-(Position)positionOfRandomTileAdjacentToBlankTile
{
    Position blankTilePosition = self.positionOfBlankTile;
    Position adjacentTilePos = blankTilePosition;
    
    int maxRow = self.size.rows - 1;
    int maxCol = self.size.columns - 1;
    
    while (PositionsAreEqual(blankTilePosition, adjacentTilePos)) {
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

#pragma mark - Properties

-(Position)positionOfBlankTile
{
    return [self positionOfObject:[NSNumber numberWithInt:0]];
}

-(NSMutableArray *)solvedTiles
{
    if (!_solvedTiles) {
        _solvedTiles = [NSMutableArray array];
        for (int tileValue = 1; tileValue < self.size.rows * self.size.columns; tileValue++) {
            [_solvedTiles addObject:[NSNumber numberWithInt:tileValue]];
        }
        [_solvedTiles addObject:[NSNumber numberWithInt:0]];
    }
    
    return _solvedTiles;
}

-(BOOL)puzzleIsSolved
{
    return [self.objects isEqualToArray:self.solvedTiles];
}

@end
