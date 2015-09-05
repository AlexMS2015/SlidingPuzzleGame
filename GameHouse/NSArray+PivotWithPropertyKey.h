//
//  NSArray+PivotWIthObjectKey.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 2/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PivotWithPropertyKey)

/*
 
 The method converts the array of objects into a PIVOT table, using a particular property on each of 
 the objects as the 'key' to PIVOT the data.
 
 e.g.
 
 objects = [1, 2, 3, 4, 5, 6, 7, 8, 9]
 pivotedObjects = @{ obj1 : [1, 2, 3], obj2 : [4, 5, 6], obj3 : [7, 8, 9]}
 
 obj1, obj2, obj3 are values for a particular property on each of the Class of the objects contained
 in the 'objects' array.

 */

-(NSDictionary *)pivotWithPropertyKey:(id)key;

@end
