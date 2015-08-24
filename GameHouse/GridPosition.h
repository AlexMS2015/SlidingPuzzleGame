//
//  GridPosition.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums+Structs.h"

/*typedef struct {
    int row;
    int column;
}Position;*/

@interface GridPosition : NSObject

@property (nonatomic) Position position;

+(Position)getPositionFromValue:(NSValue *)value;
+(Position)positionForIndex:(int)index inGridOfSize:(GridSize)gridSize;
+(int)indexOfPosition:(Position)position inGridOfSize:(GridSize)gridSize;
+(BOOL)position:(Position)pos1 isAdjacentToPosition:(Position)pos2;
+(BOOL)position:(Position)pos1 isEqualToPosition:(Position)pos2;

@end
