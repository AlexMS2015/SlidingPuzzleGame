//
//  NoScrollObjectGrid.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 25/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectGridVC.h"

@interface NoScrollObjectGridVC : ObjectGridVC

-(void)moveObjectAtPosition:(Position)pos1 toPosition:(Position)pos2;

@end
