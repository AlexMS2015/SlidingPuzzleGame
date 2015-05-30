//
//  ASSlidingPuzzleGameCVC.m
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleGameCVC.h"
#import "ASSlidingPuzzleGame.h"
#import "ASSPGCVC.h"

@interface ASSlidingPuzzleGameCVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ASSlidingPuzzleGame *game;
@property (nonatomic) int numberOfTiles;

@end

@implementation ASSlidingPuzzleGameCVC

#pragma mark - Properties

#define NUM_TILES_DEFAULT 9
-(int)numberOfTiles
{
    return NUM_TILES_DEFAULT;
}

#define TILE_CELL_IDENTIFIER @"TileCell"

-(instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //[flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self = [super initWithCollectionViewLayout:flowLayout];
    
    if (self) {
        
        // set collection view layout

        [self.collectionView setCollectionViewLayout:flowLayout];
        
        // set cell re-use identifier
        UINib *tileCellNib = [UINib nibWithNibName:@"ASSPGCVC" bundle:nil];
        [self.collectionView registerNib:tileCellNib forCellWithReuseIdentifier:TILE_CELL_IDENTIFIER];

        //self.game = [[ASSlidingPuzzleGame alloc] initWithNumberOfTiles:self.numberOfTiles];
    }
    
    return self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // number of items in each row (i.e. number of columns)
    return sqrt(self.numberOfTiles);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return sqrt(self.numberOfTiles);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TILE_CELL_IDENTIFIER forIndexPath:indexPath];

    ASSPGCVC *spgTile;
    if ([cell isMemberOfClass:[ASSPGCVC class]]) {
        spgTile = (ASSPGCVC *)cell;
    }
    
    int valueInCell = [self.game valueOfTileAtRow:(int)indexPath.section andColumn:(int)indexPath.item];
    
    spgTile.titleLabel.text = [NSString stringWithFormat:@"%d", valueInCell];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
