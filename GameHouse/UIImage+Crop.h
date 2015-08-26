//
//  UIImage+Crop.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridInterface.h"

@interface UIImage (Crop)

-(NSArray *)divideSquareImageIntoGridOfSize:(GridSize)gridSize
                             andOrientation:(Orientation)orientation;

@end
