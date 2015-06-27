//
//  PuzzleBoard.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface PuzzleBoard : NSObject

@property (nonatomic, readonly) int numberOfTiles;

-(instancetype)initWithNumTiles:(int)numTiles; // designated
-(int)valueOfTileAtPosition:(Position)position;
-(Position)positionOfTileWithValue:(int)value;
-(Position)positionOfBlankTile;
-(void)setTileAtPosition:(Position)position withValue:(int)value;
-(void)swapBlankTileWithTileAtPosition:(Position)position;
-(NSString *)boardSizeStringFromNumTiles;
@end
