//
//  NSValue+GetPosition.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "NSValue+GetPosition.h"

@implementation NSValue (GetPosition)

+(Position)getPositionFromValue:(NSValue *)value
{
    Position pos;
    if ([value isKindOfClass:[NSValue class]]) {
        [value getValue:&pos];
    }
    
    return pos;
}

@end
