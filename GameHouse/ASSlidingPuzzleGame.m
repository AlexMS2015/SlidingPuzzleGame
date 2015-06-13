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
@property (nonatomic, readwrite) Difficulty difficulty;
@end

@implementation ASSlidingPuzzleGame

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.puzzleIsSolved forKey:@"puzzleIsSolved"];
    [aCoder encodeInt:self.difficulty forKey:@"difficulty"];
    [aCoder encodeInteger:self.numberOfMovesMade forKey:@"numberOfMovesMade"];
    [aCoder encodeObject:self.board forKey:@"board"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _puzzleIsSolved = [aDecoder decodeBoolForKey:@"puzzleIsSolved"];
        _difficulty = [aDecoder decodeIntForKey:@"difficulty"];
        _numberOfMovesMade = [aDecoder decodeIntForKey:@"numberOfMovesMade"];
        _board = [aDecoder decodeObjectForKey:@"board"];
    }
    
    return self;
}

#pragma mark - Other

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
    int numRowsAndCols = sqrt(self.numberOfTiles);
    return [NSString stringWithFormat:@"%dx%d", numRowsAndCols, numRowsAndCols];
}

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
            self.numberOfMovesMade++;
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
            currentTileCount++;
            blockToPerform(currentTileCount, currentRow, currentCol);
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

-(int)rowOfBlankTile
{
    return [self rowOfTileWithValue:0];
}

-(int)columnOfBlankTile
{
    return [self columnOfTileWithValue:0];
}

-(int)numberOfTiles
{
    return self.board.numberOfRows * self.board.numberOfColumns;
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

//#define SOLVED_PUZZLE_TEST

-(instancetype)initWithNumberOfTiles:(int)tiles andDifficulty:(Difficulty)difficulty
{
    // WHAT IF TILES IS NOT A SQUARE NUMBER??
    
    self = [super init];
    
    if (self) {
        int rows = sqrt(tiles);
        int columns = sqrt(tiles);
        self.board = [[ASGameBoard alloc] initWithRows:rows andColumns:columns];
        self.difficulty = difficulty;
        
        __block NSMutableArray *orderedTilesForGame = [self orderedArrayOfTilesWithNumTiles:self.numberOfTiles];
    
#ifndef SOLVED_PUZZLE_TEST
        [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol)
         {
             // take a random tile from the ordered list (0, 1, 2, 3 etc...) and add it to the board (we want the numbers to be in random order).
             //if (currentTileCount <= self.numberOfTiles) {
                int randomTileNum = arc4random() % [orderedTilesForGame count];
                NSNumber *randomTile = [orderedTilesForGame objectAtIndex:randomTileNum];
                [self.board setObject:randomTile inRow:currentRow andColumn:currentCol];
                [orderedTilesForGame removeObjectAtIndex:randomTileNum];
         }];
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
            [self.solvedPuzzle setObject:testTile inRow:currentRow andColumn:currentCol];
        }];
#endif

        // put the zero tile at the end
        [self.board swapObjectAtRow:self.rowOfBlankTile andColumn:self.columnOfBlankTile withObjectAtRow:self.board.numberOfRows-1 andColumn:self.board.numberOfColumns-1];
    }
    
    return self;
}

@end
