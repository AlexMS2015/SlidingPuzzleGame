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

@protocol PuzzleGameDelegate <NSObject>

-(void)tileAtPosition:(Position)pos1 withValue:(int)value didMoveToPosition:(Position)pos2;

@end

@interface PuzzleGame : NSObject

@property (weak, nonatomic) id <PuzzleGameDelegate> delegate;

@property (nonatomic, readonly) Difficulty difficulty;
@property (nonatomic, readonly) BOOL puzzleIsSolved;
@property (nonatomic) int numberOfMovesMade;
@property (nonatomic, strong) SPGBoard *board;
@property (nonatomic) NSString *imageName;
@property (nonatomic, strong, readonly) NSDate *datePlayed;

-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName
                         andDelegate:(id<PuzzleGameDelegate>)delegate;

-(void)selectTileAtPosition:(Position)position;
-(NSString *)difficultyStringFromDifficulty;
-(void)save;
@end
