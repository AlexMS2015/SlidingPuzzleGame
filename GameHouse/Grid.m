//
//  Grid.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Grid.h"

@interface Grid ()

@property (nonatomic) double cellWidth;
@property (nonatomic) double cellHeight;

@end

@implementation Grid

-(instancetype)initWithSize:(CGSize)size withRows:(int)rows andColumns:(int)columns
{
    self = [super init];
    
    if (self) {
        self.cellWidth = size.width / columns;
        self.cellHeight = size.height / rows;
    }
    
    return self;
}

-(CGRect)frameOfCellAtPosition:(Position)position
{
    CGFloat originX = position.column * self.cellWidth;
    CGFloat originY = position.row * self.cellHeight;
    
    return CGRectMake(originX, originY, self.cellWidth, self.cellHeight);
}

@end
