//
//  SPGPivotTVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 2/09/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPGPivotTVC : UITableViewController

@property (strong, nonatomic) NSArray *previousGames; // pass this property in when creating an instance of this object's concrete subclasses
@property (strong, nonatomic) NSDictionary *pivotedPreviousGames;

// abstract methods
-(NSString *)headerForTable;
-(NSString *)gameStringPropertyToPivot;

@end
