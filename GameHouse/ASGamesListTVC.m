//
//  ASGamesListTVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGamesListTVC.h"
#import "ASTableViewCell.h"

@interface ASGamesListTVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ASGamesListTVC

#define CELL_IDENTIFIER @"UITableViewCell"

#pragma mark - UITableViewDataSource


#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[ASTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
}

#pragma mark - Other

-(void)transformData
{
    
}

@end
