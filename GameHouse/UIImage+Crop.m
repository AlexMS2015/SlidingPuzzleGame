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
    NSMutableArray *images = [NSMutableArray array];
    CGSize cropSize = CGSizeMake(self.size.width / grid.size.columns,
                                  self.size.height / grid.size.rows);
    
    for (int i = 0; i < grid.size.rows * grid.size.columns; i++) {
        Position position = [grid positionOfIndex:i];
    
        CGRect frame = CGRectMake(position.column * cropSize.width, position.row * cropSize.height,
                               cropSize.width, cropSize.height);
        CGImageRef currCGImage = CGImageCreateWithImageInRect(self.CGImage, frame);
        UIImage *image = [UIImage imageWithCGImage:currCGImage];
        CGImageRelease(currCGImage);
        
        [images addObject:image];

    }
    
    return [NSArray arrayWithArray:images];
}

@end
