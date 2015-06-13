//
//  ASHighScoresTableViewController.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASHighScoresTableViewController.h"
#import "ASPreviousGameDatabase.h"
#import "ASSlidingPuzzleGame.h"
#import "ASTableViewCell.h"
#import "Enums.h"

@interface ASHighScoresTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *highScores;

@end

@implementation ASHighScoresTableViewController

#define CELL_IDENTIFIER @"UITableViewCell"

#pragma mark - Abstract Method

-(NSString *)stringToPivotGame:(ASSlidingPuzzleGame *)game
{
    return nil;
}

-(NSString *)cellTextWithPivotString:(NSString *)pivotString
{
    return nil;
}

-(NSString *)cellSubtitleTextWithNumGames:(int)numGames
{
    return nil;
}

-(NSString *)headerForTable
{
    return nil;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.highScores allKeys] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self headerForTable];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                                 forIndexPath:indexPath];
    
    NSString *pivotString = [self.highScores allKeys][indexPath.row];
    cell.textLabel.text = [self cellTextWithPivotString:pivotString];
    cell.detailTextLabel.text = [self cellSubtitleTextWithNumGames:(int)[self.highScores[pivotString] count]];
    
    return cell;
}

#pragma mark - Other

-(NSArray *)gamesForRow:(int)row
{
    NSString *pivotString = [self.highScores allKeys][row];
    return self.highScores[pivotString];
}

-(void)transformData
{
    self.highScores = [NSMutableDictionary dictionary];
    
    for (ASSlidingPuzzleGame *game in self.games) {
        NSString *pivotString = [self stringToPivotGame:game];
        
        if (!self.highScores[pivotString]) {
            self.highScores[pivotString] = [NSMutableArray array];
        }
        
        [self.highScores[pivotString] addObject:game];
    }
}

#pragma mark - View Controller Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[ASTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        
    [self transformData];
}

@end
