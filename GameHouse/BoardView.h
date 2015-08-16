//
//  BoardView.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@interface BoardView : UIView
-(instancetype)initWithSize:(CGSize)size
                   withRows:(int)rows
                 andColumns:(int)columns
                   andImage:(UIImage *)image;
-(CGRect)frameOfCellAtPosition:(Position)position;
@end
