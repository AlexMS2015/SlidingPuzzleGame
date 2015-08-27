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
//@property (nonatomic, readwrite) GridSize gridSize;
//@property (nonatomic, readwrite) Orientation orientation;

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

-(instancetype)initWithSize:(GridSize)size andOrientation:(Orientation)orientation andObjects:(NSArray *)objects{
    if (self = [super initWithGridSize:size andOrientation:orientation]) {
        _objectsPrivate = [objects mutableCopy];
    }
    
    return self;
}

-(void)setPosition:(Position)position toObject:(id)object
{
    int indexOfPosition = [self indexOfPosition:position];
    self.objectsPrivate[indexOfPosition] = object;
}

-(id)objectAtPosition:(Position)position
{
    int indexOfPosition = [self indexOfPosition:position];
    return self.objectsPrivate[indexOfPosition];
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

@end
