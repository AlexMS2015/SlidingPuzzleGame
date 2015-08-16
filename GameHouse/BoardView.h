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

-(void)tileTapped:(UITapGestureRecognizer *)tap;

@end

@interface BoardView : UIView

@property (weak, nonatomic) id <BoardViewDelegate> delegate; // WEAK OR STRONG?

-(void)setRows:(int)rows andColumns:(int)columns andImage:(UIImage *)image;
-(CGRect)frameOfCellAtPosition:(Position)position;
-(void)moveTilesToPositions:(NSMutableDictionary *)newPositions animated:(BOOL)animated;
-(void)clearTiles;
@end
