//
//  TileView.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@interface TileView : UIView

@property (nonatomic) Position positionInABoard;
@property (nonatomic, readonly) int tileValue;

// designated initialiser (other initialisers like initWithFrame: won't do anything)
-(instancetype)initWithFrame:(CGRect)frame
            andImage:(UIImage *)image
            andValue:(int)value
  andPositionInBoard:(Position)position;

-(void)animateToFrame:(CGRect)frame;

@end
