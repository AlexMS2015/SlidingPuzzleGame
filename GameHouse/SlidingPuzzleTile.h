//
//  SlidingPuzzleTile.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 30/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodableObject.h"

@interface SlidingPuzzleTile : CodableObject

// RENAME THESE AS VALUE AND IMAGE
@property (nonatomic) int value;
@property (strong, nonatomic) UIImage *image;

-(instancetype)initWithValue:(int)value andImage:(UIImage *)image;

@end
