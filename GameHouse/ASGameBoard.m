//
//  ASGameBoard.m
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGameBoard.h"

@interface ASGameBoard ()

@property (nonatomic, strong) NSMutableArray *rows; // each object in this array will be another array to represent the tiles of a specific row.
@property (nonatomic) int numberOfRowsPrivate;
@property (nonatomic) int numberOfColumnsPrivate;

@end

@implementation ASGameBoard

-(NSString *)description
{
    
    for (int rowNum = 0; rowNum < self.numberOfRowsPrivate; rowNum++) {
        for (int colNum = 0; colNum < self.numberOfColumnsPrivate; colNum++) {
            NSNumber *currTile = [self objectAtRow:rowNum andColumn:colNum];
            printf("%d  ", [currTile intValue]);
        }
        printf("\n");
    }
    
    return nil;
}

-(void)swapObjectAtRow:(int)row
           andColumn:(int)column
     withObjectAtRow:(int)swapRow
           andColumn:(int)swapColumn
{
    id firstObject = [self objectAtRow:row andColumn:column];
    id secondObject = [self objectAtRow:swapRow andColumn:swapColumn];
    
    [self setObject:firstObject inRow:swapRow andColumn:swapColumn];
    [self setObject:secondObject inRow:row andColumn:column];
}

-(void)setObject:(id)object inRow:(int)row andColumn:(int)column
{
    // NEED TO INSERT CODE TO CHECK IF ROW AND COLUMN ARE VALID. PERHAPS MAKE THE NUMBER OF ROWS AND COLUMNS A PROPERTY ON THIS CLASS?
    [[self.rows objectAtIndex:row] replaceObjectAtIndex:column withObject:object];
}

-(id)objectAtRow:(int)row andColumn:(int)column
{
    // NEED TO INSERT CODE TO CHECK IF ROW AND COLUMN ARE VALID. PERHAPS MAKE THE NUMBER OF ROWS AND COLUMNS A PROPERTY ON THIS CLASS?
    NSMutableArray *selectedRow = self.rows[row];
    return selectedRow[column];
}

#pragma mark - Initialiser

-(instancetype)initWithRows:(int)rows andColumns:(int)columns
{
    self = [super init];
    
    if (self) {
        self.numberOfRowsPrivate = rows;
        self.numberOfColumnsPrivate = columns;
        
        self.rows = [[NSMutableArray alloc] initWithCapacity:rows];
        
        for (int rowNum = 0; rowNum < rows; rowNum++) {
            
            NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:columns];
            
            for (int colNum = 0; colNum < columns; colNum++) {
                row[colNum] = [NSNull null];
            }
            
            self.rows[rowNum] = row;
        }
    }
    
    return self;
}

#pragma mark - Properties

-(int)numberOfColumns
{
    return self.numberOfColumnsPrivate;
}

-(int)numberOfRows
{
    return self.numberOfRowsPrivate;
}

@end
