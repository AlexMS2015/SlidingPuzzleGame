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

@end

@implementation BoardView

-(void)setRows:(int)rows andColumns:(int)columns andImage:(UIImage *)image;
{
    [self clearTiles];
    
    self.cellHeight = self.bounds.size.height / rows;
    self.cellWidth = self.bounds.size.width / columns;
    
    NSArray *tileImages = [image divideImageIntoSquares:rows * columns];
    for (UIImage *tileImage in tileImages) {
        int tileValue = [tileImages indexOfObjectIdenticalTo:tileImage] + 1;
        
        if (tileValue < rows * columns) {
            Position currentPosition;
            currentPosition.row = (tileValue - 1) / rows;
            currentPosition.column = (tileValue - 1) % rows;
            
            CGRect tileFrame = [self frameOfCellAtPosition:currentPosition];
            
            TileView *tile = [[TileView alloc] initWithFrame:tileFrame
                                                    andImage:tileImage
                                                    andValue:tileValue++];
            
            UITapGestureRecognizer *tileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTappedForDelegate:)];
            [tile addGestureRecognizer:tileTap];
            
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

-(CGRect)frameOfCellAtPosition:(Position)position
{
    CGFloat originX = position.column * self.cellWidth;
    CGFloat originY = position.row * self.cellHeight;
    
    return CGRectMake(originX, originY, self.cellWidth, self.cellHeight);
}

-(void)moveTilesToPositions:(NSMutableDictionary *)newPositions animated:(BOOL)animated
{
    // figure out if any of the tiles have moved based on the newPositions
    for (TileView *tileToUpdate in self.subviews) {
        
        // find the tile's new position in the board
        __block Position positionToMoveTileTo;
        [newPositions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSNumber *tileValue = (NSNumber *)key;
            if ([tileValue intValue] == tileToUpdate.tileValue) {
                NSArray *tilePosition = (NSArray *)obj;
                positionToMoveTileTo.row = [((NSNumber *)[tilePosition firstObject]) intValue];
                positionToMoveTileTo.column = [((NSNumber *)[tilePosition lastObject]) intValue];
            }
        }];
        
        // get the frame of the new position in the board
        CGRect frameToMoveRectTo = [self frameOfCellAtPosition:positionToMoveTileTo];
        
        // ONLY DO THE ANIMATION IF THE FRAMES ARE DIFFERENT
        
        if (animated) {
            [tileToUpdate animateToFrame:frameToMoveRectTo];
        } else {
            tileToUpdate.frame = frameToMoveRectTo;
        }
    }
}

@end
