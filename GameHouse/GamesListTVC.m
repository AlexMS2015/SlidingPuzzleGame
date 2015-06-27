//
//  ASGamesListTVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GamesListTVC.h"
#import "ASGameCellTableViewCell.h"
#import "ASPuzzleGame.h"

@interface GamesListTVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UISegmentedControl *completedGamesToggle;
@property (strong, nonatomic) NSMutableArray *completeGames;
@property (strong, nonatomic) NSMutableArray *incompleteGames;
@property (strong, nonatomic) NSArray *gamesForTable;

@end

@implementation GamesListTVC

#define CELL_IDENTIFIER @"ASGameCellTableViewCell"

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ASGameCellTableViewCell cellHeight];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.gamesForTable count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ASPuzzleGame *spg = self.gamesForTable[indexPath.row];
    
    
    ASGameCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    cell.rankLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.gamesForTable indexOfObject:spg] + 1];
    cell.image.image = [UIImage imageNamed:spg.imageName];
    cell.mainLabel.text = [NSString stringWithFormat:@"%lu moves", (unsigned long)spg.numberOfMovesMade];
    
    return cell;
}

#pragma mark - Actions

-(void)toggleGameType:(UISegmentedControl *)control
{
    [self.tableView reloadData];
}

#pragma mark - Properties

-(NSArray *)gamesForTable
{
    if (self.completedGamesToggle.selectedSegmentIndex == 0) {
        return [self.incompleteGames copy];
    } else {
        return [self.completeGames copy];
    }
}

-(UISegmentedControl *)completedGamesToggle
{
    if (!_completedGamesToggle) {
        _completedGamesToggle = [[UISegmentedControl alloc]
                                    initWithItems:@[@"Incomplete", @"Complete"]];
        _completedGamesToggle.selectedSegmentIndex = 0;
        [_completedGamesToggle addTarget:self action:@selector(toggleGameType:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _completedGamesToggle;
}

-(NSMutableArray *)completeGames
{
    if (!_completeGames) {
        _completeGames = [NSMutableArray array];
    }
    
    return _completeGames;
}

-(NSMutableArray *)incompleteGames
{
    if (!_incompleteGames) {
        _incompleteGames = [NSMutableArray array];
    }
    
    return _incompleteGames;
}

#pragma mark - View Life Cycle

-(void)back:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:CELL_IDENTIFIER bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.navigationItem.titleView = self.completedGamesToggle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(back:)];
    
    [self transformData];
}

#pragma mark - Other

-(void)transformData
{
    // sort the game by number of moves made (ascending)
    NSArray *sortedGames = [self.games sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ASPuzzleGame *spg1 = (ASPuzzleGame *)obj1;
        ASPuzzleGame *spg2 = (ASPuzzleGame *)obj2;
        if (spg1.numberOfMovesMade > spg2.numberOfMovesMade) {
            return NSOrderedDescending;
        } else if (spg1.numberOfMovesMade < spg2.numberOfMovesMade) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    self.games = [NSArray arrayWithArray:sortedGames];
    
    // split the games up by complete and incomplete
    for (ASPuzzleGame *game in self.games) {
        if (game.puzzleIsSolved) {
            [self.completeGames addObject:game];
        } else {
            [self.incompleteGames addObject:game];
        }
    }
}

@end
