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

@property (nonatomic, strong) ASGameBoard *privateTiles;

@end

@implementation ASSlidingPuzzleGame

/*-(void)selectTileAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    id tileLeftOfSelectedTile = [self.privateTiles objectAtRow:row andColumn:column-1];
    id tileRightOfSelectedTile = [self.privateTiles objectAtRow:row andColumn:column+1];
    id tileAboveSelectedTile = [self.privateTiles objectAtRow:row-1 andColumn:column];
    id tileBelowSelectedTile = [self.privateTiles objectAtRow:row+1 andColumn:column];
    
    NSArray *surroundingTiles = @[tileLeftOfSelectedTile, tileRightOfSelectedTile, tileAboveSelectedTile, tileBelowSelectedTile];

    __block id blankTile;
    [surroundingTiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[NSNull class]]) {
            blankTile = obj;
            *stop = YES;
        }
    }];
    
    [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol) {
        if ([self.privateTiles objectAtRow:currentRow andColumn:currentCol] isMemberOfClass:[NSNull class]) { // how do we know to check for this???
            <#statements#>
        }
    }]
}*/

-(void)performBlockOnTiles:(void(^)(int currentTileCount, int currentRow, int currentCol))blockToPerform
{
    int currentTileCount = 0;
    for (int currentRow = 0; currentRow < self.privateTiles.numberOfRows; currentRow++) {
        for (int currentCol = 0; currentCol < self.privateTiles.numberOfColumns; currentCol++) {
            currentTileCount++;
            blockToPerform(currentTileCount, currentRow, currentCol);
        }
    }
}

#pragma mark - Properties

-(ASGameBoard *)tiles
{
    return [self.privateTiles copy];
}

#pragma mark - Initialiser

-(instancetype)initWithNumberOfTiles:(NSUInteger)tiles
{
    self = [super init];
    
    if (self) {
        NSUInteger rows = sqrt(tiles);
        NSUInteger columns = rows;
        
        self.privateTiles = [[ASGameBoard alloc] initWithRows:rows andColumns:columns];
        
        [self performBlockOnTiles:^(int currentTileCount, int currentRow, int currentCol)
        {
            NSNumber *currentTile = [NSNumber numberWithInt:currentTileCount];
            [self.privateTiles insertObject:currentTile inRow:currentRow andColumn:currentCol];
        }]; // THIS WON'T WORK BECAUSE WE NEED A BLANK TILE?? need an if statement to not insert a number in 1 tile. also.. the tiles need to be randomly ordered!!!
        
        /*int currentTileCount = 0;
        for (int rowNum = 0; rowNum < rows; rowNum++) {
            for (int colNum = 0; colNum < columns; colNum++) {
                currentTileCount++;
                NSNumber *currentTile = [NSNumber numberWithInt:currentTileCount];
                [self.privateTiles insertObject:currentTile inRow:rowNum andColumn:colNum];
            }
        }*/
    }
    
    return self;
}

@end
