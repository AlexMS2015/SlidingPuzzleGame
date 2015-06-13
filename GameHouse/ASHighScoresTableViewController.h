//
//  ASHighScoresTableViewController.h
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASSlidingPuzzleGame;

@interface ASHighScoresTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *games;

-(NSArray *)gamesForRow:(int)row;

// abstract methods
-(NSString *)stringToPivotGame:(ASSlidingPuzzleGame *)game;
-(NSString *)cellTextWithPivotString:(NSString *)pivotString;
-(NSString *)cellSubtitleTextWithNumGames:(int)numGames;
-(NSString *)headerForTable;
//

@end
