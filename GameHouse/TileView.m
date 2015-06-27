//
//  ASSlidingTileView.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "TileView.h"

@implementation TileView

#pragma mark - Properties

-(void)setPositionInABoard:(Position)positionInABoard
{
    _positionInABoard.row = positionInABoard.row;
    _positionInABoard.column = positionInABoard.column;
}

-(void)setTileValue:(int)tileValue
{
    _tileValue = tileValue;
}

#define FONT_SIZE self.bounds.size.width/4.5
-(void)setTileImage:(UIImage *)tileImage
{    
    UIImageView *tileForeground = [[UIImageView alloc] initWithFrame:self.bounds];
    tileForeground.image = tileImage;
    tileForeground.layer.cornerRadius = 8.0;
    tileForeground.layer.masksToBounds = YES;
    [self addSubview:tileForeground];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        UIImageView *tileBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        tileBackground.image = [UIImage imageNamed:@"Wooden Tile"];
        [self addSubview:tileBackground];
    }
    
    return self;
}

-(void)animateToFrame:(CGRect)frame
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = frame;
                     }
                     completion:NULL];
}

@end
