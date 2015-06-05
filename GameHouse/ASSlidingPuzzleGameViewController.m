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
#import "ASSlidingPuzzleSettingsVC.h"



@interface ASSlidingPuzzleGameViewController () <UIAlertViewDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UIView *boardContainerView;
@property (weak, nonatomic) IBOutlet UIButton *resetGameButton;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numMovesLabel;

// other
@property (strong, nonatomic, readwrite) ASSlidingPuzzleGame *puzzleGame;
@property (strong, nonatomic, readwrite) NSString *imageName;
@property (nonatomic, readwrite) GameMode mode;
@property (strong, nonatomic) ASGameBoardViewSupporter *puzzleBoard;
@property (nonatomic) int numMoves;
@end

@implementation ASSlidingPuzzleGameViewController

#pragma mark - Properties

-(NSArray *)availableImageNames
{
    return @[@"Cupcake", @"Donut", @"Fish", @"GingerbreadMan", @"Poptart", @"Snowman", @"Cookie"];
}

// split up the board image into an array containing smaller images for each board tile
-(NSArray *)tileImagesWithImageNamed:(NSString *)imageName;
{
    self.imageName = imageName;
    UIImage *boardImage = [UIImage imageNamed:imageName];
    CGSize boardSize = self.boardContainerView.bounds.size;
    
    float imageWidthScale = boardImage.size.width / boardSize.width;
    float imageHeightScale = boardImage.size.height / boardSize.height;
    
    NSMutableArray *splitUpImages = [NSMutableArray array];
    for (int row = 0; row < sqrt(self.puzzleGame.numberOfTiles); row++) {
        for (int col = 0; col < sqrt(self.puzzleGame.numberOfTiles); col++) {
            CGRect tileFrame = [self.puzzleBoard frameOfCellAtRow:row inColumn:col];

            CGRect pictureFrame = CGRectMake(tileFrame.origin.x  * imageWidthScale, tileFrame.origin.y  * imageHeightScale, tileFrame.size.width * imageWidthScale, tileFrame.size.height * imageHeightScale);
            
            CGImageRef tileCGImage = CGImageCreateWithImageInRect(boardImage.CGImage, pictureFrame);
            UIImage *tileImage = [UIImage imageWithCGImage:tileCGImage];
            [splitUpImages addObject:tileImage];
        }
    }
    
    return splitUpImages;
}

-(void)setNumMoves:(int)numMoves
{
    _numMoves = numMoves;
    self.numMovesLabel.text = [NSString stringWithFormat:@"%d", _numMoves];
}

#pragma mark - View Life Cycle

#define NUM_TILES_DEFAULT 16
#define DIFFICULTY_DEFAULT HARD
#define GAME_MODE_DEFAULT PICTUREMODE
-(void)viewDidLayoutSubviews
{
    // Why is this called multiple times?
    NSLog(@"Layout subviews: %@", NSStringFromCGRect(self.boardContainerView.frame));
    
    [super viewDidLayoutSubviews];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (!self.puzzleGame) {
        [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                         andDifficulty:DIFFICULTY_DEFAULT
                               andMode:GAME_MODE_DEFAULT
                        withImageNamed:[self.availableImageNames firstObject]];
    }
}

// helper method for difficulty display label
-(NSString *)difficultyStringFromDifficulty:(Difficulty)difficulty
{
    if (difficulty == EASY) {
        return @"EASY";
    } else if (difficulty == MEDIUM) {
        return @"MEDIUM";
    } else if (difficulty == HARD) {
        return @"HARD";
    }
    
    return @"";
}

-(void)setupNewGameWithNumTiles:(int)numTiles
                  andDifficulty:(Difficulty)difficulty
                        andMode:(GameMode)mode
                 withImageNamed:(NSString *)imageName;
{
    self.numMoves = 0;
    self.difficultyLabel.text = [self difficultyStringFromDifficulty:difficulty];
    
    // clear the screen if replacing an existing game
    if ([self.boardContainerView.subviews count]) {
        [self.boardContainerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    }
    
    // setup the model
    self.puzzleGame = [[ASSlidingPuzzleGame alloc] initWithNumberOfTiles:numTiles
                                                           andDifficulty:difficulty];
    
    // the puzzle board will object will determine where on screen the tiles are located
    self.puzzleBoard = [[ASGameBoardViewSupporter alloc] initWithSize:self.boardContainerView.bounds.size withRows:sqrt(numTiles) andColumns:sqrt(numTiles)];
    
    self.mode = mode;
    NSArray *tileImages = [self tileImagesWithImageNamed:imageName]; // only want to do this once rather than run the method for every single tile!
    
    int tileCount = 0;
    for (int row = 0; row < sqrt(numTiles); row++) {
        for (int col = 0; col < sqrt(numTiles); col++) {
            int tileValue = [self.puzzleGame valueOfTileAtRow:row andColumn:col];
            
            if (tileValue != 0) { // check to see if the blank tile
                CGRect tileFrame = [self.puzzleBoard frameOfCellAtRow:row inColumn:col];
                ASSlidingTileView *tile = [[ASSlidingTileView alloc] initWithFrame:tileFrame];
                
                tile.rowInABoard = row;
                tile.columnInABoard = col;
                tile.tileValue = tileValue;

                if (self.mode == PICTUREMODE) {
                    tile.tileImage = [tileImages objectAtIndex:tileValue];
                }
                
                UITapGestureRecognizer *tileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];
                [tile addGestureRecognizer:tileTap];
                
                [self.boardContainerView addSubview:tile];
            }
            tileCount++;
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
            self.numMoves++;
            
            // find the location of the tile's current displayed value in the model's updated tile board
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
            [self setupNewGameWithNumTiles:self.puzzleGame.numberOfTiles
                             andDifficulty:self.puzzleGame.difficulty
                                   andMode:self.mode
                            withImageNamed:self.imageName];
        }
    }
}

#pragma mark - Actions

 - (IBAction)exitTouchUpInside:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    // SAVE SETTINGS AND GAME HERE
    
}

- (IBAction)settingsTouchUpInside:(UIButton *)sender
{
    ASSlidingPuzzleSettingsVC *settingVC =[[ASSlidingPuzzleSettingsVC alloc] init];
    settingVC.gameVCForSettings = self;
        
    [self presentViewController:settingVC animated:YES completion:NULL];
}

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
