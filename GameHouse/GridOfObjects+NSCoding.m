//
//  GridOfObjects+NSCoding.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 25/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "GridOfObjects+NSCoding.h"

@implementation GridOfObjects (NSCoding)

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.objects forKey:@"objects"];
    [aCoder encodeInteger:self.numRows forKey:@"numRows"];
    [aCoder encodeInteger:self.numCols forKey:@"numCols"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.objects = [aDecoder decodeObjectForKey:@"objects"];
        self.numRows = [aDecoder decodeIntegerForKey:@"numRows"];
        self.numCols = [aDecoder decodeIntegerForKey:@"numCols"];
    }
    
    return self;
}

@end
