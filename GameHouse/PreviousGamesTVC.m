//
//  PreviousGamesTVC.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PreviousGamesTVC.h"
#import "PreviousGameDatabase.h"
#import "PuzzleGame.h"
#import "PreviousGameCell.h"

@interface PreviousGamesTVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *previousGames;

@end

@implementation PreviousGamesTVC

#define CELL_IDENTIFIER @"PreviousGameCell"

#pragma mark - Abstract Methods

-(NSString *)stringToPivotGame:(PuzzleGame *)game
{
    return nil;
}

-(NSString *)headerForTable
{
    return nil;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PreviousGameCell cellHeight];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.previousGames allKeys] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreviousGameCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                                 forIndexPath:indexPath];
    
    NSString *pivotString = [self.previousGames allKeys][indexPath.row];
    cell.mainLabel.text = pivotString;
    cell.subLabel.text = [NSString stringWithFormat:@"Games: %lu", (unsigned long)[self.previousGames[pivotString] count]];
    cell.rankLabel.hidden = YES;
    cell.image.hidden = YES;
    
    return cell;
}

#pragma mark - Other

-(NSArray *)gamesForRow:(int)row
{
    NSString *pivotString = [self.previousGames allKeys][row];
    return self.previousGames[pivotString];
}

-(void)transformData
{
    self.previousGames = [NSMutableDictionary dictionary];
    
    for (PuzzleGame *game in self.games) {
        NSString *pivotString = [self stringToPivotGame:game];
        
        if (!self.previousGames[pivotString]) {
            self.previousGames[pivotString] = [NSMutableArray array];
        }
        
        [self.previousGames[pivotString] addObject:game];
    }
}

#pragma mark - View Life Cycle

-(void)back:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.tableView.backgroundColor = [UIColor colorWithRed:102 green:204 blue:255 alpha:1.0];
    self.title = [self headerForTable];
    
    //[self.tableView registerClass:[ASTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    UINib *nib = [UINib nibWithNibName:CELL_IDENTIFIER bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(back:)];
    
    [self transformData];
}

@end
