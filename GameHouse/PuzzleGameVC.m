//
//  PuzzleGameVC.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PuzzleGameVC.h"
#import "Grid.h"
#import "PuzzleGame.h"
#import "TileView.h"
#import "SettingsVC.h"
#import "PreviousGameDatabase.h"
#import "Enums.h"

@interface PuzzleGameVC () <UIAlertViewDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UIView *boardContainerView;
@property (weak, nonatomic) IBOutlet UIButton *resetGameButton;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numMovesLabel;
@property (weak, nonatomic) IBOutlet UIButton *picShowHideToggle;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

// other
@property (strong, nonatomic) UIImageView *picShowImageView;
@property (strong, nonatomic, readwrite) PuzzleGame *puzzleGame;
@property (strong, nonatomic) Grid *puzzleBoard;

@property (nonatomic) Position previouslySelected;
@end

@implementation PuzzleGameVC

#pragma mark - Properties

-(UIImageView *)picShowImageView
{
    if (!_picShowImageView) {
        _picShowImageView = [[UIImageView alloc] initWithFrame:self.boardContainerView.frame];
        //_picShowImageView.image = [UIImage imageNamed:@"Wooden Tile"];
        
        UIImageView *currentPic = [[UIImageView alloc] initWithFrame:self.boardContainerView.bounds];
        currentPic.image = [UIImage imageNamed:self.puzzleGame.imageName];
        //[_picShowImageView addSubview:currentPic];
        _picShowImageView.image = [UIImage imageNamed:self.puzzleGame.imageName];
        
        [self.view addSubview:_picShowImageView];
    }
    
    return _picShowImageView;
}

-(NSArray *)availableImageNames
{
    return @[@"Cupcake", @"Donut", @"Fish", @"GingerbreadMan", @"Poptart", @"Snowman", @"Cookie"];
}

#pragma mark - View Life Cycle

#define NUM_TILES_DEFAULT 16
#define DIFFICULTY_DEFAULT EASY
-(void)viewDidLayoutSubviews
{
    // Why is this called multiple times?
    //NSLog(@"Layout subviews: %@", NSStringFromCGRect(self.boardContainerView.frame));
    
    [super viewDidLayoutSubviews];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (!self.puzzleGame) {
        [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                         andDifficulty:DIFFICULTY_DEFAULT
                        withImageNamed:[self.availableImageNames firstObject]];
    }
}

#pragma mark - Initialiser

-(void)resetUI
{
    self.numMovesLabel.text = @"0";
    
    self.view.userInteractionEnabled = NO;
    self.countdownLabel.hidden = NO;
    self.countdownLabel.text = @"4";
    
    [self toggleFinalPicView:YES];
    [self.picShowImageView removeFromSuperview];
    self.picShowImageView = nil;
    
    if ([self.boardContainerView.subviews count]) {
        [self.boardContainerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    }
    
    self.difficultyLabel.text = [self.puzzleGame difficultyStringFromDifficulty];
}

-(void)setupInitialBoard
{
    // reset the helper object
    int numRowsAndColumns = sqrt(self.puzzleGame.board.numberOfTiles);
    self.puzzleBoard = [[Grid alloc] initWithSize:self.boardContainerView.bounds.size withRows:numRowsAndColumns andColumns:numRowsAndColumns];
    
    UIImage *boardImage = [UIImage imageNamed:self.puzzleGame.imageName];
    CGSize boardSize = self.boardContainerView.bounds.size;
    
    float imageWidthScale = boardImage.size.width / boardSize.width;
    float imageHeightScale = boardImage.size.height / boardSize.height;
    
    Position currentPosition;
    int tileValue = 1;
    for (currentPosition.row = 0; currentPosition.row < numRowsAndColumns; currentPosition.row++) {
        for (currentPosition.column = 0; currentPosition.column < numRowsAndColumns; currentPosition.column++) {
            
            // the image is too large so resize an appropriate section for the next tile
            CGRect tileFrame = [self.puzzleBoard frameOfCellAtPosition:currentPosition];
            CGRect pictureFrame = CGRectMake(tileFrame.origin.x  * imageWidthScale,
                                             tileFrame.origin.y  * imageHeightScale,
                                             tileFrame.size.width * imageWidthScale,
                                             tileFrame.size.height * imageHeightScale);
            CGImageRef tileCGImage = CGImageCreateWithImageInRect(boardImage.CGImage, pictureFrame);
            UIImage *tileImage = [UIImage imageWithCGImage:tileCGImage];
            
            // set up the actual board tile with the image and position
            if (tileValue < self.puzzleGame.board.numberOfTiles) {
                TileView *tile = [[TileView alloc] initWithFrame:tileFrame
                                                        andImage:tileImage
                                                        andValue:tileValue
                                              andPositionInBoard:currentPosition];
                
                UITapGestureRecognizer *tileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];
                [tile addGestureRecognizer:tileTap];
                
                [self.boardContainerView addSubview:tile];
            }
            tileValue++;
        }
    }
}

