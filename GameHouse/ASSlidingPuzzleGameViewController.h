//
//  ASSlidingPuzzleGameViewController.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPuzzleGame.h"

@interface ASSlidingPuzzleGameViewController : UIViewController

//@property (strong, nonatomic, readonly) ASSlidingPuzzleGame *puzzleGame;
@property (strong, nonatomic, readonly) ASPuzzleGame *puzzleGame;

@property (strong, nonatomic, readonly) NSString *imageName;
@property (strong, nonatomic, readonly) NSArray *availableImageNames;

-(void)setupNewGameWithNumTiles:(int)numTiles
                  andDifficulty:(Difficulty)difficulty
                 withImageNamed:(NSString *)imageName;

@end
