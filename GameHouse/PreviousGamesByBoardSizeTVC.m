//
//  ASHighScoresByBoardSizeVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PreviousGamesByBoardSizeTVC.h"
#import "ASPuzzleGame.h"
#import "GamesListTVC.h"

@interface PreviousGamesByBoardSizeTVC ()

@end

@implementation PreviousGamesByBoardSizeTVC

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GamesListTVC *gamesList = [[GamesListTVC alloc] init];
    gamesList.games = [self gamesForRow:(int)indexPath.row];
    [self.navigationController pushViewController:gamesList animated:YES];
}

#pragma mark - Concrete Implementation of Abstract Methods

-(NSString *)stringToPivotGame:(ASPuzzleGame *)game
{
    return [game.board boardSizeStringFromNumTiles];
}

-(NSString *)cellTextWithPivotString:(NSString *)pivotString
{
    return pivotString;
}

-(NSString *)headerForTable
{
    return @"Board Size";
}

@end
