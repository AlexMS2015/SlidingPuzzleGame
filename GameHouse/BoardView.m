//
//  BoardView.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "BoardView.h"
#import "TileView.h"
#import "UIImage+Crop.h"

@interface BoardView ()

@property (nonatomic) double cellWidth;
@property (nonatomic) double cellHeight;
@property (nonatomic) int numRows;
@property (nonatomic) int numCols;

@end

@implementation BoardView

-(double)cellHeight
{
    return self.bounds.size.height / self.numRows;
}

-(double)cellWidth
{
    return self.bounds.size.width / self.numCols;
}

-(void)setRows:(int)rows andColumns:(int)columns andImage:(UIImage *)image;
{
    [self clearTiles];
    
    self.numRows = rows;
    self.numCols = columns;
    
    NSArray *tileImages = [image divideImageIntoSquares:rows * columns];
    
    for (UIImage *tileImage in tileImages) {
        
        int tileValue = (int)[tileImages indexOfObjectIdenticalTo:tileImage] + 1;
        
        if (tileValue < rows * columns) {
            CGRect tileFrame = [self frameOfTileWithValue:tileValue-1];
            
            TileView *tile = [[TileView alloc] initWithFrame:tileFrame
                                                    andImage:tileImage
                                                    andValue:tileValue];
            
            [tile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTappedForDelegate:)]];
            
            [self addSubview:tile];
        }
    }
}

-(void)clearTiles
{
    if ([self.subviews count]) {
        [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    }
}

-(void)tileTappedForDelegate:(UITapGestureRecognizer *)tap
{
    TileView *selectedTile = (TileView *)tap.view;
    [self.delegate tileTappedWithValue:selectedTile.tileValue];
}

-(CGRect)frameOfTileWithValue:(int)tileValue
{
    Position currentPosition;
    currentPosition.row = tileValue / self.numRows;
    currentPosition.column = tileValue % self.numCols;
    return [self frameOfCellAtPosition:currentPosition];
}

-(CGRect)frameOfCellAtPosition:(Position)position
{
    CGFloat originX = position.column * self.cellWidth;
    CGFloat originY = position.row * self.cellHeight;
    
    return CGRectMake(originX, originY, self.cellWidth, self.cellHeight);
}

-(void)moveTileWithValue:(int)tileValue toPosition:(Position)tilePos animated:(BOOL)animated
{
    for (TileView *tile in self.subviews) {
        if (tile.tileValue == tileValue) {
            if (animated) {
                [tile animateToFrame:[self frameOfCellAtPosition:tilePos]];
            } else {
                tile.frame = [self frameOfCellAtPosition:tilePos];
            }
        }
    }
}

@end
