//
//  ASGameBoard.m
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASGameBoard.h"

@interface ASGameBoard ()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic) NSUInteger numberOfRowsPrivate;
@property (nonatomic) NSUInteger numberOfColumnsPrivate;
@end

@implementation ASGameBoard

-(void)insertObject:(id)object inRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    id objectInBoard = [self objectAtRow:row andColumn:column];
    objectInBoard = [NSNull null];
}

-(void)removeObjectInRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    // NEED TO INSERT CODE TO CHECK IF ROW AND COLUMN ARE VALID. PERHAPS MAKE THE NUMBER OF ROWS AND COLUMNS A PROPERTY ON THIS CLASS?
    id objectInBoard = [self objectAtRow:row andColumn:column];
    objectInBoard = [NSNull null];
}

-(id)objectAtRow:(NSUInteger)row andColumn:(NSUInteger)column
{
    // NEED TO INSERT CODE TO CHECK IF ROW AND COLUMN ARE VALID. PERHAPS MAKE THE NUMBER OF ROWS AND COLUMNS A PROPERTY ON THIS CLASS?
    NSMutableArray *selectedRow = self.rows[row];
    return selectedRow[column];
}

#pragma mark - Initialiser

-(instancetype)initWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns
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

-(NSUInteger)numberOfColumns
{
    return self.numberOfColumnsPrivate;
}

-(NSUInteger)numberOfRows
{
    return self.numberOfRowsPrivate;
}

@end
