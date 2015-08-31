//
//  BoardCVC.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GridVC.h"

@interface GridVC ()

@property (nonatomic, copy) void (^cellConfigureBlock)(UICollectionViewCell *, Position, int);

@end

@implementation GridVC

#pragma mark - Initialiser

-(instancetype)initWithgridSize:(GridSize)size collectionView:(UICollectionView *)collectionView andCellConfigureBlock:(void (^)(UICollectionViewCell *, Position, int))cellConfigureBlock
{
    if (self = [super init]) {
        self.collectionView = collectionView;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.cellConfigureBlock = cellConfigureBlock;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        Orientation orientation = layout.scrollDirection == UICollectionViewScrollDirectionVertical ?
                            VERTICAL : HORIZONTAL;
        
        self.grid = [[Grid alloc] initWithGridSize:size andOrientation:orientation];
    }
    
    return self;
}

#define CELL_IDENTIFIER @"CollectionCell"

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int objIndex = (int)indexPath.item;
    [self.delegate tileTappedAtPosition:[self.grid positionOfIndex:objIndex]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidth, cellHeight;
    
    if (self.collectionView.scrollEnabled) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        cellWidth = layout.scrollDirection == UICollectionViewScrollDirectionVertical ?
                            collectionView.bounds.size.width / self.grid.size.columns :
                            collectionView.bounds.size.height / self.grid.size.rows;
        cellHeight = cellWidth;
    } else {
        cellWidth = collectionView.bounds.size.width / self.grid.size.columns;
        cellHeight = collectionView.bounds.size.height / self.grid.size.rows;
    }
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.grid.size.rows * self.grid.size.columns;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
#warning - FIX THIS CODE
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    int objIndex = (int)indexPath.item;
    Position currentPos = [self.grid positionOfIndex:objIndex];
    self.cellConfigureBlock(cell, currentPos, objIndex);
    return cell;
}

@end