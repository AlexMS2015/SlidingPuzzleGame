//
//  ASSlidingPuzzleGame.m
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleGame.h"
#import "ASGameBoard.h"

@interface ASSlidingPuzzleGame ()
@property (nonatomic, strong) ASGameBoard *board;
@end

@implementation ASSlidingPuzzleGame

-(void)selectTileAtRow:(int)row andColumn:(int)column
{
    // only select a non blank tile
    if ([self valueOfTileAtRow:row andColumn:column] != 0) {
        
        // find the blank tile in the board
        __block int rowOfBlankTile;
        __block int columnOfBlankTile;
        [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol) {
            NSNumber *currentTile = [self.board objectAtRow:currentRow andColumn:currentCol];
            if ([currentTile intValue] == 0) {
                rowOfBlankTile = currentRow;
                columnOfBlankTile = currentCol;
            }
        }];
        
        // is the selected cell adjacent to the blank tile? swap them if so
        if (abs(rowOfBlankTile - row) <= 1 && abs(columnOfBlankTile - column) <= 1 &&
            (rowOfBlankTile == row || columnOfBlankTile == column)) {
            NSNumber *currentTile = [self.board objectAtRow:row andColumn:column];
            NSLog(@"swapping %d", [currentTile intValue]);
            [self.board swapObjectAtRow:row
                              andColumn:column
                        withObjectAtRow:rowOfBlankTile
                              andColumn:columnOfBlankTile];
            NSLog(@"%@", [self.board description]);
        }
    }
}

-(NSString *)description
{
    NSLog(@"%@", [self.board description]);

    [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol) {
    
        [self selectTileAtRow:currentRow andColumn:currentCol];

    }];
     
    return nil;
}

-(int)rowOfTileWithValue:(int)value
{
    __block int rowOfTile;
    [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol) {
        int valueOfCurrentTile = [self valueOfTileAtRow:currentRow andColumn:currentCol];
        if (value == valueOfCurrentTile) {
            rowOfTile = currentRow;
        }
    }];
    
    return rowOfTile;
}

-(int)columnOfTileWithValue:(int)value
{
    __block int columnOfTitle;
    
    [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol) {
        int valueOfCurrentTile = [self valueOfTileAtRow:currentRow andColumn:currentCol];
        if (valueOfCurrentTile == value) {
            columnOfTitle = currentCol;
        }
    }];
    
    return columnOfTitle;
}

-(int)valueOfTileAtRow:(int)row andColumn:(int)column
{
    return [[self.board objectAtRow:row andColumn:column] intValue];
}

-(void)performBlockOnTiles:(void(^)(int currentTileCount, int currentRow, int currentCol))blockToPerform
{
    int currentTileCount = 0;
    for (int currentRow = 0; currentRow < self.board.numberOfRows; currentRow++) {
        for (int currentCol = 0; currentCol < self.board.numberOfColumns; currentCol++) {
            blockToPerform(currentTileCount, currentRow, currentCol);
            currentTileCount++;
        }
    }
}

-(NSMutableArray *)orderedArrayOfTilesWithNumTiles:(int)numTiles
{
    NSMutableArray *tiles = [NSMutableArray arrayWithCapacity:numTiles];
    for (int tileNum = 0; tileNum < numTiles; tileNum++) {
        NSNumber *currentTile = [NSNumber numberWithInt:tileNum];
        [tiles addObject:currentTile];
    }
    
    return tiles;
}

#pragma mark - Initialiser

-(instancetype)initWithNumberOfTiles:(int)tiles
{
    self = [super init];
    
    if (self) {
        int rows = sqrt(tiles);
        int columns = sqrt(tiles);
        self.board = [[ASGameBoard alloc] initWithRows:rows andColumns:columns];
        
        __block NSMutableArray *orderedTiles = [self orderedArrayOfTilesWithNumTiles:tiles];
        [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol)
        {
            // take a random tile from the ordered list (0, 1, 2, 3 etc...) and add it to the board (we want the numbers to be in random order).
            int randomTileNum = arc4random() % [orderedTiles count];
            NSNumber *randomTile = [orderedTiles objectAtIndex:randomTileNum];
            [self.board setObject:randomTile inRow:currentRow andColumn:currentCol];
            [orderedTiles removeObjectAtIndex:randomTileNum];
        }];
    }
    
    return self;
}

@end