-(void)setupNewGameWithNumTiles:(int)numTiles
                  andDifficulty:(Difficulty)difficulty
                 withImageNamed:(NSString *)imageName;
{
    // setup the model
    self.puzzleGame = [[PuzzleGame alloc] initWithNumberOfTiles:numTiles
                                                           andDifficulty:difficulty
                                                    andImageNamed:imageName];
    
    // reset the view
    [self resetUI];
    
    // setting the imageName will also set up all the tiles with the image by that name
    [self setupInitialBoard];
    
    // create and begin the game countdown timer
    NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(countdownFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    [countdownTimer fire];
}

#pragma mark - Helper / Other

-(void)updateUI
{
    // the game model has been updated but the UI has not... hence need to find which tiles have moved and to where
    for (TileView *tileToUpdate in self.boardContainerView.subviews) {
        int currentTileValue = tileToUpdate.tileValue;
        
        int newTileValue = [self.puzzleGame.board valueOfTileAtPosition:tileToUpdate.positionInABoard];
        
        if (currentTileValue != newTileValue) {
            // find the location of the tile's current displayed value in the model's updated tile board
            Position positionToMoveTileTo = [self.puzzleGame.board positionOfTileWithValue:currentTileValue];
            
            // get the frame in the view at new row / column location
            CGRect frameToMoveRectTo = [self.puzzleBoard frameOfCellAtPosition:positionToMoveTileTo];
            
            // update and move the tile
            tileToUpdate.positionInABoard = positionToMoveTileTo;
            [tileToUpdate animateToFrame:frameToMoveRectTo];
        }
    }
    
    self.numMovesLabel.text = [NSString stringWithFormat:@"%d", self.puzzleGame.numberOfMovesMade];
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
        [self.puzzleGame save];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.resetGameButton.alpha = 0.6;
    if ([alertView.title isEqualToString:@"New Game"]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self setupNewGameWithNumTiles:self.puzzleGame.board.numberOfTiles
                             andDifficulty:self.puzzleGame.difficulty
                            withImageNamed:self.puzzleGame.imageName];
        }
    }
}

#pragma mark - Actions

-(void)countdownFired:(NSTimer *)timer
{
    int countdown = [self.countdownLabel.text intValue];
    
    if (countdown > 1) {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d", --countdown];
    } else {
        self.countdownLabel.hidden = YES;
        self.view.userInteractionEnabled = YES;
        [self updateUI];
        [timer invalidate];
    }
}

// helper
-(void)toggleFinalPicView:(BOOL)hidden
{
    if (hidden) {
        self.boardContainerView.userInteractionEnabled = YES;
        self.picShowImageView.hidden = YES;
        [self.picShowHideToggle setTitle:@"Show Pic" forState:UIControlStateNormal];
    } else {
        self.boardContainerView.userInteractionEnabled = NO;
        self.picShowImageView.hidden = NO;
        [self.picShowHideToggle setTitle:@"Hide Pic" forState:UIControlStateNormal];
    }
    
    [self updateUI];
}

- (IBAction)picShowHideToggleTouchUpInside:(UIButton *)sender
{
    if ([self.picShowHideToggle.currentTitle isEqualToString:@"Show Pic"]) {
        [self toggleFinalPicView:NO];
    } else {
        [self toggleFinalPicView:YES];
    }
}

 - (IBAction)exitTouchUpInside:(UIButton *)sender
{
    if (self.puzzleGame.numberOfMovesMade > 0) {
        [self.puzzleGame save];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingsTouchUpInside:(UIButton *)sender
{
    SettingsVC *settingVC =[[SettingsVC alloc] init];
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
    if (!self.puzzleGame.puzzleIsSolved) {
        if ([tap.view isMemberOfClass:[TileView class]]) {
            TileView *selectedTile = (TileView *)tap.view;
            
            // update the model and UI
            [self.puzzleGame selectTileAtPosition:selectedTile.positionInABoard];
            [self updateUI];
            [self checkForSolvedPuzzle];
        }
    }
}

@end
