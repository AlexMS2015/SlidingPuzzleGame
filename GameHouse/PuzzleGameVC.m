//
//  PuzzleGameVC.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PuzzleGameVC.h"
#import "TileView.h"
#import "SettingsVC.h"
#import "ObjectDatabase.h"
#import "UIImage+Crop.h"
#import "NoScrollObjectGridVC.h"
#import "SlidingPuzzleGame.h"
#import "SlidingPuzzleTile.h"

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
@property (strong, nonatomic, readwrite) SlidingPuzzleGame *puzzleGame;
@property (strong, nonatomic) SlidingPuzzleGame *loadedGame;
@property (strong, nonatomic) NoScrollObjectGridVC *boardController;
@property (nonatomic) Position positionOfBlankTile;
//@property (strong, nonatomic) NSArray *tileImages;
@end

@implementation PuzzleGameVC

#pragma mark - KVO

-(void)addModelObservers
{
    [self.puzzleGame addObserver:self forKeyPath:@"numberOfMovesMade" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeModelObservers
{
    [self.puzzleGame removeObserver:self forKeyPath:@"numberOfMovesMade"];
}

-(void)dealloc
{
    [self removeModelObservers];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"numberOfMovesMade"]) {
        self.numMovesLabel.text = [NSString stringWithFormat:@"%@", change[@"new"]];
        
        // update the view for changes in the model
        Position currentBlankTilePos = self.puzzleGame.positionOfBlankTile;
        if (!PositionsAreEqual(self.positionOfBlankTile, currentBlankTilePos)) {
            [self.boardController moveObjectAtPosition:self.positionOfBlankTile
                                            toPosition:currentBlankTilePos];
            self.positionOfBlankTile = currentBlankTilePos;
            //[self.boardCV reloadData];
        }
        
        // check for a completed game
        if (self.puzzleGame.solved) {
            self.boardCV.userInteractionEnabled = NO;
            UIAlertView *puzzleSolvedAlert = [[UIAlertView alloc] initWithTitle:@"Puzzle Solved" message:@"Congratulations, you solved the puzzle!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [puzzleSolvedAlert show];
        }
    }
}

#pragma mark - ObjectGridVCDelegate

-(void)tileTappedAtPosition:(Position)position
{
    [self.puzzleGame selectTileAtPosition:position];
}

#pragma mark - Properties

/*-(NSArray *)tileImages
{
    UIImage *boardImage = [UIImage imageNamed:self.puzzleGame.imageName];
    NSArray *tileImages = [boardImage divideSquareImageIntoGrid:self.puzzleGame.board];
    
    // need to re-arrange the images in the correct order for a loaded game. the tile images begin at index 0 so need to subtract 1.
    if (self.loadedGame) {
        NSMutableArray *newTileImages = [NSMutableArray array];
        for (NSNumber *tile in self.puzzleGame.board.objects) {
            int tileValue = [tile intValue];
            [newTileImages addObject:tileImages[tileValue - 1]];
        }
        tileImages = [newTileImages copy];
    }
    
    return tileImages;
}*/

-(void)setPuzzleGame:(SlidingPuzzleGame *)puzzleGame
{
    _puzzleGame = puzzleGame;
    self.positionOfBlankTile = self.puzzleGame.positionOfBlankTile;
    [self addModelObservers];
    
    self.boardController = [[NoScrollObjectGridVC alloc] initWithObjects:self.puzzleGame.board.objects gridSize:self.puzzleGame.board.size collectionView:self.boardCV andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, id obj, int objIndex) {
        if (!PositionsAreEqual(position, self.positionOfBlankTile)) {
            SlidingPuzzleTile *tile = (SlidingPuzzleTile *)obj;
            cell.backgroundView = [[TileView alloc] initWithFrame:cell.bounds
                                                         andImage:tile.tileImage
                                                         andValue:tile.tileValue];
        } else {
            cell.backgroundView = nil;
        }
    }];
    
    [self resetUI];
}

-(void)setBoardController:(NoScrollObjectGridVC *)boardController
{
    _boardController = boardController;
    self.boardController.delegate = self;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#define ROWS_DEFAULT 3
#define COLS_DEFAULT 3
#define DIFFICULTY_DEFAULT EASY
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.puzzleGame) {
        if (self.loadedGame) {
            self.puzzleGame = self.loadedGame;
        } else {
            [self setupNewGameWithBoardSize:(GridSize){ROWS_DEFAULT, COLS_DEFAULT}
                              andDifficulty:DIFFICULTY_DEFAULT
                             withImageNamed:[self.availableImageNames firstObject]];
        }
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
    self.difficultyLabel.text = [self.puzzleGame difficultyString];
    self.boardCV.userInteractionEnabled = YES;
    
    if (self.loadedGame) {
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

-(void)setupNewGameWithBoardSize:(GridSize)boardSize andDifficulty:(Difficulty)difficulty withImageNamed:(NSString *)imageName
{
    if (self.puzzleGame)
        [self removeModelObservers];
    
    self.loadedGame = nil;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.boardCV.collectionViewLayout;
    Orientation orientation =
                layout.scrollDirection == UICollectionViewScrollDirectionVertical ?
                                VERTICAL : HORIZONTAL;

    self.puzzleGame = [[SlidingPuzzleGame alloc] initWithBoardSize:boardSize
                                                    andOrientation:orientation
                                                     andDifficulty:difficulty
                                                     andImageNamed:imageName];
}

-(void)setupFromPreviousGame:(SlidingPuzzleGame *)game
{
    if (self.puzzleGame)
        [self removeModelObservers];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.boardCV.collectionViewLayout;
    layout.scrollDirection = game.board.orientation == VERTICAL ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionHorizontal;
    
    self.loadedGame = game;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
#warning - Update this app for UIAlertController

    if ([alertView.title isEqualToString:@"New Game"]) {
        self.resetGameButton.alpha = 0.6;
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self setupNewGameWithBoardSize:self.puzzleGame.board.size
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
