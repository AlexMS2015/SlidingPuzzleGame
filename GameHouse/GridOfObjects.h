//
//  GridOfObjects.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 26/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridInterface.h"

@interface GridOfObjects : NSObject

@property (nonatomic, readonly) GridSize gridSize;
@property (nonatomic, readonly) Orientation orientation;
@property (nonatomic, strong) NSArray *objects;

-(instancetype)initWithSize:(GridSize)gridSize
             andOrientation:(Orientation)orientation
                 andObjects:(NSArray *)objects;

-(NSArray *)gridObjects;
-(void)setGridObjects:(NSArray *)objects;

-(id)objectAtPosition:(Position)position;
-(Position)positionOfObject:(id)object;

-(void)setPosition:(Position)position toObject:(id)object;
-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2;

@end
