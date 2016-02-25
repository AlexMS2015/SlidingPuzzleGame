//
//  SlidingPuzzleTile.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 30/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlidingPuzzleTile : NSObject

@property (nonatomic) int value;
@property (strong, nonatomic) UIImage *image; // not saved during archiving... must be re-loaded on an unarchived tile

-(instancetype)initWithValue:(int)value andImage:(UIImage *)image;

@end
