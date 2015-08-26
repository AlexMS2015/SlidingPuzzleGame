//
//  NoScrollObjectGrid.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 25/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "NoScrollObjectGridVC.h"
#import "GridInterface.h"

@implementation NoScrollObjectGridVC

-(void)setCollectionView:(UICollectionView *)collectionView
{
    [super setCollectionView:collectionView];
    self.collectionView.scrollEnabled = NO;
}

-(void)moveObjectAtPosition:(Position)pos1 toPosition:(Position)pos2
{
    [self.objectGrid swapObjectAtPosition:pos1 withObjectAtPosition:pos2];
    
    int oldPosIdx =
            IndexOfPositionInGrid(pos1, self.objectGrid.gridSize, self.objectGrid.orientation);
    int newPosIdx =
            IndexOfPositionInGrid(pos2, self.objectGrid.gridSize, self.objectGrid.orientation);
    NSIndexPath *oldPosPath = [NSIndexPath indexPathForItem:oldPosIdx inSection:0];
    NSIndexPath *newPosPath = [NSIndexPath indexPathForItem:newPosIdx inSection:0];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveItemAtIndexPath:oldPosPath toIndexPath:newPosPath];
        [self.collectionView moveItemAtIndexPath:newPosPath toIndexPath:oldPosPath];
    } completion:^(BOOL finished) {
    }];
}

@end
