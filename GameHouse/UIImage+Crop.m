//
//  UIImage+Crop.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

-(NSArray *)divideImageIntoSquares:(int)numSquares
{
    NSMutableArray *squareImages = [NSMutableArray array];
    
    CGSize sizeOfSquares = CGSizeMake(self.size.width / sqrt(numSquares),
                                      self.size.height / sqrt(numSquares));
    
    for (int i = 0; i < sqrt(numSquares); i++) {
        for (int j = 0; j < sqrt(numSquares); j++) {
            CGRect squareFrame = CGRectMake(j * sizeOfSquares.width,
                                            i * sizeOfSquares.height,
                                            sizeOfSquares.width,
                                            sizeOfSquares.height);
            
            CGImageRef squareCGImage = CGImageCreateWithImageInRect(self.CGImage, squareFrame);
            UIImage *squareImage = [UIImage imageWithCGImage:squareCGImage];
            CGImageRelease(squareCGImage);
            
            [squareImages addObject:squareImage];
        }
    }
    
    return [NSArray arrayWithArray:squareImages];
}

@end
