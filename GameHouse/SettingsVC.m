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

@interface SettingsVC () <ObjectGridVCDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *miniGameBoardCV;

// other
@property (strong, nonatomic) NSString *gameImageName;
@property (strong, nonatomic) NSArray *availableGameImages;
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

-(NSArray *)availableGameImages
{
    if (!_availableGameImages) {
        _availableGameImages = [UIImage imagesForLocalImagesNames:self.gameVCForSettings.availableImageNames];
    }
    
    return _availableGameImages;
}

-(void)setPictureSelectionCollectionView:(UICollectionView *)pictureSelectionCollectionView
{
    _pictureSelectionCollectionView = pictureSelectionCollectionView;
    self.pictureSelectionCollectionView.delegate = self.gameImagesGrid;
    self.pictureSelectionCollectionView.dataSource = self.gameImagesGrid;
}

-(ObjectGridVC *)gameImagesGrid
{
    if (!_gameImagesGrid) {
        GridSize size = (GridSize){1, (int)[self.availableGameImages count]};
        _gameImagesGrid = [[ObjectGridVC alloc] initWithObjects:self.availableGameImages gridSize:size andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, id obj, int objIndex) {
            
            cell.backgroundView = [[TileView alloc] initWithFrame:cell.bounds
                                                         andImage:(UIImage *)obj];
            
            // check whether the image being displayed is the selected one (relies on the fact that the array of image names is in the same order as the array of the images passed into the grid object)
            NSString *imageName = self.gameVCForSettings.availableImageNames[objIndex];
            cell.alpha = [imageName isEqualToString:self.gameImageName] ? 1.0 : 0.5;
        }];
        _gameImagesGrid.delegate = self;
    }
    
    return _gameImagesGrid;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.board.numCells;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
    self.gameImageName = self.gameVCForSettings.puzzleGame.imageName;
    [self resetMiniBoardView];
}

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
    self.miniBoardCVDataSource = [[ObjectGridVC alloc] initWithObjects:nil gridSize:size andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, id obj, int objIndex) {
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.backgroundView.layer.borderWidth = 0.5;
    }];
    self.miniGameBoardCV.dataSource = self.miniBoardCVDataSource;
    self.miniGameBoardCV.delegate = self.miniBoardCVDataSource;
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

#pragma mark - Properties

-(void)setGameImageName:(NSString *)gameImageName
{
    _gameImageName = gameImageName;
    [self.pictureSelectionCollectionView reloadData];
}

@end
