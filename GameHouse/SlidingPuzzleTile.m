//
//  SlidingPuzzleTile.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 30/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SlidingPuzzleTile.h"

@implementation SlidingPuzzleTile

-(instancetype)initWithValue:(int)value andImage:(UIImage *)image
{
    if (self = [super init]) {
        self.tileValue = value;
        self.tileImage = image;
    }
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%d", self.tileValue];
}

#pragma mark - Coding/Decoding

-(NSArray *)propertyNames
{
    return @[@"tileImage"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt:self.tileValue forKey:@"tileValue"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _tileValue = [aDecoder decodeIntForKey:@"tileValue"];
    }
    
    return self;
}


@end
