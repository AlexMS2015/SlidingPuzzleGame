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
@property (nonatomic) int rowOfBlankTile;
@property (nonatomic) int columnOfBlankTile;
@property (nonatomic, readwrite) BOOL puzzleIsSolved;
@end

@implementation ASSlidingPuzzleGame

-(void)selectTileAtRow:(int)row andColumn:(int)column
{
    // only select a non blank tile
    if ([self valueOfTileAtRow:row andColumn:column] != 0) {

        // use recursion to make moving multiple tiles possible
        if (row == self.rowOfBlankTile) {
            if (column < self.columnOfBlankTile) {
                [self selectTileAtRow:row andColumn:column + 1];
            } else if (column > self.columnOfBlankTile) {
                [self selectTileAtRow:row andColumn:column - 1];
            }
        } else if (column == self.columnOfBlankTile) {
            if (row < self.rowOfBlankTile) {
                [self selectTileAtRow:row + 1 andColumn:column];
            } else if (row > self.rowOfBlankTile) {
                [self selectTileAtRow:row - 1 andColumn:column];
            }
        }
    
        // is the selected cell adjacent to the blank tile? swap them if so
        if (abs(self.rowOfBlankTile - row) <= 1 && abs(self.columnOfBlankTile - column) <= 1 &&
            (self.rowOfBlankTile == row || self.columnOfBlankTile == column))
        {
            [self.board swapObjectAtRow:row
                              andColumn:column
                        withObjectAtRow:self.rowOfBlankTile
                              andColumn:self.columnOfBlankTile];
            self.rowOfBlankTile = row;
            self.columnOfBlankTile = column;
            NSLog(@"%@", [self description]);
        }
    }
}

-(NSString *)description
{
    for (int rowNum = 0; rowNum < self.board.numberOfRows; rowNum++) {
        for (int colNum = 0; colNum < self.board.numberOfColumns; colNum++) {
            printf("%2d      ", [self valueOfTileAtRow:rowNum andColumn:colNum]);
        }
        printf("\n");
    }
    
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
    for (int tileNum = 1; tileNum < numTiles; tileNum++) {
        NSNumber *currentTile = [NSNumber numberWithInt:tileNum];
        [tiles addObject:currentTile];
    }
    
    NSNumber *zeroTile = [NSNumber numberWithInt:0];
    [tiles addObject:zeroTile];
    
    return tiles;
}

#pragma mark - Properties

-(int)numberOfTiles
{
    return self.board.numberOfRows * self.board.numberOfRows;
}

-(BOOL)puzzleIsSolved
{
    NSArray *orderedTiles = [self orderedArrayOfTilesWithNumTiles:self.numberOfTiles];
    
    NSMutableArray *gameTilesArray = [NSMutableArray array];
    [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol) {
        [gameTilesArray addObject:[self.board objectAtRow:currentRow andColumn:currentCol]];
    }];
    
    if ([gameTilesArray isEqualToArray:orderedTiles]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Initialiser

#define SOLVED_PUZZLE_TEST

-(instancetype)initWithNumberOfTiles:(int)tiles andDifficulty:(Difficulty)difficulty
{
    // WHAT IF TILES IS NOT A SQUARE NUMBER??
    
    self = [super init];
    
    if (self) {
        int rows = sqrt(tiles);
        int columns = sqrt(tiles);
        self.board = [[ASGameBoard alloc] initWithRows:rows andColumns:columns];
        
        __block NSMutableArray *orderedTiles = [self orderedArrayOfTilesWithNumTiles:self.numberOfTiles];
        #ifndef SOLVED_PUZZLE_TEST
        [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol)
         {
            // take a random tile from the ordered list (0, 1, 2, 3 etc...) and add it to the board (we want the numbers to be in random order).
            int randomTileNum = arc4random() % [orderedTiles count];
            NSNumber *randomTile = [orderedTiles objectAtIndex:randomTileNum];
            [self.board setObject:randomTile inRow:currentRow andColumn:currentCol];
            [orderedTiles removeObjectAtIndex:randomTileNum];
        #endif
            
        #ifdef SOLVED_PUZZLE_TEST
            NSNumber *number = orderedTiles[[orderedTiles count] - 2];
            [orderedTiles replaceObjectAtIndex:[orderedTiles count] - 1
                                    withObject:number];
            [orderedTiles replaceObjectAtIndex:[orderedTiles count] - 2
                                    withObject:@0];
        [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol)
        {
            NSNumber *testTile = orderedTiles[currentTileCount];
            [self.board setObject:testTile inRow:currentRow andColumn:currentCol];
        #endif
        }];
        
        self.rowOfBlankTile = [self rowOfTileWithValue:0];
        self.columnOfBlankTile = [self columnOfTileWithValue:0];
    }
    
    return self;
}

@end
