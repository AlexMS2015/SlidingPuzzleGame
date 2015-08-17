//
//  BoardView.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 16/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@protocol BoardViewDelegate <NSObject>

-(void)tileTappedWithValue:(int)value;

@end

@interface BoardView : UIView

@property (weak, nonatomic) id <BoardViewDelegate> delegate;

-(void)setRows:(int)rows andColumns:(int)columns andImage:(UIImage *)image;
//-(void)moveTilesToPositions:(NSMutableDictionary *)newPositions animated:(BOOL)animated;

-(void)moveTileWithValue:(int)tileValue toPosition:(Position)tilePos animated:(BOOL)animated;
@end
