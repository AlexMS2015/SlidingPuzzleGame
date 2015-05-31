//
//  ASSlidingTileView.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingTileView.h"

@interface ASSlidingTileView ()
@property (strong, nonatomic) UIImageView *tileBackground;
@end

@implementation ASSlidingTileView

#pragma mark - Properties

#define FONT_SIZE self.bounds.size.width/2.5
-(void)setTileValue:(int)tileValue
{
    _tileValue = tileValue;
    self.tileBackground.image = [UIImage imageNamed:@"Wooden Tile"];
    
    // add a label showing the tile's value in number mode
    UILabel *tileValueLabel = [[UILabel alloc] initWithFrame:self.bounds];
    tileValueLabel.textAlignment = NSTextAlignmentCenter;
    tileValueLabel.textColor = [UIColor whiteColor];
    tileValueLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    tileValueLabel.text = [NSString stringWithFormat:@"%d", tileValue];
    [self addSubview:tileValueLabel];
}

-(void)setTileImage:(UIImage *)tileImage
{
    self.tileBackground.image = tileImage;
    
    // add an image to the tile to show the grid when in picture mode
    UIImageView *tileForeground = [[UIImageView alloc] initWithFrame:self.bounds];
    tileForeground.image = [UIImage imageNamed:@"Grey Tile"];
    tileForeground.alpha = 0.5;
    [self addSubview:tileForeground];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // this tile image will be customised depeding on whether
        self.tileBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.tileBackground];
    }
    
    return self;
}

-(void)animateToFrame:(CGRect)frame
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = frame;
                     }
                     completion:NULL];
}

@end
