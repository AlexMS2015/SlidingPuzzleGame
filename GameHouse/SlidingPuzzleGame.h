//
//  SlidingPuzzleGame.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlidingPuzzleGrid.h"
#import "Enums+Structs.h"

@interface SlidingPuzzleGame : NSObject

@property (nonatomic, readonly) Difficulty difficulty;
@property (nonatomic, readonly) BOOL puzzleIsSolved;
@property (nonatomic) int numberOfMovesMade;
@property (nonatomic, strong) SlidingPuzzleGrid *board;
@property (nonatomic) NSString *imageName;
@property (nonatomic, strong, readonly) NSDate *datePlayed;

-(instancetype)initWithBoardSize:(GridSize)boardSize
                   andDifficulty:(Difficulty)difficulty
                   andImageNamed:(NSString *)imageName;

-(void)selectTileAtPosition:(Position)position;
-(NSString *)difficultyStringFromDifficulty;
//-(void)save; // SHOULD AUTO SAVE AFTER EVERY BLANK TILE MOVEMENT???

-(void)startGame;

@end
