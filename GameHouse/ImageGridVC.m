//
//  BoardCVC.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ImageGridVC.h"
#import "UIImage+Crop.h"
#import "TileView.h"

@interface ImageGridVC ()

@property (strong, nonatomic) NSArray *cellImages;
@property (nonatomic) int numRows;
@property (nonatomic) int numCols;

@end

@implementation ImageGridVC

#pragma mark - Initialiser

-(instancetype)initWithImages:(NSArray *)imagesToDisplay rows:(int)rows andCols:(int)cols
{
    if (self = [super init]) {
        self.cellImages = imagesToDisplay;
        self.numRows = rows;
        self.numCols = cols;
    }
    
    return self;
}

#define CELL_IDENTIFIER @"CollectionCell"

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tileTappedAtPosition:(Position){(int)indexPath.section, (int)indexPath.item}];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidthAndHeight;
    if (self.numCols < self.numRows) {
        cellWidthAndHeight = collectionView.bounds.size.width / self.numCols;
    } else {
        cellWidthAndHeight = collectionView.bounds.size.height / self.numRows;
    }
    
    return CGSizeMake(cellWidthAndHeight, cellWidthAndHeight);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numRows;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numCols;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark - USE A STATIC VOID HERE INSTEAD
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    //Position currentPos = (Position){(int)indexPath.section, (int)indexPath.item};
    //int valueOfTileToDisplay = [self.boardToDisplay valueOfTileAtPosition:currentPos];
    //UIImage *imageOfTileToDisplay = self.cellImages[valueOfTileToDisplay];

    int cellImageIndex = self.numCols * (int)indexPath.section + (int)indexPath.item;
    //NSLog(@"{section, item} = {%d, %d}", (int)indexPath.section, (int)indexPath.item);
    //NSLog(@"imageIndex: %d", cellImageIndex);
    UIImage *cellImage = self.cellImages[cellImageIndex];

    [self configureCell:cell atIndexPath:indexPath withImage:cellImage];
    
    return cell;
}

-(void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withImage:(UIImage *)image
{
    int valueOfTileToDisplay = self.numCols * (int)indexPath.section + (int)indexPath.item;
    
    NSLog(@"{section, item} = {%d, %d}", (int)indexPath.section, (int)indexPath.item);
    NSLog(@"tileValue: %d", valueOfTileToDisplay);
    
    cell.backgroundView = nil;
    if (valueOfTileToDisplay != 0) {
        TileView *tileToDisplay = [[TileView alloc] initWithFrame:cell.bounds andImage:image andValue:valueOfTileToDisplay];
        cell.backgroundView = tileToDisplay;
    }
}

@end
