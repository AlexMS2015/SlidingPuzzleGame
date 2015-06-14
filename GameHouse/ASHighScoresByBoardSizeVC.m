//
//  ASHighScoresByBoardSizeVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASHighScoresByBoardSizeVC.h"
#import "ASSlidingPuzzleGame.h"
#import "ASGamesListTVC.h"

@interface ASHighScoresByBoardSizeVC ()

@end

@implementation ASHighScoresByBoardSizeVC

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASGamesListTVC *gamesList = [[ASGamesListTVC alloc] init];
    gamesList.games = [self gamesForRow:(int)indexPath.row];
    [self.navigationController pushViewController:gamesList animated:YES];
}

#pragma mark - Concrete Implementation of Abstract Methods

-(NSString *)stringToPivotGame:(ASSlidingPuzzleGame *)game
{
    return [game boardSizeStringFromNumTiles];
}

-(NSString *)cellTextWithPivotString:(NSString *)pivotString
{
    return pivotString;
}

-(NSString *)cellSubtitleTextWithNumGames:(int)numGames
{
    return [NSString stringWithFormat:@"Games Completed: %d", numGames];
}

-(NSString *)headerForTable
{
    return @"Board Size";
}

@end
