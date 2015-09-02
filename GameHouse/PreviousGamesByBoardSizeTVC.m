//
//  PreviousGamesByBoardSizeTVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PreviousGamesByBoardSizeTVC.h"
#import "SlidingPuzzleGame.h"
#import "GamesListTVC.h"

@implementation PreviousGamesByBoardSizeTVC

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GamesListTVC *gamesList = [[GamesListTVC alloc] init];
    NSString *pivotString = [self.pivotedPreviousGames allKeys][indexPath.row];
    gamesList.games = self.pivotedPreviousGames[pivotString];
    [self.navigationController pushViewController:gamesList animated:YES];
}

#pragma mark - Concrete Implementation of Abstract Methods

-(NSString *)gameStringPropertyToPivot
{
    return @"boardSizeString";
}


-(NSString *)headerForTable
{
    return @"Board Size";
}

@end
