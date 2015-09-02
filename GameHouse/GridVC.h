//
//  BoardCVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"

@protocol GridVCDelegate <NSObject>

-(void)tileTappedAtPosition:(Position)position;

@end

@interface GridVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) id<GridVCDelegate> delegate;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) Grid *grid;


// ADD THE WHITE BORDER COLOUR ONTO THIS CLASS

-(instancetype)initWithgridSize:(GridSize)size
                 collectionView:(UICollectionView *)collectionView
          andCellConfigureBlock:(void (^)(UICollectionViewCell *cell, Position position, int index))cellConfigureBlock;

@end
