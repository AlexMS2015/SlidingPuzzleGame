//
//  ASGameCell.h
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASGameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;
@property (weak, nonatomic) IBOutlet UITextView *gameDescription;

+(NSInteger)rowHeight;

@end
