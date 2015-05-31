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
@property (nonatomic) GameMode mode;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic, readonly) NSArray *availableImageNames;

-(void)setupNewGameWithNumTiles:(int)numTiles
                  andDifficulty:(Difficulty)difficulty
                        andMode:(GameMode)mode
                 withImageNamed:(NSString *)imageName;
@end
