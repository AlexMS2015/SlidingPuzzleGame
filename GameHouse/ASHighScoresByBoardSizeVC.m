//
//  ASHighScoresByBoardSizeVC.m
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASHighScoresByBoardSizeVC.h"
#import "ASSlidingPuzzleGame.h"

@interface ASHighScoresByBoardSizeVC ()

@end

@implementation ASHighScoresByBoardSizeVC

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
