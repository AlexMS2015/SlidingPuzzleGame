//
//  SlidingPuzzleGame.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridOfObjects.h"
#import "CodableObject.h"

typedef enum {
    EASY = 0, MEDIUM = 1, HARD = 2,
}Difficulty;

@interface SlidingPuzzleGame : CodableObject

#warning - THESE SHOULD ALL BE READ ONLY?
@property (nonatomic, readonly) Difficulty difficulty;
@property (nonatomic, readonly) BOOL solved;
@property (nonatomic) int numberOfMovesMade;
@property (nonatomic, strong) GridOfObjects *board;

@property (nonatomic) NSString *imageName;
@property (nonatomic, strong, readonly) NSDate *datePlayed;
@property (nonatomic) Position positionOfBlankTile;

// this will set the game up in its solved state. must call 'startGame' to begin the game
-(instancetype)initWithBoardSize:(GridSize)boardSize
                  andOrientation:(Orientation)orientation
                   andDifficulty:(Difficulty)difficulty
                   andImageNamed:(NSString *)imageName;

-(void)startGame;

-(void)selectTileAtPosition:(Position)position;
-(NSString *)difficultyString;

@end
