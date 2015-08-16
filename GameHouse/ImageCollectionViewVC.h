//
//  ImageCollectionViewVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSelectedDelegate <NSObject>

-(void)imageSelected:(NSString *)imageName;

@end

@interface ImageCollectionViewVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) id <ImageSelectedDelegate> delegate;

@property (strong, nonatomic) NSArray *imageNames;
@property (strong, nonatomic) NSString *selectedImageName;

@end
