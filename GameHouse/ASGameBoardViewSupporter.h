//
//  ASGameBoardViewSupporter.h
//  GameHouse
//
//  Created by Alex Smith on 24/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface ASGameBoardViewSupporter : NSObject

-(instancetype)initWithSize:(CGSize)size withRows:(int)rows andColumns:(int)columns;
-(CGRect)frameOfCellAtPosition:(Position)position;
@end
