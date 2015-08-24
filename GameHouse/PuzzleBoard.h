//
//  PuzzleBoard.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import "GridInterface.h"

@interface PuzzleBoard : NSObject

@property (nonatomic, readonly) int numberOfTiles;

-(instancetype)initWithNumTiles:(int)numTiles; // designated

// tile information retrieval
-(int)valueOfTileAtPosition:(Position)position;
-(Position)positionOfTileWithValue:(int)value;

// alter tile positions
-(void)setTileAtPosition:(Position)position withValue:(int)value;
-(void)swapTileAtPosition:(Position)position1 withTileAtPosition:(Position)position2;


// other
-(NSString *)boardSizeStringFromNumTiles;
+(BOOL)position:(Position)firstPos isEqualToPosition:(Position)secondPos;
@end
