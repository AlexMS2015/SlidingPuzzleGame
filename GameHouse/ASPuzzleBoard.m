//
//  ASPuzzleBoard.m
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASPuzzleBoard.h"

@interface ASPuzzleBoard () <NSCoding>

@property (strong, nonatomic) NSMutableArray *tiles;
@property (nonatomic, readwrite) int numberOfTiles;

@end

@implementation ASPuzzleBoard

#pragma mark - Properties

-(NSMutableArray *)tiles
{
    if (!_tiles) {
        _tiles = [NSMutableArray array];
    }
    
    return _tiles;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tiles forKey:@"tiles"];
    [aCoder encodeInt:self.numberOfTiles forKey:@"numberOfTiles"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _tiles = [aDecoder decodeObjectForKey:@"tiles"];
        _numberOfTiles = [aDecoder decodeIntForKey:@"numberOfTiles"];
    }
    
    return self;
}

#pragma mark - Initialiser

-(instancetype)initWithNumTiles:(int)numTiles
{
    self = [super init];
    
    if (self) {
        _numberOfTiles = numTiles;
    }
    
    return self;
}

#pragma mark - Other

-(void)setTileAtPosition:(Position)position withValue:(int)value
{
    int index = [self indexOfTileAtPosition:position];
    NSNumber *tile = [NSNumber numberWithInt:value];
    [self.tiles insertObject:tile atIndex:index];
}

-(Position)positionOfTileAtIndex:(int)index
{
    Position positionOfTile;
    int numRowsAndColsInGame = sqrt(self.numberOfTiles);
    
    positionOfTile.row = index / numRowsAndColsInGame;
    positionOfTile.column = index % numRowsAndColsInGame;
    
    return positionOfTile;
}

-(int)indexOfTileAtPosition:(Position)position
{
    return sqrt(self.numberOfTiles) * position.row + position.column;
}

-(int)valueOfTileAtPosition:(Position)position
{
    int index = [self indexOfTileAtPosition:position];
    NSNumber *tile = self.tiles[index];
    return [tile intValue];
}

-(Position)positionOfTileWithValue:(int)value
{
    __block Position positionOfTile;
    [self.tiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *tile = (NSNumber *)obj;
        if ([tile intValue] == value) {
            positionOfTile = [self positionOfTileAtIndex:(int)idx];
        }
    }];
    
    return positionOfTile;
}

-(Position)positionOfBlankTile
{
    return [self positionOfTileWithValue:0];
}

-(void)swapBlankTileWithTileAtPosition:(Position)position
{
    int indexOfSelectedTile = [self indexOfTileAtPosition:position];
    int indexOfBlankTile = [self indexOfTileAtPosition:[self positionOfBlankTile]];
    NSNumber *selectedTile = self.tiles[indexOfSelectedTile];
    NSNumber *blankTile = self.tiles[indexOfBlankTile];
    
    // swap the tiles
    [self.tiles removeObjectAtIndex:indexOfSelectedTile];
    [self.tiles insertObject:blankTile atIndex:indexOfSelectedTile];
    [self.tiles removeObjectAtIndex:indexOfBlankTile];
    [self.tiles insertObject:selectedTile atIndex:indexOfBlankTile];
}

-(NSString *)boardSizeStringFromNumTiles
{
    int numRowsAndCols = sqrt(self.numberOfTiles);
    return [NSString stringWithFormat:@"%dx%d", numRowsAndCols, numRowsAndCols];
}

@end
