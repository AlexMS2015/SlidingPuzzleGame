//
//  PuzzleBoard.m
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PuzzleBoard.h"

@interface PuzzleBoard () <NSCoding>

@property (strong, nonatomic) NSMutableArray *tiles;
@property (nonatomic, readwrite) int numberOfTiles;

@end

@implementation PuzzleBoard

#pragma mark - Properties

-(NSMutableArray *)tiles
{
    if (!_tiles)
        _tiles = [NSMutableArray array];
    
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
    if (self = [super init]) {
        _tiles = [aDecoder decodeObjectForKey:@"tiles"];
        _numberOfTiles = [aDecoder decodeIntForKey:@"numberOfTiles"];
    }
    
    return self;
}

#pragma mark - Initialiser

-(instancetype)initWithNumTiles:(int)numTiles
{
    if (self = [super init])
        _numberOfTiles = numTiles;
    
    return self;
}

#pragma mark - Other

-(void)setTileAtPosition:(Position)position withValue:(int)value
{
    [self.tiles insertObject:[NSNumber numberWithInt:value]
                     atIndex:[self indexOfTileAtPosition:position]];
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
    NSNumber *tile = self.tiles[[self indexOfTileAtPosition:position]];
    return [tile intValue];
}

-(Position)positionOfTileWithValue:(int)value
{
    __block Position positionOfTile;
    [self.tiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *tile = (NSNumber *)obj;
        if ([tile intValue] == value)
            positionOfTile = [self positionOfTileAtIndex:(int)idx];
    }];
    
    return positionOfTile;
}

-(void)swapTileAtPosition:(Position)position1 withTileAtPosition:(Position)position2
{
    [self.tiles exchangeObjectAtIndex:[self indexOfTileAtPosition:position1]
                    withObjectAtIndex:[self indexOfTileAtPosition:position2]];
}

-(NSString *)boardSizeStringFromNumTiles
{
    int numRowsAndCols = sqrt(self.numberOfTiles);
    return [NSString stringWithFormat:@"%dx%d", numRowsAndCols, numRowsAndCols];
}

+(BOOL)position:(Position)firstPos isEqualToPosition:(Position)secondPos
{
    return (firstPos.row == secondPos.row && firstPos.column == secondPos.column) ? YES : NO;
}

/*-(Position)positionOfBlankTile
 {
 return [self positionOfTileWithValue:0];
}*/

/*-(void)swapBlankTileWithTileAtPosition:(Position)position
 {
 [self swapTileAtPosition:position withTileAtPosition:[self positionOfBlankTile]];
}*/

/*-(Position)positionOfRandomTileAdjacentToBlankTile
{
    Position blankTilePosition = [self positionOfBlankTile];
    Position adjacentTilePos = blankTilePosition;
    
    int maxCol = sqrt(self.numberOfTiles) - 1;
    int maxRow = sqrt(self.numberOfTiles) - 1;
    
    while ([PuzzleBoard position:adjacentTilePos isEqualToPosition:blankTilePosition]) {
        int randomTile = arc4random() % 4;
        
        if (randomTile == 0 && blankTilePosition.column > 0) {
            adjacentTilePos.column--;
        } else if (randomTile == 1 && blankTilePosition.column < maxCol) {
            adjacentTilePos.column++;
        } else if (randomTile == 2 && blankTilePosition.row > 0) {
            adjacentTilePos.row--;
        } else if (randomTile == 3 && blankTilePosition.row < maxRow) {
            adjacentTilePos.row++;
        }
    }
    
    return adjacentTilePos;
}*/

/*-(BOOL)blankTileIsAdjacentToTileAtPosition:(Position)position
{
    if (abs(self.positionOfBlankTile.row - position.row) <= 1 &&
        abs(self.positionOfBlankTile.column - position.column) <= 1 &&
        (self.positionOfBlankTile.row == position.row
         || self.positionOfBlankTile.column == position.column)) {
            return YES;
        } else {
            return NO;
        }
}*/

@end
