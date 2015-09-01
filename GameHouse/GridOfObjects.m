//
//  GridOfObjects.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 26/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GridOfObjects.h"

@interface GridOfObjects ()

@property (strong, nonatomic) NSMutableArray *objectsPrivate;

@end

@implementation GridOfObjects

-(instancetype)initWithSize:(GridSize)size andOrientation:(Orientation)orientation andObjects:(NSArray *)objects{
    if (self = [super initWithGridSize:size andOrientation:orientation]) {
        _objectsPrivate = [objects mutableCopy];
    }
    
    return self;
}

-(void)setPosition:(Position)position toObject:(id)object
{
    // THERE NEEDS TO BE A CHECK TO STOP INSERTING AT POSITONS OUTSIDE THE GRID (too large)
    int indexOfPosition = [self indexOfPosition:position];
    self.objectsPrivate[indexOfPosition] = object;
}

-(id)objectAtPosition:(Position)position
{
    int indexOfPosition = [self indexOfPosition:position];
    return indexOfPosition < [self.objectsPrivate count] ?
                        self.objectsPrivate[indexOfPosition] : nil;
}

-(Position)positionOfObject:(id)object
{
    int indexOfOject = (int)[self.objectsPrivate indexOfObject:object];
    return [self positionOfIndex:indexOfOject];
}

-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2
{
    [self.objectsPrivate exchangeObjectAtIndex:[self indexOfPosition:position1]
                             withObjectAtIndex:[self indexOfPosition:position2]];
}

#pragma mark - Properties

-(NSArray *)objects
{
    return [self.objectsPrivate copy];
}

-(void)setObjects:(NSArray *)objects
{
    self.objectsPrivate = [objects mutableCopy];
}

-(NSMutableArray *)objectsPrivate
{
    if (!_objectsPrivate)
        _objectsPrivate = [NSMutableArray array];
    
    return _objectsPrivate;
}

#pragma mark - Encoding/Decoding

-(NSArray *)propertyNames
{
    NSMutableArray *propNames = [[super propertyNames] mutableCopy];
    [propNames addObject:@"objects"];
    return [propNames copy];
}

@end
