//
//  UIImage+Crop.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

-(NSArray *)divideSquareImageIntoGridOfSize:(GridSize)gridSize andOrientation:(Orientation)orientation
{
    NSLog(@"%@", StringFromGridSize(gridSize));

    NSMutableArray *images = [NSMutableArray array];
    
    CGSize imageSize = CGSizeMake(self.size.width / gridSize.columns,
                                  self.size.height / gridSize.rows);

    int firstLoop;
    int secondLoop;
    if (orientation == VERTICAL) {
        firstLoop = gridSize.rows;
        secondLoop = gridSize.columns;
    } else {
        firstLoop = gridSize.columns;
        secondLoop = gridSize.rows;
    }
    
    for (int i = 0; i < firstLoop; i++) {
        for (int j = 0; j < secondLoop; j++) {
            
            CGRect frame;
            if (orientation == VERTICAL) {
                frame = CGRectMake(j * imageSize.width, i * imageSize.height,
                                          imageSize.width, imageSize.height);
            } else {
                frame = CGRectMake(i * imageSize.width, j * imageSize.height,
                                          imageSize.width, imageSize.height);
            }
            
            CGImageRef currCGImage = CGImageCreateWithImageInRect(self.CGImage, frame);
            UIImage *image = [UIImage imageWithCGImage:currCGImage];
            CGImageRelease(currCGImage);
            NSLog(@"loop");
            [images addObject:image];
        }
    }
    
    return [NSArray arrayWithArray:images];
}

@end
