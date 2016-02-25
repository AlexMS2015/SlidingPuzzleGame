//
//  UIImage+Crop.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

-(NSArray *)divideImageIntoGridWithRows:(NSInteger)rows andColumns:(NSInteger)cols
{
    NSMutableArray *images = [NSMutableArray array];
    CGSize cropSize = CGSizeMake(self.size.width / cols,
                                  self.size.height / rows);
    
    for (NSInteger row = 0; row < rows; row++) {
        for (NSInteger col = 0; col < cols; col++) {
            
            CGRect frame = CGRectMake(col * cropSize.width, row * cropSize.height,
                                      cropSize.width, cropSize.height);
            CGImageRef currCGImage = CGImageCreateWithImageInRect(self.CGImage, frame);
            UIImage *image = [UIImage imageWithCGImage:currCGImage];
            CGImageRelease(currCGImage);
            
            [images addObject:image];
        }
    }
    
    return [NSArray arrayWithArray:images];
}

@end
