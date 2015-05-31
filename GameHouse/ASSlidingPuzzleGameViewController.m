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
@property (strong, nonatomic) ASGameBoardViewSupporter *puzzleBoard;
@property (nonatomic) int numMoves;
@end

@implementation ASSlidingPuzzleGameViewController

#pragma mark - Properties

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

/*-(UIImage *)boardImage
{
    if (!_boardImage) {
        
        CGSize boardSize = self.boardContainerView.bounds.size;
        UIImage *image = [UIImage imageNamed:DEFAULT_IMAGE];
        
        self.imageWidthScale = image.size.width / boardSize.width;
        self.imageHeightScale = image.size.height / boardSize.height;
        
        NSLog(@"image width scale: %f", self.imageWidthScale);
        NSLog(@"image height scale: %f", self.imageHeightScale);
        
        NSLog(@"actual image width: %f", image.size.width);
        NSLog(@"actual image height: %f", image.size.height);
        
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(boardSize, NO, 0.0);
        
        //draw
        [image drawInRect:CGRectMake(0.0, 0.0, boardSize.width, boardSize.height)];
        
        //capture resultant image
        _boardImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.boardContainerView.frame];
        iv.image = _boardImage;
        [self.view addSubview:iv];
        
        CGSize boardSize = self.boardContainerView.bounds.size;
        _boardImage = [UIImage imageNamed:DEFAULT_IMAGE];
         
        self.imageWidthScale = _boardImage.size.width / boardSize.width;
        self.imageHeightScale = _boardImage.size.height / boardSize.height;
    }

    return _boardImage;
}*/

-(void)setNumMoves:(int)numMoves
{
    _numMoves = numMoves;
    self.numMovesLabel.text = [NSString stringWithFormat:@"%d", _numMoves];
}

#pragma mark - View Life Cycle

#define NUM_TILES_DEFAULT 16
#define DIFFICULTY_DEFAULT HARD
#define GAME_MODE_DEFAULT PICTUREMODE
#define DEFAULT_IMAGE @"Donut"
-(void)viewDidLayoutSubviews
{
    NSLog(@"Layout subviews: %@", NSStringFromCGRect(self.boardContainerView.frame));
    
    [super viewDidLayoutSubviews];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (![self.boardContainerView.subviews count]) {
        [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                         andDifficulty:DIFFICULTY_DEFAULT
                               andMode:GAME_MODE_DEFAULT
                        withImageNamed:DEFAULT_IMAGE];
    }
}

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
    
    // clear the screen
    [self.boardContainerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // setup the model
    self.puzzleGame = [[ASSlidingPuzzleGame alloc] initWithNumberOfTiles:numTiles
                                                           andDifficulty:difficulty];

    self.puzzleBoard = [[ASGameBoardViewSupporter alloc] initWithSize:self.boardContainerView.bounds.size
                                                             withRows:sqrt(numTiles)
                                                           andColumns:sqrt(numTiles)];
    
    int tileCount = 0;
    for (int row = 0; row < sqrt(numTiles); row++) {
        for (int col = 0; col < sqrt(numTiles); col++) {
            int tileValue = [self.puzzleGame valueOfTileAtRow:row andColumn:col];
            
            if (tileValue != 0) {
                CGRect tileFrame = [self.puzzleBoard frameOfCellAtRow:row inColumn:col];
                ASSlidingTileView *tile = [[ASSlidingTileView alloc] initWithFrame:tileFrame];
                
                tile.rowInABoard = row;
                tile.columnInABoard = col;
                
                self.mode = mode;
                if (self.mode == NUMBERMODE) {
                    tile.tileValue = tileValue;
                } else {
                    tile.tileValue = tileValue;
                    tile.tileImage = [[self tileImagesWithImageNamed:imageName] objectAtIndex:tileValue];
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
    
}

- (IBAction)settingsTouchUpInside:(UIButton *)sender
{
    ASSlidingPuzzleSettingsVC *settingVC =[[ASSlidingPuzzleSettingsVC alloc] init];
    settingVC.gameVCForSettings = self;
        
    [self presentViewController:settingVC
                       animated:YES
                     completion:NULL];
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
