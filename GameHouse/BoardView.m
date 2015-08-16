//
//  BoardView.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "BoardView.h"
#import "TileView.h"

@interface BoardView ()

@property (nonatomic) double cellWidth;
@property (nonatomic) double cellHeight;

@end

@implementation BoardView

-(void)setRows:(int)rows andColumns:(int)columns andImage:(UIImage *)image;
{
    [self clearTiles];
    
    CGSize size = self.bounds.size;
    
    self.cellWidth = size.width / columns;
    self.cellHeight = size.height / rows;
    
    // how large is the image relative to the size of the board (this view)?
    float imageWidthScale = image.size.width / size.width;
    float imageHeightScale = image.size.height / size.height;
    
    Position currentPosition;
    int tileValue = 1;
    for (currentPosition.row = 0; currentPosition.row < rows; currentPosition.row++) {
        for (currentPosition.column = 0; currentPosition.column < columns; currentPosition.column++) {
            
            // the image is too large so resize an appropriate section for the next tile
            CGRect tileFrame = [self frameOfCellAtPosition:currentPosition];
            CGRect pictureFrame = CGRectMake(tileFrame.origin.x  * imageWidthScale,
                                             tileFrame.origin.y  * imageHeightScale,
                                             tileFrame.size.width * imageWidthScale,
                                             tileFrame.size.height * imageHeightScale);
            CGImageRef tileCGImage = CGImageCreateWithImageInRect(image.CGImage, pictureFrame);
            UIImage *tileImage = [UIImage imageWithCGImage:tileCGImage];
            
            CGImageRelease(tileCGImage);
            
            // set up the actual board tile with the image and position
            if (tileValue < rows * columns) {
                TileView *tile = [[TileView alloc] initWithFrame:tileFrame
                                                        andImage:tileImage
                                                        andValue:tileValue
                                              andPositionInBoard:currentPosition];
                
                UITapGestureRecognizer *tileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTappedForDelegate:)];
                [tile addGestureRecognizer:tileTap];
                
                [self addSubview:tile];
            }
            tileValue++;
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
    [self.delegate tileTapped:tap];
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
        int currentTileValue = tileToUpdate.tileValue;
     
        // find the tile's new position in the board
        __block Position positionToMoveTileTo;
        [newPositions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSNumber *tileValue = (NSNumber *)key;
            if ([tileValue intValue] == currentTileValue) {
                NSArray *tilePosition = (NSArray *)obj;
                NSNumber *rowObject = [tilePosition firstObject];
                NSNumber *colObject = [tilePosition lastObject];
                int row = [rowObject intValue];
                int col = [colObject intValue];
                positionToMoveTileTo.row = row;
                positionToMoveTileTo.column = col;
            }
        }];
        
        // get the frame of the new position in the board
        CGRect frameToMoveRectTo = [self frameOfCellAtPosition:positionToMoveTileTo];
            
        // update and move the tile
        tileToUpdate.positionInABoard = positionToMoveTileTo;
        if (animated) {
            [tileToUpdate animateToFrame:frameToMoveRectTo];
        } else {
            tileToUpdate.frame = frameToMoveRectTo;
        }
    }
}

@end
