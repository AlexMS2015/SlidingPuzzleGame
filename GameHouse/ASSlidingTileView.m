//
//  ASSlidingTileView.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingTileView.h"

@interface ASSlidingTileView ()
@property (strong, nonatomic) UILabel *tileValueLabel;
@property (strong, nonatomic) UIImageView *tileBackground;
@end

@implementation ASSlidingTileView

-(void)setTileValue:(int)tileValue
{
    _tileValue = tileValue;
    self.tileValueLabel.text = [NSString stringWithFormat:@"%d", tileValue];
/*
    if (tileValue != 0) {
        self.tileValueLabel.text = [NSString stringWithFormat:@"%d", tileValue];
        self.tileBackground.alpha = NUMBERED_TILE_ALPHA;
    } else {
        self.tileValueLabel.text = @"";
        self.tileBackground = nil;
    }*/
}

#define FONT_SIZE frame.size.width/2.5
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGRect tileAndLabelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        self.tileBackground = [[UIImageView alloc] initWithFrame:tileAndLabelFrame];
        self.tileBackground.image = [UIImage imageNamed:@"Wooden Tile"];
        [self addSubview:self.tileBackground];
        
        self.tileValueLabel = [[UILabel alloc] initWithFrame:tileAndLabelFrame];
        self.tileValueLabel.textAlignment = NSTextAlignmentCenter;
        self.tileValueLabel.textColor = [UIColor whiteColor];
        self.tileValueLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [self addSubview:self.tileValueLabel];
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
