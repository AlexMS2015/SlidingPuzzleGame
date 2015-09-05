//
//  GamesListTVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GamesListTVC.h"
#import "PreviousGameCell.h"
#import "SlidingPuzzleGame.h"
#import "PuzzleGameVC.h"
#import "ObjectDatabase.h"

@interface GamesListTVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UISegmentedControl *completedGamesToggle;
@property (strong, nonatomic) NSMutableArray *completeGames;
@property (strong, nonatomic) NSMutableArray *incompleteGames;
@property (strong, nonatomic) NSArray *gamesForTable;

@end

@implementation GamesListTVC

#define CELL_IDENTIFIER @"PreviousGameCell"

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PreviousGameCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlidingPuzzleGame *game = self.gamesForTable[indexPath.row];
    
    if (!game.solved) {
        PuzzleGameVC *gameVC = [[PuzzleGameVC alloc] init];
        [gameVC setupFromPreviousGame:game];
        [self.navigationController pushViewController:gameVC animated:YES];
    }
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
    PreviousGameCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    SlidingPuzzleGame *game = self.gamesForTable[indexPath.row];

    cell.rankLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.gamesForTable indexOfObject:game] + 1];
        
    cell.image.image = [UIImage imageNamed:game.imageName];
    cell.mainLabel.text = [NSString stringWithFormat:@"%lu moves", (unsigned long)game.numberOfMovesMade];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    cell.subLabel.text = [dateFormatter stringFromDate:game.datePlayed];
    
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
    return self.completedGamesToggle.selectedSegmentIndex == 0 ?
                    [self.incompleteGames copy] : [self.completeGames copy];
}

-(UISegmentedControl *)completedGamesToggle
{
    if (!_completedGamesToggle) {
        _completedGamesToggle = [[UISegmentedControl alloc]
                                        initWithItems:@[@"Incomplete", @"Complete"]];
        _completedGamesToggle.selectedSegmentIndex = 0;
        [_completedGamesToggle addTarget:self
                                  action:@selector(toggleGameType:)
                        forControlEvents:UIControlEventValueChanged];
    }
    
    return _completedGamesToggle;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // reload the data if we have loaded an old game and the data has changed
    [self transformData];
    [self.tableView reloadData];
}

#pragma mark - Other

-(void)transformData
{
    self.completeGames = [NSMutableArray array];
    self.incompleteGames = [NSMutableArray array];
    
    // split the games up by complete and incomplete
    for (SlidingPuzzleGame *game in self.games) {
        game.solved ? [self.completeGames addObject:game] : [self.incompleteGames addObject:game];
    }
    
    [self.completeGames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SlidingPuzzleGame *game1 = (SlidingPuzzleGame *)obj1;
        SlidingPuzzleGame *game2 = (SlidingPuzzleGame *)obj2;
        return game1.numberOfMovesMade > game2.numberOfMovesMade;
    }];
    
    [self.incompleteGames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SlidingPuzzleGame *game1 = (SlidingPuzzleGame *)obj1;
        SlidingPuzzleGame *game2 = (SlidingPuzzleGame *)obj2;
        return [game2.datePlayed compare:game1.datePlayed];
    }];
}

@end
