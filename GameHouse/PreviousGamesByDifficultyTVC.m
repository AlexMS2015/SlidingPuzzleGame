//
//  PreviousGamesByDifficultyTVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PreviousGamesByDifficultyTVC.h"
#import "PreviousGamesByBoardSizeTVC.h"
#import "SlidingPuzzleGame.h"

@implementation PreviousGamesByDifficultyTVC

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreviousGamesByBoardSizeTVC *HSByBoardSize = [[PreviousGamesByBoardSizeTVC alloc] init];
    NSString *pivotString = [self.pivotedPreviousGames allKeys][indexPath.row];
    HSByBoardSize.previousGames = self.pivotedPreviousGames[pivotString];
    [self.navigationController pushViewController:HSByBoardSize animated:YES];
}

#pragma mark - Concrete Implementation of Abstract Methods

-(NSString *)gameStringPropertyToPivot
{
    return @"difficultyString";
}

-(NSString *)headerForTable
{
    return @"Difficulty";
}

@end
