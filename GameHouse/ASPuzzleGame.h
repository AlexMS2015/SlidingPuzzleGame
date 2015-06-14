//
//  ASPuzzleGame.h
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface ASPuzzleGame : NSObject

@property (nonatomic, readonly) int numberOfTiles;
@property (nonatomic, readonly) Difficulty difficulty;
@property (nonatomic, readonly) BOOL puzzleIsSolved;
@property (nonatomic) int numberOfMovesMade;
@property (nonatomic) NSString *imageName;

-(instancetype)initWithNumberOfTiles:(int)numTiles andDifficulty:(Difficulty)difficulty; // half done
-(int)valueOfTileAtRow:(int)row andColumn:(int)column; // done
-(void)selectTileAtRow:(int)row andColumn:(int)column;
-(int)rowOfTileWithValue:(int)value; // done
-(int)columnOfTileWithValue:(int)value; // done
-(NSString *)difficultyStringFromDifficulty;
-(NSString *)boardSizeStringFromNumTiles;
-(void)save;

@end
