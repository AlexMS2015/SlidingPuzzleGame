//
//  ASSlidingTileView.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ASSlidingTileView : UIView

@property (nonatomic) int tileValue;
@property (nonatomic, strong) UIImage *tileImage;

@property (nonatomic) int rowInABoard;
@property (nonatomic) int columnInABoard;

-(void)animateToFrame:(CGRect)frame;

@end
