//
//  ASSlidingPuzzleGameViewController.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleGame.h"

@interface PuzzleGameVC : UIViewController

@property (strong, nonatomic, readonly) PuzzleGame *puzzleGame;

@property (strong, nonatomic, readonly) NSString *imageName;
@property (strong, nonatomic, readonly) NSArray *availableImageNames;

-(void)setupNewGameWithNumTiles:(int)numTiles
                  andDifficulty:(Difficulty)difficulty
                 withImageNamed:(NSString *)imageName;

@end
