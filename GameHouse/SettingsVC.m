//
//  SettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SettingsVC.h"
#import "BoardView.h"
#import "ImageCollectionViewVC.h"

@interface SettingsVC () <ImageSelectedDelegate>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;
@property (weak, nonatomic) IBOutlet BoardView *miniGameBoardImageView;

// other
@property (strong, nonatomic) NSString *gameImageName;
@property (strong, nonatomic) ImageCollectionViewVC *gameImagesCVC;
@end

@implementation SettingsVC

#pragma mark - ImageSelectedDelegate

-(void)imageSelected:(NSString *)imageName
{
    self.gameImageName = imageName;
}

#pragma mark - Properties

-(void)setPictureSelectionCollectionView:(UICollectionView *)pictureSelectionCollectionView
{
    _pictureSelectionCollectionView = pictureSelectionCollectionView;
    self.pictureSelectionCollectionView.delegate = self.gameImagesCVC;
    self.pictureSelectionCollectionView.dataSource = self.gameImagesCVC;
}

-(ImageCollectionViewVC *)gameImagesCVC
{
    if (!_gameImagesCVC) {
        _gameImagesCVC = [[ImageCollectionViewVC alloc] init];
        _gameImagesCVC.imageNames = self.gameVCForSettings.availableImageNames;
        _gameImagesCVC.selectedImageName = self.gameImageName;
        _gameImagesCVC.delegate = self;
    }
    
    return _gameImagesCVC;
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
    self.gameImagesCVC.selectedImageName = self.gameImageName;
    [self.pictureSelectionCollectionView reloadData];
    [self setupMiniBoardView];
}

@end
