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
        self.value = value;
        self.image = image;
    }
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%d", self.value];
}

#pragma mark - Coding/Decoding

-(NSArray *)propertyNames
{
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt:self.value forKey:@"value"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _value = [aDecoder decodeIntForKey:@"value"];
    }
    
    return self;
}


@end
