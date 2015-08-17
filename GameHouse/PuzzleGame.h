//
//  PuzzleGame.h
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGBoard.h"
#import "Enums.h"

@interface PuzzleGame : NSObject

@property (nonatomic, readonly) Difficulty difficulty;
@property (nonatomic, readonly) BOOL puzzleIsSolved;
@property (nonatomic) int numberOfMovesMade;
@property (nonatomic, strong) SPGBoard *board;
@property (nonatomic) NSString *imageName;
@property (nonatomic, strong, readonly) NSDate *datePlayed;

-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName;
-(void)selectTileAtPosition:(Position)position;
-(NSString *)difficultyStringFromDifficulty;
-(void)save;
@end
