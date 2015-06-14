//
//  ASPuzzleGame.m
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASPuzzleGame.h"

@interface ASPuzzleGame ()

@property (strong, nonatomic) NSMutableArray *tiles;

@end

@implementation ASPuzzleGame

#pragma mark - Properties

-(NSMutableArray *)tiles
{
    if (!_tiles) {
        _tiles = [NSMutableArray array];
    }
    
    return _tiles;
}

#pragma mark - Public Methods

-(instancetype)initWithNumberOfTiles:(int)numTiles andDifficulty:(Difficulty)difficulty
{
    self = [super init];
    
    if (self) {
        for (int tileCount = 0; tileCount < numTiles; tileCount++) {
            NSNumber *tile = [NSNumber numberWithInt:tileCount];
            [self.tiles addObject:tile];
        }
        
        NSLog(@"%@", self.tiles);
    }
    
    return self;
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

-(int)valueOfTileAtRow:(int)row andColumn:(int)column;
{
    int numOfTiles = (int)[self.tiles count];
    int index = sqrt(numOfTiles) * row + column;
    NSNumber *tile = self.tiles[index];
    return [tile intValue];
}

-(int)rowOfBlankTile
{
    return [self rowOfTileWithValue:0];
}

-(int)columnOfBlankTile
{
    return [self columnOfTileWithValue:0];
}

-(void)selectTileWithValue:(int)value
{
    if (value != 0) {
        int rowOfSelectedTile = [self rowOfTileWithValue:value];
        int colOfSelectedTile = [self columnOfTileWithValue:value];
    
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
            
            NSNumber *selectedTile = [NSNumber numberWithInt:value];
            NSNumber *blankTile = [NSNumber numberWithInt:0];
            int indexOfSelectedTile = (int)[self.tiles indexOfObject:selectedTile];
            int indexOfBlankTile = (int)[self.tiles indexOfObject:blankTile];
            
            [self.tiles removeObjectAtIndex:indexOfSelectedTile];
            [self.tiles insertObject:blankTile atIndex:indexOfSelectedTile];
            [self.tiles removeObjectAtIndex:indexOfBlankTile];
            [self.tiles insertObject:selectedTile atIndex:indexOfBlankTile];
            
            //self.numberOfMovesMade++;
            NSLog(@"%@", [self description]);
        }
    }
}

#pragma mark - Helper Methods

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

@end
