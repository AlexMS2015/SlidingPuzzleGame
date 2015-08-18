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
#import "BoardView.h"
#import "Enums.h"

@interface PuzzleGameVC () <UIAlertViewDelegate, UIViewControllerRestoration, BoardViewDelegate, PuzzleGameDelegate>

// outlets
@property (weak, nonatomic) IBOutlet BoardView *boardView;
@property (weak, nonatomic) IBOutlet UIButton *resetGameButton;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numMovesLabel;
@property (weak, nonatomic) IBOutlet UIButton *picShowHideToggle;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

// other
@property (strong, nonatomic) UIImageView *picShowImageView;
@property (strong, nonatomic, readwrite) PuzzleGame *puzzleGame;
@property (nonatomic) BOOL loadingFromExistingGame;

@end

@implementation PuzzleGameVC

#pragma mark - Properties

-(void)setPuzzleGame:(PuzzleGame *)puzzleGame
{
    _puzzleGame = puzzleGame;
    //_puzzleGame.delegate = self;
    
    [self addModelObservers];

    [self.view setNeedsLayout];
    
    [self.boardView setRows:sqrt(self.puzzleGame.board.numberOfTiles)
                 andColumns:sqrt(self.puzzleGame.board.numberOfTiles)
                   andImage:[UIImage imageNamed:self.puzzleGame.imageName]];
    
    [self resetUI];
}

-(void)addModelObservers
{
    [self.puzzleGame addObserver:self forKeyPath:@"numberOfMovesMade" options:NSKeyValueObservingOptionNew context:nil];
    
    // ADD AN OBSERVER FOR A SOLVED PUZZLE
}

-(void)removeModelObservers
{
    [self.puzzleGame removeObserver:self forKeyPath:@"numberOfMovesMade"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"numberOfMovesMade"]) {
        self.numMovesLabel.text = [NSString stringWithFormat:@"%@", change[@"new"]];
    }
}

-(UIImageView *)picShowImageView
{
    if (!_picShowImageView) {
        _picShowImageView = [[UIImageView alloc] initWithFrame:self.boardView.frame];
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.boardView.delegate = self; // WHY DOESN'T THIS WORK IN THE SETTER?
}

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

    if (!self.puzzleGame) {
        [self setupNewGameWithNumTiles:NUM_TILES_DEFAULT
                         andDifficulty:DIFFICULTY_DEFAULT
                        withImageNamed:[self.availableImageNames firstObject]];
    }
    
    [self.view layoutIfNeeded];
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
    if (self.puzzleGame)
        [self removeModelObservers];
    
    self.loadingFromExistingGame = NO;
    self.puzzleGame = [[PuzzleGame alloc] initWithNumberOfTiles:numTiles
                                                  andDifficulty:difficulty
                                                  andImageNamed:imageName
                                                    andDelegate:self];
}

-(void)setupFromPreviousGame:(PuzzleGame *)game
{
    if (self.puzzleGame)
        [self removeModelObservers];
    
    self.loadingFromExistingGame = YES;
    self.puzzleGame = game;
}

#pragma mark - Helper / Other

-(void)updateUI:(BOOL)animated
{
    // get the current positions of all the tiles
    //NSMutableDictionary *tilePositions = [NSMutableDictionary dictionary];
    for (int tileValue = 0; tileValue < self.puzzleGame.board.numberOfTiles; tileValue++) {
        Position tilePos = [self.puzzleGame.board positionOfTileWithValue:tileValue];
        [self.boardView moveTileWithValue:tileValue toPosition:tilePos animated:YES];
        
        /*NSNumber *tileValue = [NSNumber numberWithInt:i];
        NSNumber *tileRow = [NSNumber numberWithInt:tilePos.row];
        NSNumber *tileCol = [NSNumber numberWithInt:tilePos.column];
        tilePositions[tileValue] = @[tileRow, tileCol];*/
    }
    
    // tell the board view to move the tiles to their new positions
    //[self.boardView moveTilesToPositions:tilePositions animated:animated];
}

-(void)tileAtPosition:(Position)pos1 withValue:(int)value didMoveToPosition:(Position)pos2{
    [self.boardView moveTileWithValue:value toPosition:pos2 animated:YES];
}

#warning - THIS SHOULD BE DONE THROUGH KVO - LEARN THE API FOR IT CMON!!!!!
// ALSO USE KVO FOR THE NUM MOVES LABEL??
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
        [self updateUI:YES];
        [timer invalidate];
    }
}

// helper
-(void)toggleFinalPicView
{
    if (self.picShowImageView.hidden) {
        self.boardView.userInteractionEnabled = NO;
        self.picShowImageView.hidden = NO;
    } else {
        self.boardView.userInteractionEnabled = YES;
        self.picShowImageView.hidden = YES;
    }
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

-(void)tileTappedWithValue:(int)value
{
    Position selectedTilePos = [self.puzzleGame.board positionOfTileWithValue:value];
    [self.puzzleGame selectTileAtPosition:selectedTilePos];
    //[self updateUI:YES];
    [self checkForSolvedPuzzle];
}

@end
