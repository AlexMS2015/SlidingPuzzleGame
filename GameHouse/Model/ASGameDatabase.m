//
//  ASGameDatabase.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGameDatabase.h"
#import "ASGame.h"

@interface ASGameDatabase ()

@property (nonatomic, strong) NSArray *allGamesPrivate;

@end

@implementation ASGameDatabase

#pragma mark - Accessor Methods

-(NSArray *)allGames
{
    return [self.allGamesPrivate copy]; // return the privately implemented array of games which is not readonly.
}


#pragma mark - Initialisers

+(instancetype)sharedGameDatabase
{
    static ASGameDatabase *gameDatabase;
    
    if (!gameDatabase) {
        gameDatabase = [[self alloc] initPrivate];
    }
    
    return gameDatabase;
}

-(instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[ASGameDatabase sharedGameDatabase"];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    
    ASGame *slidingPuzzleGame = [[ASGame alloc] init];
    slidingPuzzleGame.gameName = @"Sliding Puzzle";
    slidingPuzzleGame.gameLogo = [UIImage imageNamed:@"Sliding Puzzle - Logo"];
    
    ASGame *connectFourGame = [[ASGame alloc] init];
    connectFourGame.gameName = @"Connect Four";
    connectFourGame.gameLogo = [UIImage imageNamed:@"Connect Four - Logo"];
    
    ASGame *ticTacToeGame = [[ASGame alloc] init];
    ticTacToeGame.gameName = @"Tic Tac Toe";
    ticTacToeGame.gameLogo = [UIImage imageNamed:@"Tic Tac Toe - Logo"];
    ticTacToeGame.gameDescription = @"Tic-tac-toe (or Noughts and crosses, Xs and Os) is a paper-and-pencil game for two players, X and O, who take turns marking the spaces in a 3×3 grid. The player who succeeds in placing three respective marks in a horizontal, vertical, or diagonal row wins the game.";
    
    self.allGamesPrivate = @[slidingPuzzleGame, connectFourGame, ticTacToeGame];
    
    return self;
}

@end
