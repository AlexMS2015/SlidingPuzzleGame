//
//  BoardCVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "GridInterface.h"

@protocol ObjectGridVCDelegate <NSObject>

-(void)tileTappedAtPosition:(Position)position;

@end

@interface ObjectGridVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) id<ObjectGridVCDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *cellObjects;

#warning SHOULD FAIL IF COUNT OF ARRAY DOESN'T EQUAL TO NUMBER OF CELLS IN GRID
// MAKE THIS A GENERIC OBJECT GRID AND ALSO USE GRIDSIZE STRUCT!!!!!
// ADD THE WHITE BORDER COLOUR ONTO THIS CLASS
-(instancetype)initWithObjects:(NSArray *)cellObjects
                      gridSize:(GridSize)size
         andCellConfigureBlock:(void (^)(UICollectionViewCell *cell, Position position, id obj, int objIndex))cellConfigureBlock;

@end
