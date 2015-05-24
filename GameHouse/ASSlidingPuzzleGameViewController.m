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

@interface ASSlidingPuzzleGameViewController ()

// outlets
@property (weak, nonatomic) IBOutlet UIView *boardContainerView;

// other
@property (nonatomic) int numberOfTiles;
@property (strong, nonatomic) ASGameBoardViewSupporter *puzzleBoard;
@property (strong, nonatomic) ASSlidingPuzzleGame *puzzleGame;
@end

@implementation ASSlidingPuzzleGameViewController

#pragma mark - Properties

#define NUM_TILES_DEFAULT 9
-(int)numberOfTiles
{
    return NUM_TILES_DEFAULT;
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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    for (int row = 0; row < sqrt(self.numberOfTiles); row++) {
        for (int col = 0; col < sqrt(self.numberOfTiles); col++) {
            CGRect tileFrame = [self.puzzleBoard frameOfCellAtRow:row inColumn:col];
            ASSlidingTileView *tile = [[ASSlidingTileView alloc] initWithFrame:tileFrame];
            
            int tileValue = [self.puzzleGame valueOfTileAtRow:row andColumn:col];
            tile.tileValue = tileValue;
            tile.rowInABoard = row;
            tile.columnInABoard = col;
            
            UITapGestureRecognizer *tileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];
            [tile addGestureRecognizer:tileTap];
            
            [self.boardContainerView addSubview:tile];
        }
    }
}

-(void)updateBoard
{
    for (ASSlidingTileView *currentTile in self.boardContainerView.subviews) {
        int tileValue = [self.puzzleGame valueOfTileAtRow:currentTile.rowInABoard
                                                andColumn:currentTile.columnInABoard];
        
        if (currentTile.tileValue != tileValue) {
            NSLog(@"tile %d has changed", tileValue);
        }
        
        
        currentTile.tileValue = tileValue;
    }
}

-(void)tileTapped:(UITapGestureRecognizer *)tap
{
    if ([tap.view isMemberOfClass:[ASSlidingTileView class]]) {
        ASSlidingTileView *selectedTile = (ASSlidingTileView *)tap.view;
        
        if (selectedTile.tileValue !=0) {
            [self.puzzleGame selectTileAtRow:selectedTile.rowInABoard
                                   andColumn:selectedTile.columnInABoard];
            [self updateBoard];
            NSLog(@"selected");
        }
    }
}

@end
