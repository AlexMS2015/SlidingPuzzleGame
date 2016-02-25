//
//  SettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SettingsVC.h"
#import "CollectionViewDataSource.h"
#import "UICollectionViewFlowLayout+GridLayout.h"
#import "UIImage+Crop.h"
#import "TileView.h"
#import "PuzzleGameVC.h"
#import "SlidingPuzzleGame.h"

@interface SettingsVC () <UICollectionViewDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numRowsSlider;
@property (weak, nonatomic) IBOutlet UISlider *numColsSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *miniGameBoardCV;

// other
@property (strong, nonatomic) NSString *gameImageName;
@property (strong, nonatomic) CollectionViewDataSource *gameImagesDataSource;
@property (strong, nonatomic) CollectionViewDataSource *miniBoardDataSource;
@end

@implementation SettingsVC

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

-(void)setNumRowsSlider:(UISlider *)numRowsSlider
{
    _numRowsSlider = numRowsSlider;
    self.numRowsSlider.value = self.gameVCForSettings.puzzleGame.board.numRows;
    [self resetMiniBoardView];
}

-(void)setNumColsSlider:(UISlider *)numColsSlider
{
    _numColsSlider = numColsSlider;
    self.numColsSlider.value = self.gameVCForSettings.puzzleGame.board.numCols;
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
    
    static NSString * const CVC_IDENTIFIER = @"CollectionViewCell";
    [self.pictureSelectionCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CVC_IDENTIFIER];
    
    self.gameImagesDataSource = [[CollectionViewDataSource alloc] initWithSections:1 itemsPerSection:[gameImageNames count] cellIdentifier:CVC_IDENTIFIER cellConfigureBlock:^(NSInteger section, NSInteger item, UICollectionViewCell *cell) {
            NSString *imageName = gameImageNames[item];
            cell.backgroundView = [[TileView alloc] initWithFrame:cell.bounds
                                                         andImage:[UIImage imageNamed:imageName]];
            cell.alpha = [imageName isEqualToString:self.gameImageName] ? 1.0 : 0.5;
    }];
    self.pictureSelectionCollectionView.dataSource = self.gameImagesDataSource;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.pictureSelectionCollectionView.collectionViewLayout;
    [layout layoutAsGrid];
    
    self.pictureSelectionCollectionView.delegate = self;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.gameImageName = self.gameVCForSettings.availableImageNames[indexPath.item];
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
    if (self.numRowsSlider.value > 0 && self.numColsSlider.value > 0) {
        static NSString * const CVC_IDENTIFIER2 = @"CollectionViewCell";
        [self.miniGameBoardCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CVC_IDENTIFIER2];
        
        NSLog(@"%f, %f", self.numRowsSlider.value, self.numColsSlider.value);
        
        self.miniBoardDataSource = [[CollectionViewDataSource alloc] initWithSections:self.numRowsSlider.value itemsPerSection:self.numColsSlider.value cellIdentifier:CVC_IDENTIFIER2 cellConfigureBlock:^(NSInteger section, NSInteger item, UICollectionViewCell *cell) {
            
            cell.backgroundView = [[UIView alloc] init];
            cell.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.backgroundView.layer.borderWidth = 0.5;
        }];
        self.miniGameBoardCV.dataSource = self.miniBoardDataSource;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.miniGameBoardCV.collectionViewLayout;
        [layout layoutAsGrid];
    }
}

#pragma mark - Actions

- (IBAction)cancelWithNoChanges:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveSettings:(UIButton *)sender
{
    NSInteger initialNumRows = self.gameVCForSettings.puzzleGame.board.numRows;
    NSInteger initialNumCols = self.gameVCForSettings.puzzleGame.board.numCols;
    Difficulty initialDifficulty = self.gameVCForSettings.puzzleGame.difficulty;
    NSString *initialImageName = self.gameVCForSettings.puzzleGame.imageName;
    
    int newNumRows = (int)self.numRowsSlider.value;
    int newNumCols = (int)self.numColsSlider.value;
    int newDifficulty = (int)self.difficultySegmentedControl.selectedSegmentIndex;
    NSString *newImageName = self.gameImageName;

    if (newNumRows != initialNumRows || newNumCols != initialNumCols || newDifficulty != initialDifficulty || ![newImageName isEqualToString:initialImageName]) {
        [self.gameVCForSettings setupNewGameWithRows:newNumRows andColumns:newNumCols andDifficulty:newDifficulty withImageNamed:newImageName];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)numTilesChanges:(UISlider *)sender
{
    sender.value = round(sender.value);
    
    if (round(self.numRowsSlider.value) != self.miniGameBoardCV.numberOfSections ||
        round(self.numColsSlider.value) != [self.miniGameBoardCV numberOfItemsInSection:0]) {
        [self resetMiniBoardView];
    }
}

@end
