//
//  PuzzleGameVC.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PuzzleGameVC.h"
#import "PuzzleGame.h"
#import "TileView.h"
#import "SettingsVC.h"
#import "PreviousGameDatabase.h"
#import "Enums+Structs.h"
#import "NSValue+GetPosition.h"
#import "UIImage+Crop.h"
#import "ObjectGridVC.h"

@interface PuzzleGameVC () <UIAlertViewDelegate, UIViewControllerRestoration, ObjectGridVCDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UIButton *resetGameButton;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numMovesLabel;
@property (weak, nonatomic) IBOutlet UIButton *picShowHideToggle;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *boardCV;

// other
@property (strong, nonatomic) UIImageView *picShowImageView;
@property (strong, nonatomic, readwrite) PuzzleGame *puzzleGame;
@property (nonatomic) BOOL loadingFromExistingGame;
@property (strong, nonatomic) ObjectGridVC *boardCVDataSource;
@end

@implementation PuzzleGameVC

#pragma mark - KVO

-(void)addModelObservers
{
    [self.puzzleGame addObserver:self forKeyPath:@"numberOfMovesMade" options:NSKeyValueObservingOptionNew context:nil];
    [self.puzzleGame.board addObserver:self forKeyPath:@"positionOfBlankTile" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    // ADD AN OBSERVER FOR A SOLVED PUZZLE
}

-(void)removeModelObservers
{
    [self.puzzleGame removeObserver:self forKeyPath:@"numberOfMovesMade"];
    [self.puzzleGame.board removeObserver:self forKeyPath:@"positionOfBlankTile"];
}

-(void)dealloc
{
    [self removeModelObservers];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"numberOfMovesMade"]) {
        self.numMovesLabel.text = [NSString stringWithFormat:@"%@", change[@"new"]];
    } else if ([keyPath isEqualToString:@"positionOfBlankTile"]) {
        Position oldPos = [NSValue getPositionFromValue:change[@"old"]];
        Position newPos = [NSValue getPositionFromValue:change[@"new"]];
        
#warning - WOULD BE GOOD TO HAVE THIS CODE INSIDE THE ObjectGridVC:
        NSIndexPath *oldPosPath = [NSIndexPath indexPathForItem:oldPos.column inSection:oldPos.row];
        NSIndexPath *newPosPath = [NSIndexPath indexPathForItem:newPos.column inSection:newPos.row];
        
        int oldIndex = sqrt(self.puzzleGame.board.numberOfTiles) * (int)oldPosPath.section + (int)oldPosPath.item;
        int newIndex = sqrt(self.puzzleGame.board.numberOfTiles) * (int)newPosPath.section + (int)newPosPath.item;
        [self.boardCVDataSource.cellObjects exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
        
        [self.boardCV performBatchUpdates:^{
            [self.boardCV moveItemAtIndexPath:oldPosPath toIndexPath:newPosPath];
            [self.boardCV moveItemAtIndexPath:newPosPath toIndexPath:oldPosPath];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - ObjectGridVCDelegate

-(void)tileTappedAtPosition:(Position)position
{
    [self.puzzleGame selectTileAtPosition:position];
    [self checkForSolvedPuzzle];
}

#pragma mark - Properties

-(void)setPuzzleGame:(PuzzleGame *)puzzleGame
{
    _puzzleGame = puzzleGame;
    [self addModelObservers];
    
    UIImage *boardImage = [UIImage imageNamed:self.puzzleGame.imageName];
    NSArray *tileImages = [boardImage divideSquareImageIntoSquares:self.puzzleGame.board.numberOfTiles];
    int numRowsAndCols = sqrt(self.puzzleGame.board.numberOfTiles);
    
    GridSize size = (GridSize){numRowsAndCols, numRowsAndCols};
    
    self.boardCVDataSource = [[ObjectGridVC alloc] initWithObjects:tileImages gridSize:size andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, id obj, int objIndex) {
        
        // GET THE TILE VALUE FROM THE BOARD ON THE SELF.PUZZLEGAME
        
        BOOL shouldShowTileView = objIndex + 1 < self.puzzleGame.board.numberOfTiles;
        cell.backgroundView = shouldShowTileView ?
                                    [[TileView alloc] initWithFrame:cell.bounds
                                                           andImage:(UIImage *)obj
                                                           andValue:objIndex + 1] : nil;
        NSLog(@"redoing cell");
    }];
    
    self.boardCV.delegate = self.boardCVDataSource;
    self.boardCV.dataSource = self.boardCVDataSource;
    self.boardCVDataSource.delegate = self;
    
    [self resetUI];
}

-(UIImageView *)picShowImageView
{
    if (!_picShowImageView) {
        _picShowImageView = [[UIImageView alloc] initWithFrame:self.boardCV.frame];
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

//#define NUM_TILES_DEFAULT 9
//#define DIFFICULTY_DEFAULT EASY
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    /*if (!self.puzzleGame) {
        [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                         andDifficulty:DIFFICULTY_DEFAULT
                        withImageNamed:[self.availableImageNames firstObject]];
    }*/
}

#define NUM_TILES_DEFAULT 9
#define DIFFICULTY_DEFAULT EASY
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.puzzleGame) {
        [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                         andDifficulty:DIFFICULTY_DEFAULT
                        withImageNamed:[self.availableImageNames firstObject]];
    }
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
    if (self = [super init]) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    
    return self;
}

-(void)resetUI
{
    self.picShowImageView.image = [UIImage imageNamed:self.puzzleGame.imageName];
    
    self.numMovesLabel.text = @"0";
    self.difficultyLabel.text = [self.puzzleGame difficultyStringFromDifficulty];
    
    if (self.loadingFromExistingGame) {
        self.countdownLabel.hidden = YES;
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
    if (self.puzzleGame)
        [self removeModelObservers];
    
    self.loadingFromExistingGame = NO;
    self.puzzleGame = [[PuzzleGame alloc] initWithNumberOfTiles:numTiles
                                                  andDifficulty:difficulty
                                                  andImageNamed:imageName];
}

-(void)setupFromPreviousGame:(PuzzleGame *)game
{
    if (self.puzzleGame)
        [self removeModelObservers];
    
    self.loadingFromExistingGame = YES;
    self.puzzleGame = game;
}

#pragma mark - Helper / Other

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
    
#warning - Update this app for UIAlertController

    if ([alertView.title isEqualToString:@"New Game"]) {
        self.resetGameButton.alpha = 0.6;
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
        [self.puzzleGame startGame];
        [timer invalidate];
    }
}

// helper
-(void)toggleFinalPicView
{    
    self.boardCV.userInteractionEnabled = !self.picShowImageView.hidden;
    self.picShowImageView.hidden = !self.picShowImageView.hidden;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingsTouchUpInside:(UIButton *)sender
{
    if (!self.newGameSelectionDisabled) {
        SettingsVC *settingVC =[[SettingsVC alloc] init];
        settingVC.gameVCForSettings = self;
        [self presentViewController:settingVC animated:YES completion:NULL];
    }
}

- (IBAction)newGameTouchUpInside:(UIButton *)sender
{
    if (!self.newGameSelectionDisabled) {
        self.resetGameButton.alpha = 0.1;
        UIAlertView *resetGameAlert = [[UIAlertView alloc] initWithTitle:@"New Game"
                                                                 message:@"Are you sure you want to begin a new game?"
                                                                delegate:self
                                                       cancelButtonTitle:@"No"
                                                       otherButtonTitles:@"Yes", nil];
        [resetGameAlert show];
    }
}

@end
