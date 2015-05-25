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

#pragma mark - Properties

-(void)setNumberOfTiles:(int)numberOfTiles
{
    _numberOfTiles = numberOfTiles;
}

-(ASGameBoardViewSupporter *)puzzleBoard
{
    if (!_puzzleBoard) {
        _puzzleBoard = [[ASGameBoardViewSupporter alloc] initWithSize:self.boardContainerView.bounds.size
                                                           withRows:sqrt(self.numberOfTiles)
                                                         andColumns:sqrt(self.numberOfTiles)];
    }
                        
    return _puzzleBoard;
}

-(ASSlidingPuzzleGame *)puzzleGame
{
    if (!_puzzleGame) {
        _puzzleGame = [[ASSlidingPuzzleGame alloc] initWithNumberOfTiles:self.numberOfTiles];
    }
    
    return _puzzleGame;
}

#pragma mark - Debugging Methods

-(void)logRectangle:(CGRect)rect withName:(NSString *)rectName
{
    NSLog(@"-----");
    NSLog(@"%@, originX = %f", rectName, rect.origin.x);
    NSLog(@"%@, originY = %f", rectName, rect.origin.y);
    NSLog(@"%@, width = %f", rectName, rect.size.width);
    NSLog(@"%@, height = %f", rectName, rect.size.height);
}

#pragma mark - View Life Cycle

#define NUM_TILES_DEFAULT 9
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

-(void)updateTile:(ASSlidingTileView *)tileToUpdate
{
    // the game model has been updated but the UI has not... hence need to find whether the tile has moved and where to move it to on the board
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

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.resetGameButton.alpha = 0.5;
    if ([alertView.title isEqualToString:@"New Game"]) {
        if (buttonIndex == 1) {
            [self setupNewGame];
        }
    }
}

-(void)tileTapped:(UITapGestureRecognizer *)tap
{
    // MAKE IT SO THE USER CAN MOVE MULTIPLE CELLS AT ONCE ... IE IF CLICK 2 AWAY FROM A BLANK THEN BOTH WILL MOVE
    
    if ([tap.view isMemberOfClass:[ASSlidingTileView class]]) {
        ASSlidingTileView *selectedTile = (ASSlidingTileView *)tap.view;
        
        if (selectedTile.tileValue !=0) {
            // updat the model
            [self.puzzleGame selectTileAtRow:selectedTile.rowInABoard
                                   andColumn:selectedTile.columnInABoard];
            // update the UI
            [self updateTile:selectedTile];
            
            // is the puzzle solved?
            [self checkForSolvedPuzzle];
        }
    }
}

@end
