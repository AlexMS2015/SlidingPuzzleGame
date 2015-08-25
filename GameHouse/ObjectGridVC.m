//
//  BoardCVC.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ObjectGridVC.h"

@interface ObjectGridVC ()

@property (nonatomic) GridSize gridSize;
@property (strong, nonatomic) NSMutableArray *cellObjects;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, copy) void (^cellConfigureBlock)(UICollectionViewCell *, Position, id, int);

@end

@implementation ObjectGridVC

-(void)moveObjectAtPosition:(Position)pos1 toPosition:(Position)pos2
{
    int oldPosIdx = IndexOfPositionInGridOfSize(pos1, self.gridSize);
    int newPosIdx = IndexOfPositionInGridOfSize(pos2, self.gridSize);
    
    [self.cellObjects exchangeObjectAtIndex:oldPosIdx withObjectAtIndex:newPosIdx];

    NSIndexPath *oldPosPath = [NSIndexPath indexPathForItem:oldPosIdx inSection:0];
    NSIndexPath *newPosPath = [NSIndexPath indexPathForItem:newPosIdx inSection:0];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveItemAtIndexPath:oldPosPath toIndexPath:newPosPath];
        [self.collectionView moveItemAtIndexPath:newPosPath toIndexPath:oldPosPath];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Initialiser

-(instancetype)initWithObjects:(NSArray *)cellObjects gridSize:(GridSize)size collectionView:(UICollectionView *)collectionView andCellConfigureBlock:(void (^)(UICollectionViewCell *, Position, id, int))cellConfigureBlock
{
    if (self = [super init]) {
        self.cellObjects = [cellObjects mutableCopy];
        self.collectionView = collectionView;
        self.gridSize = size;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.cellConfigureBlock = cellConfigureBlock;
    }
    
    return self;
}

-(void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView = collectionView;
    if (!self.collectionView.scrollEnabled) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
}

#define CELL_IDENTIFIER @"CollectionCell"

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int objIndex = (int)indexPath.item;
    [self.delegate tileTappedAtPosition:PositionForIndexInGridOfSize(objIndex, self.gridSize)];
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
                            collectionView.bounds.size.width / self.gridSize.columns :
                            collectionView.bounds.size.height / self.gridSize.rows;
        cellHeight = cellWidth;
    } else {
        cellWidth = collectionView.bounds.size.width / self.gridSize.columns;
        cellHeight = collectionView.bounds.size.height / self.gridSize.rows;
    }
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gridSize.rows * self.gridSize.columns;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
#warning - FIX THIS CODE
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    int objIndex = (int)indexPath.item;
    Position currentPos = PositionForIndexInGridOfSize(objIndex, self.gridSize);
    id obj = self.cellObjects[objIndex];
    self.cellConfigureBlock(cell, currentPos, obj, objIndex);
    
    return cell;
}

@end
