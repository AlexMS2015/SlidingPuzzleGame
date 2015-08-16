//
//  ImageCollectionViewVC.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ImageCollectionViewVC.h"
#import "TileView.h"

@implementation ImageCollectionViewVC

#define CELL_IDENTIFIER @"CollectionCell"

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate imageSelected:self.imageNames[indexPath.item]];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageNames count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerClass:[UICollectionViewCell class]
       forCellWithReuseIdentifier:CELL_IDENTIFIER]; // BAD CODE?
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSString *nameOfImageToDisplay = self.imageNames[indexPath.item];
    UIImage *imageToDisplay = [UIImage imageNamed:nameOfImageToDisplay];
    
    TileView *tile = [[TileView alloc] initWithFrame:cell.bounds andImage:imageToDisplay];
    [cell addSubview:tile];
    
    cell.alpha = [nameOfImageToDisplay isEqualToString:self.selectedImageName] ? 1.0 : 0.5;
    
    return cell;
}

@end
