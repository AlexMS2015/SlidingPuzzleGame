//
//  BoardView.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "BoardView.h"

@interface BoardView ()

@property (nonatomic) double cellWidth;
@property (nonatomic) double cellHeight;

@end

@implementation BoardView

-(instancetype)initWithSize:(CGSize)size
                   withRows:(int)rows
                 andColumns:(int)columns
                   andImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    if (self) {
        self.cellWidth = size.width / columns;
        self.cellHeight = size.height / rows;
    }
    
    return self;
    
    
    
    UIImage *boardImage = [UIImage imageNamed:self.puzzleGame.imageName];
    CGSize boardSize = self.boardContainerView.bounds.size;
    
    // how large is the image relative to the size of the board (this view)?
    float imageWidthScale = image.size.width / size.width;
    float imageHeightScale = image.size.height / size.height;
    
    Position currentPosition;
    int tileValue = 1;
    for (currentPosition.row = 0; currentPosition.row < numRowsAndColumns; currentPosition.row++) {
        for (currentPosition.column = 0; currentPosition.column < numRowsAndColumns; currentPosition.column++) {
            
            // the image is too large so resize an appropriate section for the next tile
            CGRect tileFrame = [self.puzzleBoard frameOfCellAtPosition:currentPosition];
            CGRect pictureFrame = CGRectMake(tileFrame.origin.x  * imageWidthScale,
                                             tileFrame.origin.y  * imageHeightScale,
                                             tileFrame.size.width * imageWidthScale,
                                             tileFrame.size.height * imageHeightScale);
            CGImageRef tileCGImage = CGImageCreateWithImageInRect(boardImage.CGImage, pictureFrame);
            UIImage *tileImage = [UIImage imageWithCGImage:tileCGImage];
            
            CGImageRelease(tileCGImage);
            
            // set up the actual board tile with the image and position
            if (tileValue < self.puzzleGame.board.numberOfTiles) {
                TileView *tile = [[TileView alloc] initWithFrame:tileFrame
                                                        andImage:tileImage
                                                        andValue:tileValue
                                              andPositionInBoard:currentPosition];
                
                UITapGestureRecognizer *tileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];
                [tile addGestureRecognizer:tileTap];
                
                [self.boardContainerView addSubview:tile];
            }
            tileValue++;
        }
    }
}

-(CGRect)frameOfCellAtPosition:(Position)position
{
    CGFloat originX = position.column * self.cellWidth;
    CGFloat originY = position.row * self.cellHeight;
    
    return CGRectMake(originX, originY, self.cellWidth, self.cellHeight);
}

@end
