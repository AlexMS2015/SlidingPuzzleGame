//
//  ASSlidingPuzzleGame.h
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGame.h"

@interface ASSlidingPuzzleGame : ASGame

@property (nonatomic, readonly) BOOL puzzleIsSolved;

-(instancetype)initWithNumberOfTiles:(int)tiles; // must be a square number
-(int)valueOfTileAtRow:(int)row andColumn:(int)column;
-(void)selectTileAtRow:(int)row andColumn:(int)column;
-(int)rowOfTileWithValue:(int)value;
-(int)columnOfTileWithValue:(int)value;
@end
