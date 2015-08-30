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
    gamesList.games = [self gamesForRow:(int)indexPath.row];
    [self.navigationController pushViewController:gamesList animated:YES];
}

#pragma mark - Concrete Implementation of Abstract Methods

-(NSString *)stringToPivotGame:(SlidingPuzzleGame *)game
{
    return [game.board gridSizeString];
}

-(NSString *)headerForTable
{
    return @"Board Size";
}

@end
