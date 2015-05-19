//
//  ASGameBoard.h
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGameBoard : NSObject

@property (nonatomic, readonly) int numberOfRows;
@property (nonatomic, readonly) int numberOfColumns;

-(instancetype)initWithRows:(int)rows andColumns:(int)columns;

// row and columns go from 0 to number specified in initialiser - 1
-(void)setObject:(id)object inRow:(int)row andColumn:(int)column;
//-(void)removeObjectInRow:(int)row andColumn:(int)column;
-(id)objectAtRow:(int)row andColumn:(int)column;
-(void)swapObjectAtRow:(int)row
           andColumn:(int)column
     withObjectAtRow:(int)swapRow
           andColumn:(int)swapColumn;

@end
