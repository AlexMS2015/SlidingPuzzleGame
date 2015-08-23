//
//  SPGBoard.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 17/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PuzzleBoard.h"

@interface SPGBoard : PuzzleBoard

@property (nonatomic) Position positionOfBlankTile;

-(void)swapBlankTileWithTileAtPosition:(Position)position;
-(BOOL)blankTileIsAdjacentToTileAtPosition:(Position)position;
-(Position)positionOfRandomTileAdjacentToBlankTile;

// over ridden to allow setting up of a sliding tile board with ordered values (0 is at the end)
-(instancetype)initWithNumTiles:(int)numTiles;

@end
