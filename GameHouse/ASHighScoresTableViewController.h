//
//  ASHighScoresTableViewController.h
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASGame;

@interface ASHighScoresTableViewController : UITableViewController

// Designated initialiser
-(instancetype)initWithGame:(ASGame *)game;

@end
