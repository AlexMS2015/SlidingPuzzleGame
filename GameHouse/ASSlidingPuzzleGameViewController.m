//
//  ASSlidingPuzzleGameViewController.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleGameViewController.h"
#import "ASGameBoardViewSupporter.h"
#import "ASSlidingPuzzleGame.h"
#import "ASSlidingTileView.h"

@interface ASSlidingPuzzleGameViewController () <UIAlertViewDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UIView *boardContainerView;
@property (weak, nonatomic) IBOutlet UIButton *resetGameButton;

// other
@property (nonatomic) int numberOfTiles;
@property (strong, nonatomic) ASGameBoardViewSupporter *puzzleBoard;
@property (strong, nonatomic) ASSlidingPuzzleGame *puzzleGame;
@end

@implementation ASSlidingPuzzleGameViewController

#pragma mark - View Life Cycle

#define NUM_TILES_DEFAULT 16
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"Layout subviews: %@", NSStringFromCGRect(self.boardContainerView.frame));
    
    if (![self.boardContainerView.subviews count]) {
        self.numberOfTiles = NUM_TILES_DEFAULT;
        [self setupNewGame];
    }
}

-(void)setupNewGame
{
    // clear the screen
    [self.boardContainerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // setup the model
    self.puzzleGame = [[ASSlidingPuzzleGame alloc] initWithNumberOfTiles:self.numberOfTiles];

    self.puzzleBoard = [[ASGameBoardViewSupporter alloc] initWithSize:self.boardContainerView.bounds.size
                                                             withRows:sqrt(self.numberOfTiles)
                                                           andColumns:sqrt(self.numberOfTiles)];
    
    for (int row = 0; row < sqrt(self.numberOfTiles); row++) {
        for (int col = 0; col < sqrt(self.numberOfTiles); col++) {
            int tileValue = [self.puzzleGame valueOfTileAtRow:row andColumn:col];
            
            if (tileValue != 0) {
                CGRect tileFrame = [self.puzzleBoard frameOfCellAtRow:row inColumn:col];
                ASSlidingTileView *tile = [[ASSlidingTileView alloc] initWithFrame:tileFrame];
                
                tile.tileValue = tileValue;
                tile.rowInABoard = row;
                tile.columnInABoard = col;
                
                UITapGestureRecognizer *tileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];
                [tile addGestureRecognizer:tileTap];
                
                [self.boardContainerView addSubview:tile];
            }
        }
    }
}

-(void)updateUI
{
    // the game model has been updated but the UI has not... hence need to find which tiles have moved and to where
    for (ASSlidingTileView *tileToUpdate in self.boardContainerView.subviews) {
        int currentTileValue = tileToUpdate.tileValue;
        int newTileValue = [self.puzzleGame valueOfTileAtRow:tileToUpdate.rowInABoard
                                                   andColumn:tileToUpdate.columnInABoard];
        
        if (currentTileValue != newTileValue) {
            // find the location of the tile's value in the model's board
            int rowToMoveTileTo = [self.puzzleGame rowOfTileWithValue:currentTileValue];
            int columnToMoveTileTo = [self.puzzleGame columnOfTileWithValue:currentTileValue];
            
            // get the frame in the view at new row / column location
            CGRect frameToMoveRectTo = [self.puzzleBoard frameOfCellAtRow:rowToMoveTileTo
                                                                 inColumn:columnToMoveTileTo];
            // update and move the tile
            tileToUpdate.rowInABoard = rowToMoveTileTo;
            tileToUpdate.columnInABoard = columnToMoveTileTo;
            [tileToUpdate animateToFrame:frameToMoveRectTo];
        }
    }
}

-(void)checkForSolvedPuzzle
{
    if (self.puzzleGame.puzzleIsSolved) {
        UIAlertView *puzzleSolvedAlert = [[UIAlertView alloc] initWithTitle:@"Puzzle Solved"
                                                                    message:@"Congratulations, you solved the puzzle!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
        [puzzleSolvedAlert show];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.resetGameButton.alpha = 0.6;
    if ([alertView.title isEqualToString:@"New Game"]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self setupNewGame];
        }
    }
}

#pragma mark - User Actions

- (IBAction)newGameTouchUpInside:(UIButton *)sender
{
    self.resetGameButton.alpha = 1.0;
    
    UIAlertView *resetGameAlert = [[UIAlertView alloc] initWithTitle:@"New Game"
                                                             message:@"Are you sure you want to begin a new game?"
                                                            delegate:self
                                                   cancelButtonTitle:@"No"
                                                   otherButtonTitles:@"Yes", nil];
    [resetGameAlert show];
}

-(void)tileTapped:(UITapGestureRecognizer *)tap
{
    if ([tap.view isMemberOfClass:[ASSlidingTileView class]]) {
        ASSlidingTileView *selectedTile = (ASSlidingTileView *)tap.view;
        
        // update the model and UI
        [self.puzzleGame selectTileAtRow:selectedTile.rowInABoard
                               andColumn:selectedTile.columnInABoard];
        [self updateUI];
        [self checkForSolvedPuzzle];
    }
}

@end
