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
@property (nonatomic, readwrite) int numberOfRows;
@property (nonatomic, readwrite) int numberOfColumns;

@end

@implementation ASGameBoard

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.numberOfRows forKey:@"numberOfRows"];
    [aCoder encodeInt:self.numberOfColumns forKey:@"numberOfColumns"];
    [aCoder encodeObject:self.rows forKey:@"rows"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _numberOfRows = [aDecoder decodeIntForKey:@"numberOfRows"];
        _numberOfColumns = [aDecoder decodeIntForKey:@"numberOfColumns"];
        _rows = [aDecoder decodeObjectForKey:@"rows"];
    }
    
    return self;
}

#pragma mark - Other

-(void)swapObjectAtRow:(int)row
           andColumn:(int)column
     withObjectAtRow:(int)swapRow
           andColumn:(int)swapColumn
{
    // CHECK FOR VALID ROWS AND COLUMNS BEFORE MAKING THE SWAP
    
    id firstObject = [self objectAtRow:row andColumn:column];
    id secondObject = [self objectAtRow:swapRow andColumn:swapColumn];
    
    [self setObject:firstObject inRow:swapRow andColumn:swapColumn];
    [self setObject:secondObject inRow:row andColumn:column];
}

-(void)setObject:(id)object inRow:(int)row andColumn:(int)column
{
    if (row <= self.numberOfRows && column <= self.numberOfColumns) {
        [[self.rows objectAtIndex:row] replaceObjectAtIndex:column withObject:object];
    }
}

-(id)objectAtRow:(int)row andColumn:(int)column
{
    if (row <= self.numberOfRows && column <= self.numberOfColumns) {
        NSMutableArray *selectedRow = self.rows[row];
        return selectedRow[column];
    }
    
    return nil;
}

#pragma mark - Initialiser

-(instancetype)initWithRows:(int)rows andColumns:(int)columns
{
    self = [super init];
    
    if (self) {
        self.numberOfRows = rows;
        self.numberOfColumns = columns;
        
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

@end
