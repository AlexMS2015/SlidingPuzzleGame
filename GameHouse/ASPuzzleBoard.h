//
//  ASPuzzleBoard.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface ASPuzzleBoard : NSObject

@property (nonatomic, readonly) int numberOfTiles;

-(instancetype)initWithNumTiles:(int)numTiles; // designated

-(int)valueOfTileAtPosition:(Position)position;
-(Position)positionOfTileWithValue:(int)value;
-(Position)positionOfBlankTile;
-(void)swapBlankTileWithTileAtPosition:(Position)position;
-(void)setTileAtPosition:(Position)position withValue:(int)value;
-(NSString *)boardSizeStringFromNumTiles;
@end
