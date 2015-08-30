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

@property (nonatomic) int tileValue;
@property (strong, nonatomic) UIImage *tileImage;

-(instancetype)initWithValue:(int)value andImage:(UIImage *)image;

@end
