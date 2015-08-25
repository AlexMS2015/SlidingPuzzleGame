//
//  PreviousGamesByDifficultyTVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//
/*
#import "PreviousGamesByDifficultyTVC.h"
#import "PreviousGamesByBoardSizeTVC.h"
#import "PuzzleGame.h"

@interface PreviousGamesByDifficultyTVC ()

@end

@implementation PreviousGamesByDifficultyTVC

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreviousGamesByBoardSizeTVC *HSByBoardSize = [[PreviousGamesByBoardSizeTVC alloc] init];
    HSByBoardSize.games = [self gamesForRow:(int)indexPath.row];
    [self.navigationController pushViewController:HSByBoardSize animated:YES];
}

#pragma mark - Concrete Implementation of Abstract Methods

-(NSString *)stringToPivotGame:(PuzzleGame *)game
{
    return [game difficultyStringFromDifficulty];
}

-(NSString *)headerForTable
{
    return @"Difficulty";
}

@end*/
