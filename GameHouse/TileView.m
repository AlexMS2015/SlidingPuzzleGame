//
//  TileView.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "TileView.h"

@implementation TileView

#define FONT_SIZE self.bounds.size.width / 6.0
#define LABEL_X_AND_Y self.bounds.size.width / 15.0
#define LABEL_W_AND_H self.bounds.size.width / 5.0
-(void)setTileValue:(int)tileValue
{
    _tileValue = tileValue;
    
    if (tileValue != 0) {
        CGRect labelFrame = CGRectMake(LABEL_X_AND_Y, LABEL_X_AND_Y, LABEL_W_AND_H, LABEL_W_AND_H);
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:labelFrame];
        valueLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.text = [NSString stringWithFormat:@"%d", tileValue];
        valueLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [self addSubview:valueLabel];
    }
}

#define CORNER_RADIUS 8.0
-(void)setTileImage:(UIImage *)tileImage
{
    UIImageView *tileForeground = [[UIImageView alloc] initWithFrame:self.bounds];
    tileForeground.image = tileImage;
    tileForeground.layer.cornerRadius = CORNER_RADIUS;
    tileForeground.layer.masksToBounds = YES;
    [self addSubview:tileForeground];
}

#pragma mark - Initialisers

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    return [self initWithFrame:frame andImage:image andValue:0];
}

-(instancetype)initWithFrame:(CGRect)frame
            andImage:(UIImage *)image
            andValue:(int)value
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        UIImageView *tileBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        tileBackground.image = [UIImage imageNamed:@"Wooden Tile"];
        [self addSubview:tileBackground];
        
        self.tileImage = image;
        self.tileValue = value;
        
        [self setNeedsDisplay];
    }
    
    return self;
}

@end
