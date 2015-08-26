//
//  SPGrid.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 26/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridOfObjects.h"
#import "GridInterface.h"

@interface SPGrid : GridOfObjects

@property (nonatomic) Position positionOfBlankTile;

-(void)swapBlankTileWithTileAtPosition:(Position)position;
-(Position)positionOfRandomTileAdjacentToBlankTile;
-(BOOL)puzzleIsSolved;

// over ridden to allow setting up of a sliding tile board with ordered values (0 is at the end)
-(instancetype)initWithSize:(GridSize)gridSize andOrientation:(Orientation)orientation;

@end
