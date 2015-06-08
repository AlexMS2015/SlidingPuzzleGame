//
//  ASSlidingTileView.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingTileView.h"

@interface ASSlidingTileView ()

@end

@implementation ASSlidingTileView

#pragma mark - Properties

-(void)setTileValue:(int)tileValue
{
    _tileValue = tileValue;
}

#define FONT_SIZE self.bounds.size.width/4.5
-(void)setTileImage:(UIImage *)tileImage
{    
    // add an image to the tile to show the grid when in picture mode
    UIImageView *tileForeground = [[UIImageView alloc] initWithFrame:self.bounds];
    tileForeground.image = tileImage;
    tileForeground.layer.cornerRadius = 8.0;
    tileForeground.layer.masksToBounds = YES;
    [self addSubview:tileForeground];
    
    /*
    // add a label showing the tile's value
    CGRect labelFrame = CGRectMake(5, 5, 10, 10);
    self.tileValueLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.tileValueLabel.textAlignment = NSTextAlignmentLeft;
    self.tileValueLabel.textColor = [UIColor whiteColor];
    self.tileValueLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.tileValueLabel.text = [NSString stringWithFormat:@"%d", self.tileValue];
    [self addSubview:self.tileValueLabel];
     */
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        // this tile image will be customised depeding on whether
        UIImageView *tileBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        tileBackground.image = [UIImage imageNamed:@"Wooden Tile"];
        [self addSubview:tileBackground];
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
