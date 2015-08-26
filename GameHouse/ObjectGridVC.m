//
//  BoardCVC.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ObjectGridVC.h"

@interface ObjectGridVC ()

@property (nonatomic, copy) void (^cellConfigureBlock)(UICollectionViewCell *, Position, id, int);

@end

@implementation ObjectGridVC

#pragma mark - Initialiser

-(instancetype)initWithObjects:(NSArray *)cellObjects gridSize:(GridSize)size collectionView:(UICollectionView *)collectionView andCellConfigureBlock:(void (^)(UICollectionViewCell *, Position, id, int))cellConfigureBlock
{
    if (self = [super init]) {
        self.collectionView = collectionView;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.cellConfigureBlock = cellConfigureBlock;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        Orientation orientation =
                layout.scrollDirection == UICollectionViewScrollDirectionVertical ?
                                                VERTICAL : HORIZONTAL;
        
        self.objectGrid = [[GridOfObjects alloc] initWithSize:size
                                               andOrientation:orientation
                                                   andObjects:cellObjects];
    }
    
    return self;
}

#define CELL_IDENTIFIER @"CollectionCell"

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int objIndex = (int)indexPath.item;
    [self.delegate tileTappedAtPosition:
            PositionOfIndexInGrid(objIndex, self.objectGrid.gridSize, self.objectGrid.orientation)];
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
                            collectionView.bounds.size.width / self.objectGrid.gridSize.columns :
                            collectionView.bounds.size.height / self.objectGrid.gridSize.rows;
        cellHeight = cellWidth;
    } else {
        cellWidth = collectionView.bounds.size.width / self.objectGrid.gridSize.columns;
        cellHeight = collectionView.bounds.size.height / self.objectGrid.gridSize.rows;
    }
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.objectGrid.objects count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
#warning - FIX THIS CODE
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    int objIndex = (int)indexPath.item;
    Position currentPos =
            PositionOfIndexInGrid(objIndex, self.objectGrid.gridSize, self.objectGrid.orientation);
    id obj = [self.objectGrid objectAtPosition:currentPos];
    self.cellConfigureBlock(cell, currentPos, obj, objIndex);
    
    return cell;
}

@end
