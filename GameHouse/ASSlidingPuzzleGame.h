//
//  ASSlidingPuzzleGame.h
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGame.h"
@class ASGameBoard;

@interface ASSlidingPuzzleGame : ASGame

-(instancetype)initWithNumberOfTiles:(int)tiles; // must be a square number
-(NSNumber *)tileAtRow:(int)row andColumn:(int) column;
-(void)selectTileAtRow:(int)row andColumn:(int)column;
@end
