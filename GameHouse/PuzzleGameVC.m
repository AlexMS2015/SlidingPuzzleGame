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
#import "SlidingPuzzleGame.h"
#import "SlidingPuzzleTile.h"
#import "PositionStruct.h"
#import "CollectionViewDataSource.h"
#import "UICollectionViewFlowLayout+GridLayout.h"

@interface PuzzleGameVC () <UIAlertViewDelegate, UIViewControllerRestoration, UICollectionViewDelegate>

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
@property (strong, nonatomic) CollectionViewDataSource *boardDataSource;
@property (nonatomic) Position positionOfBlankTile;

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
            
            NSIndexPath *oldPosPath = [NSIndexPath indexPathForItem:self.positionOfBlankTile.column
                                                          inSection:self.positionOfBlankTile.row];
            NSIndexPath *newPosPath = [NSIndexPath indexPathForItem:currentBlankTilePos.column
                                                          inSection:currentBlankTilePos.row];
            [self.boardCV performBatchUpdates:^{
                [self.boardCV moveItemAtIndexPath:oldPosPath toIndexPath:newPosPath];
                [self.boardCV moveItemAtIndexPath:newPosPath toIndexPath:oldPosPath];
            } completion:NULL];
            
            self.positionOfBlankTile = currentBlankTilePos;
        }
        
        // check for a completed game
        if (self.puzzleGame.solved) {
            self.boardCV.userInteractionEnabled = NO;
            UIAlertController *puzzleSolvedAC = [UIAlertController alertControllerWithTitle:@"Puzzle Solved" message:@"Congratulations, you solved the puzzle!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL];
            [puzzleSolvedAC addAction:okButton];
            [self presentViewController:puzzleSolvedAC animated:YES completion:NULL];
        }
    }
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.puzzleGame selectTileAtPosition:(Position){indexPath.section, indexPath.item}];
}

#pragma mark - Properties

-(void)setPuzzleGame:(SlidingPuzzleGame *)puzzleGame
{
    _puzzleGame = puzzleGame;
    
    self.positionOfBlankTile = self.puzzleGame.positionOfBlankTile;
    [self addModelObservers];
    
    static NSString * const CVC_IDENTIFIER = @"CollectionViewCell";
    [self.boardCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CVC_IDENTIFIER];
    
    self.boardDataSource = [[CollectionViewDataSource alloc] initWithData:self.puzzleGame.board.objects cellIdentifier:CVC_IDENTIFIER cellConfigureBlock:^(NSIndexPath *path, id object, UICollectionViewCell *cell) {
        
        Position currPos = (Position){path.section, path.item};
        
        if (!PositionsAreEqual(currPos, self.puzzleGame.positionOfBlankTile)) {
            SlidingPuzzleTile *tile = (SlidingPuzzleTile *)object;
            cell.backgroundView = [[TileView alloc] initWithFrame:cell.bounds
                                                         andImage:tile.image
                                                         andValue:tile.value];
        } else {
            cell.backgroundView = nil;
        }
    }];
    self.boardCV.dataSource = self.boardDataSource;
 
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.boardCV.collectionViewLayout;
    [layout layoutAsGrid];
    
    self.boardCV.delegate = self;
    
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
            [self setupNewGameWithRows:ROWS_DEFAULT andColumns:COLS_DEFAULT andDifficulty:DIFFICULTY_DEFAULT withImageNamed:[self.availableImageNames firstObject]];
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
    
    self.numMovesLabel.text = [NSString stringWithFormat:@"%d", self.puzzleGame.numberOfMovesMade];
    self.difficultyLabel.text = self.puzzleGame.difficultyString;
    self.boardCV.userInteractionEnabled = YES;
    
    if (self.loadedGame) {
        self.countdownLabel.hidden = YES;
    } else {
        // create and begin the game countdown timer
        self.countdownLabel.hidden = NO;
        self.countdownLabel.text = @"4";
        NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownFired:) userInfo:nil repeats:YES];
        [countdownTimer fire];
    }
}

-(void)savePuzzleGame
{
    if (self.puzzleGame.numberOfMovesMade > 0)
        [[ObjectDatabase sharedDatabase] addObjectAndSave:self.puzzleGame];
}

-(void)setupNewGameWithRows:(NSInteger)rows andColumns:(NSInteger)cols andDifficulty:(Difficulty)difficulty withImageNamed:(NSString *)imageName
{
    if (self.puzzleGame) {
        [self savePuzzleGame];
        [self removeModelObservers];
    }
    
    self.loadedGame = nil;
    
    self.puzzleGame = [[SlidingPuzzleGame alloc] initWithRows:rows andColumns:cols andDifficulty:difficulty andImageNamed:imageName];
}

-(void)setupFromPreviousGame:(SlidingPuzzleGame *)game
{
    if (self.puzzleGame) {
        [self savePuzzleGame];
        [self removeModelObservers];
    }
    
    self.loadedGame = game;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"New Game"]) {
        self.resetGameButton.alpha = 0.6;
        if (buttonIndex != alertView.cancelButtonIndex) {
            self.puzzleGame = [[SlidingPuzzleGame alloc] initWithRows:self.puzzleGame.board.numRows andColumns:self.puzzleGame.board.numCols andDifficulty:self.puzzleGame.difficulty andImageNamed:self.puzzleGame.imageName];
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
    self.boardCV.userInteractionEnabled = !self.boardCV.userInteractionEnabled;
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
    [self savePuzzleGame];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingsTouchUpInside:(UIButton *)sender
{
    if (!self.loadedGame) {
        SettingsVC *settingVC =[[SettingsVC alloc] init];
        settingVC.gameVCForSettings = self;
        [self presentViewController:settingVC animated:YES completion:NULL];
    }
}

- (IBAction)newGameTouchUpInside:(UIButton *)sender
{
    if (!self.loadedGame) {
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
