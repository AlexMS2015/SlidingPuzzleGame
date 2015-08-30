//
//  UIImage+Crop.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "UIImage+Crop.h"
#import "Grid.h"

@implementation UIImage (Crop)

-(NSArray *)divideSquareImageIntoGrid:(Grid *)grid
{
    GridSize gridSize = grid.size;
    Orientation orientation = grid.orientation;
    NSMutableArray *images = [NSMutableArray array];
    CGSize imageSize = CGSizeMake(self.size.width / gridSize.columns,
                                  self.size.height / gridSize.rows);
    
    for (int i = 0; i < (orientation == VERTICAL ? gridSize.rows : gridSize.columns); i++) {
        for (int j = 0; j < (orientation == VERTICAL ? gridSize.columns : gridSize.rows); j++) {
            
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
            
            [images addObject:image];
        }
    }
    
    return [NSArray arrayWithArray:images];
}

@end
