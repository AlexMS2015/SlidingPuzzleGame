//
//  NSValue+GetPosition.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums+Structs.h"

@interface NSValue (GetPosition)

+(Position)getPositionFromValue:(NSValue *)value;

@end
