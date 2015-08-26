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
@property (nonatomic, readwrite) GridSize gridSize;
@property (nonatomic, readwrite) Orientation orientation;

@end

@implementation GridOfObjects

#pragma mark - Properties

-(NSArray *)objects
{
    return [NSArray arrayWithArray:self.objectsPrivate];
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

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.objectsPrivate forKey:@"objects"];
    
    // NEED TO ENCODE A STRUCT
    //[aCoder encodeInt:self.numberOfTiles forKey:@"numberOfTiles"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _objectsPrivate = [aDecoder decodeObjectForKey:@"objects"];
        // NEED TO DECODE A STRUCT
        //_numberOfTiles = [aDecoder decodeIntForKey:@"numberOfTiles"];
    }
    
    return self;
}

-(instancetype)initWithSize:(GridSize)gridSize andOrientation:(Orientation)orientation andObjects:(NSArray *)objects{
    if (self = [super init]) {
        _gridSize = gridSize;
        _objectsPrivate = [objects mutableCopy];
        _orientation = orientation;
    }
    
    return self;
}

-(void)setPosition:(Position)position toObject:(id)object
{
    int indexOfPosition = IndexOfPositionInGrid(position, self.gridSize, self.orientation);
    self.objectsPrivate[indexOfPosition] = object;
}

-(id)objectAtPosition:(Position)position
{
    int indexOfPosition = IndexOfPositionInGrid(position, self.gridSize, self.orientation);
    return self.objectsPrivate[indexOfPosition];
}

-(Position)positionOfObject:(id)object
{
    int indexOfOject = (int)[self.objectsPrivate indexOfObject:object];
    return PositionOfIndexInGrid(indexOfOject, self.gridSize, self.orientation);
}

-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2
{
    int indexOfPos1 = IndexOfPositionInGrid(position1, self.gridSize, self.orientation);
    int indexOfPos2 = IndexOfPositionInGrid(position2, self.gridSize, self.orientation);
    [self.objectsPrivate exchangeObjectAtIndex:indexOfPos1 withObjectAtIndex:indexOfPos2];
}

@end
