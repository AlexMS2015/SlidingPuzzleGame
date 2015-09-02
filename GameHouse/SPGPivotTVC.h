//
//  SPGPivotTVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 2/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ObjectPivotTVC.h"

@interface SPGPivotTVC : UITableViewController

@property (strong, nonatomic) NSDictionary *pivotedPreviousGames;
@property (strong, nonatomic) NSArray *previousGames;

-(NSString *)headerForTable;
-(NSString *)gameStringPropertyToPivot;

@end
