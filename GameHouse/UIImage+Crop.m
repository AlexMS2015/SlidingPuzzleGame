//
//  UIImage+Crop.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

-(UIImage *)imageInRect:(CGRect)frame
{

    // the image is too large so resize an appropriate section for the next tile
    /*CGRect tileFrame = [self.puzzleBoard frameOfCellAtPosition:currentPosition];
    CGRect pictureFrame = CGRectMake(tileFrame.origin.x  * imageWidthScale,
                                     tileFrame.origin.y  * imageHeightScale,
                                     tileFrame.size.width * imageWidthScale,
                                     tileFrame.size.height * imageHeightScale);
    CGImageRef tileCGImage = CGImageCreateWithImageInRect(boardImage.CGImage, pictureFrame);
    UIImage *tileImage = [UIImage imageWithCGImage:tileCGImage];

    CGImageRelease(tileCGImage);*/
    return nil;
}

@end
