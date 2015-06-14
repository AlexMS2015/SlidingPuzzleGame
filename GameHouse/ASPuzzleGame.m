//
//  ASPuzzleGame.m
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASPuzzleGame.h"
#import "ASPreviousGameDatabase.h"

@interface ASPuzzleGame () <NSCoding>

@property (strong, nonatomic) NSMutableArray *tiles;
@property (nonatomic) int rowOfBlankTile;
@property (nonatomic) int columnOfBlankTile;
@property (nonatomic, readwrite) BOOL puzzleIsSolved;
@property (nonatomic, readwrite) Difficulty difficulty;
@end

@implementation ASPuzzleGame

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.puzzleIsSolved forKey:@"puzzleIsSolved"];
    [aCoder encodeInt:self.difficulty forKey:@"difficulty"];
    [aCoder encodeInteger:self.numberOfMovesMade forKey:@"numberOfMovesMade"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.tiles forKey:@"tiles"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _puzzleIsSolved = [aDecoder decodeBoolForKey:@"puzzleIsSolved"];
        _difficulty = [aDecoder decodeIntForKey:@"difficulty"];
        _numberOfMovesMade = [aDecoder decodeIntForKey:@"numberOfMovesMade"];
        _imageName = [aDecoder decodeObjectForKey:@"imageName"];
        _tiles = [aDecoder decodeObjectForKey:@"tiles"];
    }
    
    return self;
}

#pragma mark - Properties

-(int)numberOfTiles
{
    return (int)[self.tiles count];
}

-(NSMutableArray *)tiles
{
    if (!_tiles) {
        _tiles = [NSMutableArray array];
    }
    
    return _tiles;
}

-(int)rowOfBlankTile
{
    return [self rowOfTileWithValue:0];
}

-(int)columnOfBlankTile
{
    return [self columnOfTileWithValue:0];
}

#pragma mark - Other

-(void)save
{
    [[ASPreviousGameDatabase sharedDatabase] addGameAndSave:self];
}

-(NSString *)difficultyStringFromDifficulty
{
    if (self.difficulty == EASY) {
        return @"EASY";
    } else if (self.difficulty == MEDIUM) {
        return @"MEDIUM";
    } else if (self.difficulty == HARD) {
        return @"HARD";
    }
    
    return @"";
}

-(NSString *)boardSizeStringFromNumTiles
{
    int numRowsAndCols = sqrt([self.tiles count]);
    return [NSString stringWithFormat:@"%dx%d", numRowsAndCols, numRowsAndCols];
}

-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName;{
    self = [super init];
    
    if (self) {
        for (int tileCount = 1; tileCount < numTiles; tileCount++) {
            NSNumber *tile = [NSNumber numberWithInt:tileCount];
            [self.tiles addObject:tile];
        }
        NSNumber *tile = [NSNumber numberWithInt:0];
        [self.tiles addObject:tile];
        
        self.difficulty = difficulty;
        self.imageName = imageName;
    }
    
    return self;
}

-(int)rowOfTileAtIndex:(int)index
{
    int numRowsInGame = sqrt([self.tiles count]);
    return index / numRowsInGame;
}

-(int)columnOfTileAtIndex:(int)index
{
    int numColumnsInGame = sqrt([self.tiles count]);
    return index % numColumnsInGame;
}

-(int)rowOfTileWithValue:(int)value
{
    __block int rowOfTile;
    [self.tiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *tile = (NSNumber *)obj;
        if ([tile intValue] == value) {
            rowOfTile = [self rowOfTileAtIndex:(int)idx];
        }
    }];
    
    return rowOfTile;
}

-(int)columnOfTileWithValue:(int)value
{
    __block int colOfTile;
    [self.tiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *tile = (NSNumber *)obj;
        if ([tile intValue] == value) {
            colOfTile = [self columnOfTileAtIndex:(int)idx];
        }
    }];
    
    return colOfTile;
}

-(int)indexOfTileAtRow:(int)row andColumn:(int)column
{
    return sqrt([self.tiles count]) * row + column;
}

-(int)valueOfTileAtRow:(int)row andColumn:(int)column;
{
    int index = [self indexOfTileAtRow:row andColumn:column];
    NSNumber *tile = self.tiles[index];
    return [tile intValue];
}

//-(void)selectTileWithValue:(int)value
-(void)selectTileAtRow:(int)rowOfSelectedTile andColumn:(int)colOfSelectedTile
{
    if ([self valueOfTileAtRow:rowOfSelectedTile andColumn:colOfSelectedTile] != 0) {
        // use recursion to make moving multiple tiles possible
        if (rowOfSelectedTile == self.rowOfBlankTile) {
            if (colOfSelectedTile < self.columnOfBlankTile) {
                [self selectTileAtRow:rowOfSelectedTile andColumn:colOfSelectedTile + 1];
            } else if (colOfSelectedTile > self.columnOfBlankTile) {
                [self selectTileAtRow:rowOfSelectedTile andColumn:colOfSelectedTile - 1];
            }
        } else if (colOfSelectedTile == self.columnOfBlankTile) {
            if (rowOfSelectedTile < self.rowOfBlankTile) {
                [self selectTileAtRow:rowOfSelectedTile + 1 andColumn:colOfSelectedTile];
            } else if (rowOfSelectedTile > self.rowOfBlankTile) {
                [self selectTileAtRow:rowOfSelectedTile - 1 andColumn:colOfSelectedTile];
            }
        }
        
        // is the selected cell adjacent to the blank tile? swap them if so
        if (abs(self.rowOfBlankTile - rowOfSelectedTile) <= 1 && abs(self.columnOfBlankTile - colOfSelectedTile) <= 1 &&
            (self.rowOfBlankTile == rowOfSelectedTile || self.columnOfBlankTile == colOfSelectedTile))
        {
            [self swapBlankTileWithTileAtRow:rowOfSelectedTile andColumn:colOfSelectedTile];
            self.numberOfMovesMade++;
            //NSLog(@"%@", [self description]);
        }
    }
}

-(void)swapBlankTileWithTileAtRow:(int)row andColumn:(int)col
{
    int indexOfSelectedTile = [self indexOfTileAtRow:row andColumn:col];
    int indexOfBlankTile = [self indexOfTileAtRow:self.rowOfBlankTile andColumn:self.columnOfBlankTile];
    NSNumber *selectedTile = self.tiles[indexOfSelectedTile];
    NSNumber *blankTile = self.tiles[indexOfBlankTile];
    
    // swap the tiles
    [self.tiles removeObjectAtIndex:indexOfSelectedTile];
    [self.tiles insertObject:blankTile atIndex:indexOfSelectedTile];
    [self.tiles removeObjectAtIndex:indexOfBlankTile];
    [self.tiles insertObject:selectedTile atIndex:indexOfBlankTile];
}

@end
