//
//  ASHighScoresTableViewController.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASHighScoresTableViewController.h"
#import "ASGame.h"

@interface ASHighScoresTableViewController ()

@property (nonatomic, strong) ASGame *game;

@end

@implementation ASHighScoresTableViewController

#pragma mark - View Controller Life Cycle

-(instancetype)initWithGame:(ASGame *)game
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        self.game = game;
        self.tabBarItem.title = self.game.gameName;
        
        [self.game.gameLogo drawInRect:CGRectMake(0, 0, 30, 30)];
        self.tabBarItem.image = self.game.gameLogo;
    }
    
    return self;
}

-(instancetype)init
{
    return [self initWithGame:nil];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self initWithGame:nil];;
}

@end
