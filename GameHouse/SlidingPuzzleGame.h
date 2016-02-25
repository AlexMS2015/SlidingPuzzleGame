//
//  SlidingPuzzleGame.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridOfObjects.h"

typedef enum {
    EASY = 0, MEDIUM = 1, HARD = 2
} Difficulty;

@interface SlidingPuzzleGame : NSObject

@property (nonatomic, readonly) Difficulty difficulty;
@property (strong, nonatomic, readonly) NSString *difficultyString;
@property (nonatomic, readonly) BOOL solved;
@property (nonatomic, readonly) int numberOfMovesMade;
@property (nonatomic, strong, readonly) GridOfObjects *board; // contains 'SlidingPuzzleTile' objects
@property (nonatomic, readonly) NSString *imageName;
@property (nonatomic, strong, readonly) NSDate *datePlayed;
@property (nonatomic, readonly) Position positionOfBlankTile;
@property (strong, nonatomic, readonly) NSString *boardSizeString;

// this will set the game up in its solved state. must call 'startGame' to begin the game
-(instancetype)initWithRows:(NSInteger)rows
                 andColumns:(NSInteger)cols
              andDifficulty:(Difficulty)difficulty
              andImageNamed:(NSString*)imageName;

-(void)startGame; // a new game will be set up in the solved position. calling this method will randomise the tiles to begin the game

-(void)selectTileAtPosition:(Position)position;

@end
