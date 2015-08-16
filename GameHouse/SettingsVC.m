//
//  SettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SettingsVC.h"
@interface SettingsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureSelectionCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *miniGameBoardImageView;

// other
@property (strong, nonatomic) NSString *gameImageName;
//@property (strong, nonatomic) Grid *miniGameBoard;
@end

@implementation SettingsVC

#define CELL_IDENTIFIER @"CollectionCell"

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
    UICollectionViewCell *cell = [self.pictureSelectionCollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSString *nameOfImageToDisplay = self.gameVCForSettings.availableImageNames[indexPath.item];
    UIImage *imageToDisplay = [UIImage imageNamed:nameOfImageToDisplay];
    
    if (![cell.contentView.subviews count]) {
        UIImage *backgroundImage = [UIImage imageNamed:@"Wooden Tile"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        
        UIImageView *gameImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        gameImageView.image = imageToDisplay;
        [cell.contentView addSubview:gameImageView];
    } else {
        UIImageView *currentGameImageDisplayed = (UIImageView *)[cell.contentView.subviews firstObject];
        currentGameImageDisplayed.image = imageToDisplay;
    }
    
    if ([nameOfImageToDisplay isEqualToString:self.gameImageName]) {
        cell.alpha = 1.0;
    } else {
        cell.alpha = 0.5;
    }
    
    return cell;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.pictureSelectionCollectionView registerClass:[UICollectionViewCell class]
                            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.board.numberOfTiles;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
    self.gameImageName = self.gameVCForSettings.puzzleGame.imageName;
    //[self setupMiniBoardView];
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

/*-(void)setupMiniBoardView
{
    if ([self.miniGameBoardImageView.subviews count]) {
        [self.miniGameBoardImageView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
    }
    
    int numTiles = self.numTilesSlider.value;
    self.miniGameBoard = [[Grid alloc] initWithSize:self.miniGameBoardImageView.bounds.size withRows:sqrt(numTiles) andColumns:sqrt(numTiles)];
    
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
}*/

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
    //[self setupMiniBoardView];
}

#pragma mark - Properties

-(void)setGameImageName:(NSString *)gameImageName
{
    _gameImageName = gameImageName;
    [self.pictureSelectionCollectionView reloadData];
    self.miniGameBoardImageView.image = [UIImage imageNamed:self.gameImageName];
}

@end
