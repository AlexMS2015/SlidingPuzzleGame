//
//  ASGameSelectionTableViewController.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGameSelectionTableViewController.h"
#import "ASGameCell.h"
#import "ASGameDatabase.h"
#import "ASGame.h"
#import "ASSlidingPuzzleGameCVC.h"
#import "ASSlidingPuzzleGame.h"

@interface ASGameSelectionTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ASGameSelectionTableViewController

#define GAME_CELL_IDENTIFIER @"ASGameCell"

#pragma mark - View Controller Life Cycle

-(instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        self.navigationItem.title = @"Select Game";
    }
    
    return self;}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load custom table cell and register it
    UINib *gameCellNib = [UINib nibWithNibName:@"ASGameCell" bundle:nil];
    [self.tableView registerNib:gameCellNib forCellReuseIdentifier:GAME_CELL_IDENTIFIER];
    
    // The navigation bar is not shown on the home screen so we need to unhide it here when the view appears and rehide it when this view disappears
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASGameCell *currentCell = [tableView dequeueReusableCellWithIdentifier:GAME_CELL_IDENTIFIER
                                                              forIndexPath:indexPath];
    
    ASGame *currentGame = [[ASGameDatabase sharedGameDatabase] allGames][indexPath.section];
    
    currentCell.gameName.text = currentGame.gameName;
    currentCell.gameLogo.image = currentGame.gameLogo;
    currentCell.gameDescription.text = currentGame.gameDescription;
    
    return currentCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1; // 1 game per section
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[ASGameDatabase sharedGameDatabase] allGames] count]; // each game has its own section so we can have a space between each one
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ASGameCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASGameCell *selectedCell = (ASGameCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell.gameName.text isEqualToString:@"Sliding Puzzle"]) {
        NSLog(@"selected sliding puzzle");
        
        // test the model
        ASSlidingPuzzleGame *puzzleGame = [[ASSlidingPuzzleGame alloc] initWithNumberOfTiles:16];
        NSLog(@"%@", [puzzleGame description]);
        
        ASSlidingPuzzleGameCVC *slidingPuzzleGame = [[ASSlidingPuzzleGameCVC alloc] init];
        [self.navigationController pushViewController:slidingPuzzleGame animated:YES];
    }
}

@end
