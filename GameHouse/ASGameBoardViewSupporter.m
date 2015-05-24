//
//  ASGameBoardViewSupporter.m
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGameBoardViewSupporter.h"

@interface ASGameBoardViewSupporter ()

@property (nonatomic) double cellWidth;
@property (nonatomic) double cellHeight;

@end

@implementation ASGameBoardViewSupporter

-(instancetype)initWithSize:(CGSize)size withRows:(int)rows andColumns:(int)columns
{
    self = [super init];
    
    if (self) {
        self.cellWidth = size.width / columns;
        self.cellHeight = size.height / rows;
    }
    
    return self;
}

-(CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    CGFloat originX = column * self.cellWidth;
    CGFloat originY = row * self.cellHeight;
    
    return CGRectMake(originX, originY, self.cellWidth, self.cellHeight);
}

@end
