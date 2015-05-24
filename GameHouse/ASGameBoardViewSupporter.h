//
//  ASGameBoardViewSupporter.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGameBoardViewSupporter : NSObject

-(instancetype)initWithSize:(CGSize)size withRows:(int)rows andColumns:(int)columns;
//- (CGPoint)centerOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;
-(CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;

@end
