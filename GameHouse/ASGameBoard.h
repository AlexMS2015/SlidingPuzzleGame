//
//  ASGameBoard.h
//  GameHouse
//
//  Created by Alex Smith on 18/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGameBoard : NSObject

@property (nonatomic, readonly) NSUInteger numberOfRows;
@property (nonatomic, readonly) NSUInteger numberOfColumns;

-(instancetype)initWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns;

// row and columns go from 0 to number specified in initialiser - 1
-(void)insertObject:(id)object inRow:(NSUInteger)row andColumn:(NSUInteger)column;
-(void)removeObjectInRow:(NSUInteger)row andColumn:(NSUInteger)column;
-(id)objectAtRow:(NSUInteger)row andColumn:(NSUInteger)column;

@end
