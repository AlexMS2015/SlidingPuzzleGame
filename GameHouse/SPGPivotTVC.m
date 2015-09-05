//
//  SPGPivotTVC.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 2/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SPGPivotTVC.h"
#import "PreviousGameCell.h"
#import "NSArray+PivotWithPropertyKey.h"

@implementation SPGPivotTVC

#define CELL_IDENTIFIER @"PreviousGameCell"

#pragma mark - Abstract Methods

-(NSString *)headerForTable { return nil; }
-(NSString *)gameStringPropertyToPivot { return nil; }

#pragma mark - Properties

-(void)setPreviousGames:(NSArray *)previousGames
{
    _previousGames = previousGames;
    self.pivotedPreviousGames = [previousGames pivotWithPropertyKey:self.gameStringPropertyToPivot];
}

#pragma mark - Actions

-(void)back:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self headerForTable];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(back:)];
    
    UINib *nib = [UINib nibWithNibName:CELL_IDENTIFIER bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PreviousGameCell cellHeight];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.pivotedPreviousGames allKeys] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreviousGameCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                                  forIndexPath:indexPath];
    
    NSString *pivotString = [self.pivotedPreviousGames allKeys][indexPath.row];
    cell.mainLabel.text = pivotString;
    cell.subLabel.text = [NSString stringWithFormat:@"%lu games", (unsigned long)[self.pivotedPreviousGames[pivotString] count]];
    cell.rankLabel.hidden = YES;
    cell.image.hidden = YES;
    
    return cell;
}


@end
