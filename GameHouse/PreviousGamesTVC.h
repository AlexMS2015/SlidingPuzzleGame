//
//  PreviousGamesTVC.h
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PuzzleGame;

@interface PreviousGamesTVC : UITableViewController

@property (strong, nonatomic) NSArray *games;

-(NSArray *)gamesForRow:(int)row;

// abstract methods
-(NSString *)stringToPivotGame:(PuzzleGame *)game;
-(NSString *)cellTextWithPivotString:(NSString *)pivotString;
-(NSString *)headerForTable;
//

@end
