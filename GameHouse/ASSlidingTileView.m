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
@property (strong, nonatomic) UILabel *tileValueLabel;
@end

@implementation ASSlidingTileView

#pragma mark - Properties

#define FONT_SIZE self.bounds.size.width/2.5
-(void)setTileValue:(int)tileValue
{
    _tileValue = tileValue;
    
    // add a label showing the tile's value in number mode
    self.tileValueLabel.textAlignment = NSTextAlignmentCenter;
    self.tileValueLabel.textColor = [UIColor whiteColor];
    self.tileValueLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.tileValueLabel.text = [NSString stringWithFormat:@"%d", tileValue];
}

-(void)setTileImage:(UIImage *)tileImage
{
    [self.tileValueLabel removeFromSuperview];
    self.tileValueLabel = nil;
    
    // add an image to the tile to show the grid when in picture mode
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
        
        // this tile image will be customised depeding on whether
        self.tileBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        self.tileBackground.image = [UIImage imageNamed:@"Wooden Tile"];
        [self addSubview:self.tileBackground];
        
        self.tileValueLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.tileValueLabel];
    }
    
    return self;
}

-(void)animateToFrame:(CGRect)frame
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = frame;
                     }
                     completion:NULL];
}

/*
-(void)animateChangePositionOnBoardToRect:(CGRect)newPosition
{
    [self animateToFrame:newPosition
               withDelay:0
             andDuration:0.3
              andOptions:UIViewAnimationOptionCurveEaseOut];
}

-(void)animateToFrame:(CGRect)frame
            withDelay:(double)delay
          andDuration:(double)duration
           andOptions:(UIViewAnimationOptions)options
{
    [UIView animateWithDuration:duration
                          delay:delay
                        options:options
                     animations:^{
                         self.frame = frame;
                     }
                     completion:NULL];
}
*/

@end
