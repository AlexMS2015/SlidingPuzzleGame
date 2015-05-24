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
@end

@implementation ASSlidingTileView

-(void)setTileValue:(int)tileValue
{
    _tileValue = tileValue;
    
    if (tileValue != 0) {
        self.tileValueLabel.text = [NSString stringWithFormat:@"%d", tileValue];
    } else {
        self.tileValueLabel.text = @"";
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGRect tileAndLabelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        UIImageView *tileBackground = [[UIImageView alloc] initWithFrame:tileAndLabelFrame];
        tileBackground.image = [UIImage imageNamed:@"GameTile"];
        tileBackground.alpha = 0.5;
        [self addSubview:tileBackground];
        
        self.tileValueLabel = [[UILabel alloc] initWithFrame:tileAndLabelFrame];
        self.tileValueLabel.textAlignment = NSTextAlignmentCenter;
        self.tileValueLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.tileValueLabel];
    }
    
    return self;
}

@end
