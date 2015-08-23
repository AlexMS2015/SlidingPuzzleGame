//
//  SettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SettingsVC.h"
#import "ImageGridVC.h"
#import "UIImage+Crop.h"

@interface SettingsVC () <ImageGridVCDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;

// other
@property (strong, nonatomic) NSString *gameImageName;
@property (strong, nonatomic) NSArray *availableGameImages;
@property (strong, nonatomic) ImageGridVC *gameImagesGrid;
@end

@implementation SettingsVC

#pragma mark - ImageGridVCDelegate

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

-(ImageGridVC *)gameImagesGrid
{
    if (!_gameImagesGrid) {
        _gameImagesGrid = [[ImageGridVC alloc] initWithImages:self.availableGameImages
                                                         rows:1
                                                      andCols:(int)[self.availableGameImages count]];
        _gameImagesGrid.delegate = self;
    }
    
    return _gameImagesGrid;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.board.numberOfTiles;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
    self.gameImageName = self.gameVCForSettings.puzzleGame.imageName;
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

-(void)setupMiniBoardView
{
    /*int numTiles = self.numTilesSlider.value;
    [self.miniGameBoardImageView setRows:sqrt(numTiles)
                              andColumns:sqrt(numTiles)
                                andImage:[UIImage imageNamed:self.gameImageName]];*/
}

#pragma mark - Actions

- (IBAction)cancelWithNoChanges:(UIButton *)sender
{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveSettings:(UIButton *)sender
{
    int initialNumTiles = self.gameVCForSettings.puzzleGame.board.numberOfTiles;
    Difficulty initialDifficulty = self.gameVCForSettings.puzzleGame.difficulty;
    NSString *initialImageName = self.gameVCForSettings.puzzleGame.imageName;
    
    int newNumTiles = (int)self.numTilesSlider.value;
    int newDifficulty = (int)self.difficultySegmentedControl.selectedSegmentIndex;
    NSString *newImageName = self.gameImageName;

    if (newNumTiles != initialNumTiles || newDifficulty != initialDifficulty || ![newImageName isEqualToString:initialImageName]) {
        [self.gameVCForSettings setupNewGameWithNumTiles:newNumTiles
                                           andDifficulty:newDifficulty
                                          withImageNamed:newImageName];
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
    [self setupMiniBoardView];
}

#pragma mark - Properties

-(void)setGameImageName:(NSString *)gameImageName
{
    _gameImageName = gameImageName;
    NSLog(@"selected image with name: %@", gameImageName);
#warning SHOCKING CODE HERE... SO DEPENDANT
    //self.gameImagesCVC.selectedImageName = self.gameImageName;
    [self.pictureSelectionCollectionView reloadData];
    //[self setupMiniBoardView];
}

@end
