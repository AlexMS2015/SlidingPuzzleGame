//
//  ASSlidingPuzzleSettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleSettingsVC.h"
#import "Enums.h"
#import "ASPictureSelectionScreenVC.h"

@interface ASSlidingPuzzleSettingsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;

// other
@property (nonatomic) int newNumTiles;
@property (nonatomic) Difficulty newDifficulty;
@property (nonatomic) GameMode newMode;
@property (nonatomic) NSString *gameImageName;
@end

@implementation ASSlidingPuzzleSettingsVC

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.gameImageName = self.gameVCForSettings.availableImageNames[indexPath.item];
    [self.pictureSelectionCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.gameVCForSettings.availableImageNames count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.pictureSelectionCollectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];

    for (UIView *subview in cell.subviews) {
        [subview removeFromSuperview];
    }
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:cell.bounds];
    background.image = [UIImage imageNamed:@"Wooden Tile"];
    [cell addSubview:background];
    
    NSString *imageName = self.gameVCForSettings.availableImageNames[indexPath.item];
    UIImageView *picture = [[UIImageView alloc] initWithFrame:cell.bounds];
    picture.image = [UIImage imageNamed:imageName];
    [cell addSubview:picture];
    
    if (imageName == self.gameImageName) {
        cell.alpha = 1.0;
    } else {
        cell.alpha = 0.5;
    }
    
    return cell;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pictureSelectionCollectionView registerClass:[UICollectionViewCell class]
                            forCellWithReuseIdentifier:@"CollectionCell"];
    
    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.numberOfTiles;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
    self.gameModeSegmentedControl.selectedSegmentIndex = self.gameVCForSettings.mode;
    self.gameImageName = self.gameVCForSettings.imageName;
    
    if (self.gameVCForSettings.mode == PICTUREMODE) {
        self.pictureSelectionCollectionView.hidden = NO;
    } else {
        self.pictureSelectionCollectionView.hidden = YES;
    }
    
}

#pragma mark - Actions

- (IBAction)cancelWithNoChanges:(UIButton *)sender
{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveSettings:(UIButton *)sender
{
    int initialNumTiles = self.gameVCForSettings.puzzleGame.numberOfTiles;
    Difficulty initialDifficulty = self.gameVCForSettings.puzzleGame.difficulty;
    GameMode initialMode = self.gameVCForSettings.mode;
    NSString *initialImageName = self.gameVCForSettings.imageName;

    if (self.newNumTiles != initialNumTiles || self.newDifficulty != initialDifficulty || self.newMode != initialMode || self.gameImageName != initialImageName) {
        [self.gameVCForSettings setupNewGameWithNumTiles:self.newNumTiles
                                           andDifficulty:self.newDifficulty
                                                 andMode:self.newMode
                                          withImageNamed:self.gameImageName];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)numTilesChanges:(UISlider *)sender
{
    int numTilesAdjusted = (int)(sqrt(sender.value)) * (int)(sqrt(sender.value));
    
    if (numTilesAdjusted <= 9) {
        numTilesAdjusted = 9;
    }
    
    self.numTilesSlider.value = numTilesAdjusted;
}

- (IBAction)gameModeChanged:(UISegmentedControl *)sender
{
    if (self.newMode == PICTUREMODE) {
        self.pictureSelectionCollectionView.hidden = NO;
    } else if (self.newMode == NUMBERMODE) {
        self.pictureSelectionCollectionView.hidden = YES;
    }
}

#pragma mark - Properties

-(int)newNumTiles
{
    return (int)self.numTilesSlider.value;
}

-(Difficulty)newDifficulty
{
    if (self.difficultySegmentedControl.selectedSegmentIndex == 0) {
        return EASY;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 1) {
        return MEDIUM;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 2) {
        return HARD;
    } else {
        return self.gameVCForSettings.puzzleGame.difficulty;
    }
}

-(GameMode)newMode
{
    if (self.gameModeSegmentedControl.selectedSegmentIndex == 0) {
        return NUMBERMODE;
    } else if (self.gameModeSegmentedControl.selectedSegmentIndex == 1) {
        return PICTUREMODE;
    } else {
        return self.gameVCForSettings.mode;
    }
}

@end
