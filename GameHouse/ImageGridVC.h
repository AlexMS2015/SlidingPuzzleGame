//
//  BoardCVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums+Structs.h"

@protocol ImageGridVCDelegate <NSObject>

-(void)tileTappedAtPosition:(Position)position;

@end

@interface ImageGridVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) id<ImageGridVCDelegate> delegate;

-(instancetype)initWithImages:(NSArray *)imagesToDisplay rows:(int)rows andCols:(int)cols;

@end
