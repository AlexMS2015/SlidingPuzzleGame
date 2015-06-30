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

@interface PuzzleGameVC () <UIAlertViewDelegate, UIViewControllerRestoration>

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
@property (strong, nonatomic, readwrite) PuzzleGame *previousPuzzleGame;
@property (strong, nonatomic) Grid *puzzleBoard;

@property (nonatomic) Position previouslySelected;
@end

@implementation PuzzleGameVC

#pragma mark - Properties

-(void)setPuzzleGame:(PuzzleGame *)puzzleGame
{
    _puzzleGame = puzzleGame;
    [self resetUI];
}

-(UIImageView *)picShowImageView
{
    if (!_picShowImageView) {
        _picShowImageView = [[UIImageView alloc] initWithFrame:self.boardContainerView.frame];
        _picShowImageView.hidden = YES;
        [self.view addSubview:_picShowImageView];
    }
    
    return _picShowImageView;
}

-(NSArray *)availableImageNames
{
    return @[@"Cupcake", @"Donut", @"Fish", @"GingerbreadMan", @"Poptart", @"Snowman", @"Cookie"];
}

#pragma mark - View Life Cycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#define NUM_TILES_DEFAULT 9
#define DIFFICULTY_DEFAULT EASY
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.previousPuzzleGame) {
        self.puzzleGame = self.previousPuzzleGame;
        self.previousPuzzleGame = nil;
    }
    
    if (!self.puzzleGame) {
         [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                          andDifficulty:DIFFICULTY_DEFAULT
                         withImageNamed:[self.availableImageNames firstObject]];
    }
    
    /*
    if (!self.puzzleGame) {
        if (self.previousPuzzleGame) {
            self.puzzleGame = self.previousPuzzleGame;
        } else {
            [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                             andDifficulty:DIFFICULTY_DEFAULT
                            withImageNamed:[self.availableImageNames firstObject]];
        }
    }*/

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - State Restoration

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.puzzleGame forKey:@"puzzleGame"];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [self setupFromPreviousGame:[coder decodeObjectForKey:@"puzzleGame"]];
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - UIViewControllerRestoration

// since this class has a restoration class, that restoration class (this class) will be asked to create a new instance of the view controller
+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

#pragma mark - Initialiser

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    
    return self;
}

-(void)resetUI
{
    self.numMovesLabel.text = @"0";
    self.difficultyLabel.text = [self.puzzleGame difficultyStringFromDifficulty];
    
    // clear any existing tiles
    if ([self.boardContainerView.subviews count]) {
        [self.boardContainerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    }
    
    // reset the helper object
    int numRowsAndColumns = sqrt(self.puzzleGame.board.numberOfTiles);
    self.puzzleBoard = [[Grid alloc] initWithSize:self.boardContainerView.bounds.size
                                         withRows:numRowsAndColumns
                                       andColumns:numRowsAndColumns];
    
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
    
    if (self.previousPuzzleGame) {
        self.countdownLabel.hidden = YES;
        // move the tiles to their saved positions
        [self updateUI:NO];
    } else {
        // create and begin the game countdown timer
        self.countdownLabel.hidden = NO;
        self.countdownLabel.text = @"4";
        NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                   target:self
                                                                 selector:@selector(countdownFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
        [countdownTimer fire];
    }
}

-(void)setupNewGameWithNumTiles:(int)numTiles
                  andDifficulty:(Difficulty)difficulty
                 withImageNamed:(NSString *)imageName;
{
    if (self.puzzleGame.numberOfMovesMade > 0) {
        [self.puzzleGame save];
    }
    
    self.previousPuzzleGame = nil;

    // setup the model
    self.puzzleGame = [[PuzzleGame alloc] initWithNumberOfTiles:numTiles
                                                           andDifficulty:difficulty
                                                    andImageNamed:imageName];
    
    self.picShowImageView.image = [UIImage imageNamed:imageName];
    
}

-(void)setupFromPreviousGame:(PuzzleGame *)game
{
    self.previousPuzzleGame = game;
}

#pragma mark - Helper / Other

-(void)updateUI:(BOOL)animated
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
            if (animated) {
                [tileToUpdate animateToFrame:frameToMoveRectTo];
            } else {
                tileToUpdate.frame = frameToMoveRectTo;
            }
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
        self.view.userInteractionEnabled = NO;
        self.countdownLabel.text = [NSString stringWithFormat:@"%d", --countdown];
    } else {
        self.countdownLabel.hidden = YES;
        self.view.userInteractionEnabled = YES;
        [self updateUI:YES];
        [timer invalidate];
    }
}

// helper
-(void)toggleFinalPicView
{
    if (self.picShowImageView.hidden) {
        self.boardContainerView.userInteractionEnabled = NO;
        self.picShowImageView.hidden = NO;
    } else {
        self.boardContainerView.userInteractionEnabled = YES;
        self.picShowImageView.hidden = YES;
    }
    
    [self updateUI:YES];
}
- (IBAction)picShowHideToggleTouchDown:(UIButton *)sender
{
    [self toggleFinalPicView];
}

- (IBAction)picShowHideToggleTouchUpInside:(UIButton *)sender
{
    [self toggleFinalPicView];
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
    self.resetGameButton.alpha = 0.1;
    
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
            [self updateUI:YES];
            [self checkForSolvedPuzzle];
        }
    }
}

@end
