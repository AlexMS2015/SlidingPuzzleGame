//
//  ASGamesListTVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGamesListTVC.h"
#import "ASGameCellTableViewCell.h"
#import "ASSlidingPuzzleGame.h"

@interface ASGamesListTVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ASGamesListTVC

#define CELL_IDENTIFIER @"ASGameCellTableViewCell"

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ASGameCellTableViewCell cellHeight];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.games count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASGameCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                                 forIndexPath:indexPath];
    
    ASSlidingPuzzleGame *spg = self.games[indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.games indexOfObject:spg]];
    cell.image.image = [UIImage imageNamed:spg.imageName];
    cell.mainLabel.text = [NSString stringWithFormat:@"%lu moves", (unsigned long)spg.numberOfMovesMade];
    
    return cell;
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:CELL_IDENTIFIER bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    [self transformData];
}

#pragma mark - Other

-(void)transformData
{
    NSArray *sortedGames = [self.games sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ASSlidingPuzzleGame *spg1 = (ASSlidingPuzzleGame *)obj1;
        ASSlidingPuzzleGame *spg2 = (ASSlidingPuzzleGame *)obj2;
        if (spg1.numberOfMovesMade > spg2.numberOfMovesMade) {
            return NSOrderedDescending;
        } else if (spg1.numberOfMovesMade < spg2.numberOfMovesMade) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    self.games = [NSArray arrayWithArray:sortedGames];
}

@end
