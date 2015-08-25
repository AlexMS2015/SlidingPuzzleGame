//
//  SettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SettingsVC.h"
#import "ObjectGridVC.h"
#import "UIImage+Crop.h"
#import "TileView.h"
#import "PuzzleGameVC.h"
#import "SlidingPuzzleGame.h"

@interface SettingsVC () <ObjectGridVCDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *miniGameBoardCV;

// other
@property (strong, nonatomic) NSString *gameImageName;
//@property (strong, nonatomic) NSArray *availableGameImages;
@property (strong, nonatomic) ObjectGridVC *gameImagesGrid;
@property (strong, nonatomic) ObjectGridVC *miniBoardCVDataSource;
@end

@implementation SettingsVC

#pragma mark - ObjectGridVCDelegate

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

-(void)setGameImagesGrid:(ObjectGridVC *)gameImagesGrid
{
    _gameImagesGrid = gameImagesGrid;
    _gameImagesGrid.delegate = self;
}

-(void)setNumTilesSlider:(UISlider *)numTilesSlider
{
    _numTilesSlider = numTilesSlider;
    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.board.numCells;
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
    GridSize size = (GridSize){2, 0.5*(int)[gameImageNames count]};
    self.gameImagesGrid = [[ObjectGridVC alloc] initWithObjects:gameImageNames gridSize:size collectionView:self.pictureSelectionCollectionView andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, id obj, int objIndex) {
        
        NSString *imageName = (NSString *)obj;
        cell.backgroundView = [[TileView alloc] initWithFrame:cell.bounds
                                                     andImage:[UIImage imageNamed:imageName]];
        
        // check whether the image being displayed is the selected one (relies on the fact that the array of image names is in the same order as the array of the images passed into the grid object)
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
    int numTiles = self.numTilesSlider.value;
    
    GridSize size = (GridSize){sqrt(numTiles), sqrt(numTiles)};
    self.miniBoardCVDataSource = [[ObjectGridVC alloc] initWithObjects:nil gridSize:self.gameVCForSettings.puzzleGame.board.gridSize collectionView:self.miniGameBoardCV andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, id obj, int objIndex) {
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
    int initialNumTiles = self.gameVCForSettings.puzzleGame.board.numCells;
    Difficulty initialDifficulty = self.gameVCForSettings.puzzleGame.difficulty;
    NSString *initialImageName = self.gameVCForSettings.puzzleGame.imageName;
    
    int newNumTiles = (int)self.numTilesSlider.value;
    int newDifficulty = (int)self.difficultySegmentedControl.selectedSegmentIndex;
    NSString *newImageName = self.gameImageName;

    if (newNumTiles != initialNumTiles || newDifficulty != initialDifficulty || ![newImageName isEqualToString:initialImageName]) {
        GridSize size = (GridSize){sqrt(newNumTiles), sqrt(newNumTiles)};
        [self.gameVCForSettings setupNewGameWithBoardSize:size andDifficulty:newDifficulty withImageNamed:newImageName];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)numTilesChanges:(UISlider *)sender
{
    int numTilesAdjusted = (int)(sqrt(sender.value)) * (int)(sqrt(sender.value));
    self.numTilesSlider.value = numTilesAdjusted <= 9 ? 9 : numTilesAdjusted;
    [self resetMiniBoardView];
}

@end
