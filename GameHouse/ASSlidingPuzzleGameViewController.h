//
//  ASSlidingPuzzleGameViewController.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASSlidingPuzzleGame.h"
#import "Enums.h"

@interface ASSlidingPuzzleGameViewController : UIViewController

@property (strong, nonatomic, readonly) ASSlidingPuzzleGame *puzzleGame;

-(void)setupNewGameWithNumTiles:(int)numTiles andDifficulty:(Difficulty)difficulty;

@end
