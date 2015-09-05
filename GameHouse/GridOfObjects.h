//
//  GridOfObjects.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 26/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Grid.h"

@interface GridOfObjects : Grid

// THERE NEEDS TO BE A CHECK TO STOP INSERTING AT POSITONS OUTSIDE THE GRID (too large)

@property (nonatomic, strong) NSArray *objects;

-(instancetype)initWithSize:(GridSize)size
             andOrientation:(Orientation)orientation
                 andObjects:(NSArray *)objects;

-(id)objectAtPosition:(Position)position;
-(Position)positionOfObject:(id)object;

-(void)setPosition:(Position)position toObject:(id)object;
-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2;

@end
