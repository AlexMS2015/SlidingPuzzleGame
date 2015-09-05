//
//  SettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SettingsVC.h"
#import "NoScrollGridVC.h"
#import "UIImage+Crop.h"
#import "TileView.h"
#import "PuzzleGameVC.h"
#import "SlidingPuzzleGame.h"

@interface SettingsVC () <GridVCDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numRowsSlider;
@property (weak, nonatomic) IBOutlet UISlider *numColsSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *miniGameBoardCV;

// other
@property (strong, nonatomic) NSString *gameImageName;
@property (strong, nonatomic) GridVC *gameImagesController;
@property (strong, nonatomic) NoScrollGridVC *miniBoardController;
@end

@implementation SettingsVC

#pragma mark - GridVCDelegate

-(void)tileTappedAtPosition:(Position)position
{
    self.gameImageName = self.gameVCForSettings.availableImageNames[position.column];
}

#pragma mark - Properties

-(void)setGameVCForSettings:(PuzzleGameVC *)gameVCForSettings
{
    _gameVCForSettings = gameVCForSettings;
    self.gameImageName = self.gameVCForSettings.puzzleGame.imageName;
}

-(void)setGameImageName:(NSString *)gameImageName
{
    _gameImageName = gameImageName;
    [self.pictureSelectionCollectionView reloadData];
}

-(void)setGameImagesController:(GridVC *)gameImagesController
{
    _gameImagesController = gameImagesController;
    _gameImagesController.delegate = self;
}

-(void)setNumRowsSlider:(UISlider *)numRowsSlider
{
    _numRowsSlider = numRowsSlider;
    self.numRowsSlider.value = self.gameVCForSettings.puzzleGame.board.size.rows;
    [self resetMiniBoardView];
}

-(void)setNumColsSlider:(UISlider *)numColsSlider
{
    _numColsSlider = numColsSlider;
    self.numColsSlider.value = self.gameVCForSettings.puzzleGame.board.size.columns;
    [self resetMiniBoardView];
}

-(void)setDifficultySegmentedControl:(UISegmentedControl *)difficultySegmentedControl
{
    _difficultySegmentedControl = difficultySegmentedControl;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
}

-(void)setPictureSelectionCollectionView:(UICollectionView *)pictureSelectionCollectionView
{
    _pictureSelectionCollectionView = pictureSelectionCollectionView;
    
    NSArray *gameImageNames = self.gameVCForSettings.availableImageNames;
    GridSize size = (GridSize){1, (int)[gameImageNames count]};
    
    self.gameImagesController = [[GridVC alloc] initWithgridSize:size collectionView:self.pictureSelectionCollectionView andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, int index) {
        NSString *imageName = gameImageNames[index];
        cell.backgroundView = [[TileView alloc] initWithFrame:cell.bounds
                                                     andImage:[UIImage imageNamed:imageName]];
        cell.alpha = [imageName isEqualToString:self.gameImageName] ? 1.0 : 0.5;
    }];
}

#pragma mark - View Life Cycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Other

-(void)resetMiniBoardView
{
    GridSize size = (GridSize){self.numRowsSlider.value, self.numColsSlider.value};
    
    self.miniBoardController = [[NoScrollGridVC alloc] initWithgridSize:size collectionView:self.miniGameBoardCV andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, int index) {
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.backgroundView.layer.borderWidth = 0.5;
    }];
}

#pragma mark - Actions

- (IBAction)cancelWithNoChanges:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveSettings:(UIButton *)sender
{
    int initialNumRows = self.gameVCForSettings.puzzleGame.board.size.rows;
    int initialNumCols = self.gameVCForSettings.puzzleGame.board.size.columns;
    Difficulty initialDifficulty = self.gameVCForSettings.puzzleGame.difficulty;
    NSString *initialImageName = self.gameVCForSettings.puzzleGame.imageName;
    
    int newNumRows = (int)self.numRowsSlider.value;
    int newNumCols = (int)self.numColsSlider.value;
    int newDifficulty = (int)self.difficultySegmentedControl.selectedSegmentIndex;
    NSString *newImageName = self.gameImageName;

    if (newNumRows != initialNumRows || newNumCols != initialNumCols || newDifficulty != initialDifficulty || ![newImageName isEqualToString:initialImageName]) {
        [self.gameVCForSettings setupNewGameWithBoardSize:(GridSize){newNumRows, newNumCols}
                                            andDifficulty:newDifficulty
                                           withImageNamed:newImageName];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)numTilesChanges:(UISlider *)sender
{
    sender.value = round(sender.value);
    [self resetMiniBoardView];
}

@end
