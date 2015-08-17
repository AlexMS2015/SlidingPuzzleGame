//
//  SPGBoard.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 17/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PuzzleBoard.h"

@interface SPGBoard : PuzzleBoard

-(void)swapBlankTileWithTileAtPosition:(Position)position;
-(Position)positionOfBlankTile;
-(BOOL)blankTileIsAdjacentToTileAtPosition:(Position)position;
-(Position)positionOfRandomTileAdjacentToBlankTile;

@end
