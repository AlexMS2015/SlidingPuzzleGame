//
//  ASPuzzleGame.h
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPuzzleBoard.h"
#import "Enums.h"

@interface ASPuzzleGame : NSObject

@property (nonatomic, readonly) Difficulty difficulty;
@property (nonatomic, readonly) BOOL puzzleIsSolved;
@property (nonatomic) int numberOfMovesMade;
@property (nonatomic, strong) ASPuzzleBoard *board;
@property (nonatomic) NSString *imageName;

-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName;
-(void)selectTileAtPosition:(Position)position;
-(NSString *)difficultyStringFromDifficulty;
-(void)save;

-(Position)randomTileNotAtPosition:(Position)position;
@end
