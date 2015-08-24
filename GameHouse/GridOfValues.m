//
//  PuzzleBoardTest.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GridOfValues.h"

@interface GridOfValues () <NSCoding>

@property (strong, nonatomic) NSMutableArray *values;
@property (nonatomic, readwrite) GridSize gridSize;

@end

@implementation GridOfValues

#pragma mark - Properties

-(NSMutableArray *)values
{
    if (!_values)
        _values = [NSMutableArray array];
    
    return _values;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.values forKey:@"tiles"];
    
    // NEED TO ENCODE A STRUCT
    //[aCoder encodeInt:self.numberOfTiles forKey:@"numberOfTiles"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _values = [aDecoder decodeObjectForKey:@"tiles"];
        // NEED TO DECODE A STRUCT
        //_numberOfTiles = [aDecoder decodeIntForKey:@"numberOfTiles"];
    }
    
    return self;
}

#pragma mark - Initialiser

-(instancetype)initWithSize:(GridSize)gridSize
{
    if (self = [super init])
        _gridSize = gridSize;
    
    return self;
}

#pragma mark - Other

-(void)setValueAtPosition:(Position)position toValue:(int)value
{
    [self.values insertObject:[NSNumber numberWithInt:value]
                     atIndex:[GridPosition indexOfPosition:position inGridOfSize:self.gridSize]];
}

-(int)valueAtPosition:(Position)position
{
    NSNumber *valueObj = self.values[[GridPosition indexOfPosition:position inGridOfSize:self.gridSize]];
    return [valueObj intValue];
}

-(Position)positionWithValue:(int)value
{
    int index = [self.values indexOfObject:[NSNumber numberWithInt:value]];
    return [GridPosition positionForIndex:index inGridOfSize:self.gridSize];
}

-(void)swapValueAtPosition:(Position)position1 withValueAtPosition:(Position)position2
{
    [self.values exchangeObjectAtIndex:[GridPosition indexOfPosition:position1
                                                        inGridOfSize:self.gridSize]
                     withObjectAtIndex:[GridPosition indexOfPosition:position2
                                                        inGridOfSize:self.gridSize]];
}

-(NSString *)boardSizeStringFromNumTiles
{
    return [NSString stringWithFormat:@"%dx%d", self.gridSize.rows, self.gridSize.columns];
}

@end
