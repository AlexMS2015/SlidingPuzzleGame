//
//  TileView.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileView : UIView

@property (nonatomic) int tileValue;
@property (nonatomic, strong) UIImage *tileImage;

// designated initialiser (other initialisers like initWithFrame: won't do anything)
-(instancetype)initWithFrame:(CGRect)frame
            andImage:(UIImage *)image
                    andValue:(int)value;

-(instancetype)initWithFrame:(CGRect)frame
                    andImage:(UIImage *)image;

-(void)animateToFrame:(CGRect)frame;

@end
