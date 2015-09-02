//
//  NSArray+PivotWIthObjectKey.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 2/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "NSArray+PivotWithPropertyKey.h"

@implementation NSArray (PivotWithPropertyKey)

-(NSDictionary *)pivotWithPropertyKey:(id)key
{
    NSMutableDictionary *pivotedObjects = [NSMutableDictionary dictionary];
    
    for (id obj in self) {
        id dictKey = [obj valueForKey:key];
        
        if (!pivotedObjects[dictKey])
            pivotedObjects[dictKey] = [NSMutableArray array];
        
        [pivotedObjects[dictKey] addObject:obj];
    }

    return [NSDictionary dictionaryWithDictionary:pivotedObjects];
}

@end
