//
//  ASHighScoresByDifficultyVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASHighScoresByDifficultyVC.h"
#import "ASHighScoresByBoardSizeVC.h"
#import "ASPuzzleGame.h"

@interface ASHighScoresByDifficultyVC ()

@end

@implementation ASHighScoresByDifficultyVC

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASHighScoresByBoardSizeVC *HSByBoardSize = [[ASHighScoresByBoardSizeVC alloc] init];
    HSByBoardSize.games = [self gamesForRow:(int)indexPath.row];
    [self.navigationController pushViewController:HSByBoardSize animated:YES];
}

#pragma mark - Concrete Implementation of Abstract Methods

-(NSString *)stringToPivotGame:(ASPuzzleGame *)game
{
    return [game difficultyStringFromDifficulty];
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
    return @"Difficulty";
}

@end
