//
//  ASPuzzleGame.h
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EASY = 0,
    MEDIUM = 1,
    HARD = 2,
}Difficulty;

@interface ASPuzzleGame : NSObject

@property (nonatomic, readonly) int numberOfTiles;
@property (nonatomic, readonly) Difficulty difficulty;
@property (nonatomic, readonly) BOOL puzzleIsSolved;
@property (nonatomic) int numberOfMovesMade;
@property (nonatomic) NSString *imageName;

-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName;
-(int)valueOfTileAtRow:(int)row andColumn:(int)column;
-(void)selectTileAtRow:(int)rowOfSelectedTile andColumn:(int)colOfSelectedTile;
-(int)rowOfTileWithValue:(int)value;
-(int)columnOfTileWithValue:(int)value;
-(NSString *)difficultyStringFromDifficulty;
-(NSString *)boardSizeStringFromNumTiles;
-(void)save;
@end
