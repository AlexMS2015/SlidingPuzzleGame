//
//  PuzzleGameVC.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridInterface.h"
#import "Enums.h"
@class SlidingPuzzleGame;

@interface PuzzleGameVC : UIViewController

@property (strong, nonatomic, readonly) SlidingPuzzleGame *puzzleGame;
@property (strong, nonatomic, readonly) NSArray *availableImageNames;
@property (nonatomic) BOOL newGameSelectionDisabled; // if you want to load a game but prevent the user from creating a new one (using either the new game button or the settings button) then run. Default is NO.

-(void)setupNewGameWithBoardSize:(GridSize)boardSize
                   andDifficulty:(Difficulty)difficulty
                  withImageNamed:(NSString *)imageName;

-(void)setupFromPreviousGame:(SlidingPuzzleGame *)game;

@end
