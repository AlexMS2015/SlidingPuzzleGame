//
//  Grid.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 27/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionStruct.h"

typedef struct {
    int rows, columns;
}GridSize;

typedef enum {
    VERTICAL, HORIZONTAL
}Orientation;

/*
 Horizontal grid:
 
 1   4   7
 2   5   8
 3   6   9
 
 Vertical grid:
 
 1   2   3
 4   5   6
 7   8   9
 */

@interface Grid : NSObject

@property (nonatomic, readonly) GridSize size;
@property (nonatomic, readonly) Orientation orientation;

-(instancetype)initWithGridSize:(GridSize)size andOrientation:(Orientation)orientation;

-(Position)positionOfIndex:(int)index;
-(int)indexOfPosition:(Position)position;
-(NSString *)gridSizeString;
-(Position)randomPositionAdjacentToPosition:(Position)position;

@end
