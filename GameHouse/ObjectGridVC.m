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
@property (nonatomic, copy) void (^cellConfigureBlock)(UICollectionViewCell *, Position, id, int);

@end

@implementation ObjectGridVC

#pragma mark - Initialiser

-(instancetype)initWithObjects:(NSArray *)cellObjects gridSize:(GridSize)size andCellConfigureBlock:(void (^)(UICollectionViewCell *, Position, id, int))cellConfigureBlock
{
    if (self = [super init]) {
        self.cellObjects = [cellObjects mutableCopy];
        self.gridSize = size;
        self.cellConfigureBlock = cellConfigureBlock;
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

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
#warning THIS DOES NOT WORK... IT IS TOO SPECIFIC TO THIS APP
    float cellWidthAndHeight = self.gridSize.columns < self.gridSize.rows ?
                                    collectionView.bounds.size.width / self.gridSize.columns :
                                    collectionView.bounds.size.height / self.gridSize.rows;
    
    return CGSizeMake(cellWidthAndHeight, cellWidthAndHeight);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.gridSize.rows;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gridSize.columns;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
#warning - FIX THIS CODE
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    /*cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.backgroundView.layer.borderWidth = 0.5;*/
    
    //int objIndex = self.gridSize.columns * (int)indexPath.section + (int)indexPath.item;
    
    Position currentPos = (Position){(int)indexPath.section, (int)indexPath.item};
    int objIndex = IndexOfPositionInGridOfSize(currentPos, self.gridSize);
    id obj = self.cellObjects[objIndex];
    self.cellConfigureBlock(cell, currentPos, obj, objIndex);
    
    return cell;
}

@end
