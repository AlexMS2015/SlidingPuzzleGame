//
//  ASSlidingPuzzleSettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleSettingsVC.h"
#import "ASGameBoardViewSupporter.h"

@interface ASSlidingPuzzleSettingsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *miniGameBoardImageView;

// other
@property (nonatomic) int newNumTiles;
@property (nonatomic) Difficulty newDifficulty;
@property (strong, nonatomic) NSString *gameImageName;

@property (strong, nonatomic) ASGameBoardViewSupporter *miniGameBoard;
@end

@implementation ASSlidingPuzzleSettingsVC

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.gameImageName = self.gameVCForSettings.availableImageNames[indexPath.item];
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
    
    if ([imageName isEqualToString:self.gameImageName]) {
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
    
    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.board.numberOfTiles;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
    self.gameImageName = self.gameVCForSettings.imageName;
    
    [self setupMiniBoardWithNumTiles:self.gameVCForSettings.puzzleGame.board.numberOfTiles];
}

-(void)setupMiniBoardWithNumTiles:(int)numTiles
{
    if ([self.miniGameBoardImageView.subviews count]) {
        [self.miniGameBoardImageView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
    }
    
    self.miniGameBoard = [[ASGameBoardViewSupporter alloc] initWithSize:self.miniGameBoardImageView.bounds.size withRows:sqrt(numTiles) andColumns:sqrt(numTiles)];
    
    self.miniGameBoardImageView.image = [UIImage imageNamed:self.gameImageName];
    
    
    Position currentPosition;
    int tileCount = 0;
    for (currentPosition.row = 0; currentPosition.row < sqrt(numTiles); currentPosition.row++) {
        for (currentPosition.column = 0; currentPosition.column < sqrt(numTiles); currentPosition.column++) {
            CGRect frameOfTile = [self.miniGameBoard frameOfCellAtPosition:currentPosition];
            UILabel *tileLabel = [[UILabel alloc] initWithFrame:frameOfTile];
            //tileLabel.alpha = 0.5;
            
            if (tileCount == 0 || tileCount == numTiles - 1) {
                tileLabel.text = [NSString stringWithFormat:@"%d", tileCount + 1];
            }
            
            tileLabel.font = [UIFont systemFontOfSize:tileLabel.bounds.size.width / 1.5];
            tileLabel.textColor = [UIColor whiteColor];
            tileLabel.textAlignment = NSTextAlignmentCenter;
            tileLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            tileLabel.layer.borderWidth = 0.5;
            
            [self.miniGameBoardImageView addSubview:tileLabel];
            
            tileCount++;
        }
    }
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
    NSString *initialImageName = self.gameVCForSettings.imageName;

    if (self.newNumTiles != initialNumTiles || self.newDifficulty != initialDifficulty || self.gameImageName != initialImageName) {
        [self.gameVCForSettings.puzzleGame save];
        [self.gameVCForSettings setupNewGameWithNumTiles:self.newNumTiles
                                           andDifficulty:self.newDifficulty
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
    [self setupMiniBoardWithNumTiles:numTilesAdjusted];
}

#pragma mark - Properties

-(void)setGameImageName:(NSString *)gameImageName
{
    _gameImageName = gameImageName;
    [self.pictureSelectionCollectionView reloadData];
    [self setupMiniBoardWithNumTiles:self.numTilesSlider.value];
}

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

@end
