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

@property (nonatomic, readonly, strong) ASGameBoard *tiles;

-(instancetype)initWithNumberOfTiles:(NSUInteger)tiles; // must be a square number
-(void)selectTileAtRow:(NSUInteger)row andColumn:(NSUInteger)column;
@end
