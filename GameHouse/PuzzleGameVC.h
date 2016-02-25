//
//  PuzzleGameVC.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingPuzzleGame.h"

@interface PuzzleGameVC : UIViewController

@property (strong, nonatomic, readonly) SlidingPuzzleGame *puzzleGame;
@property (strong, nonatomic, readonly) NSArray *availableImageNames;

-(void)setupNewGameWithRows:(NSInteger)rows andColumns:(NSInteger)cols andDifficulty:(Difficulty)difficulty withImageNamed:(NSString *)imageName;

-(void)setupFromPreviousGame:(SlidingPuzzleGame *)game;

@end
