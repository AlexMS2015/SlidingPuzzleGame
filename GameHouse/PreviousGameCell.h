//
//  ASGameCellTableViewCell.h
//  GameHouse
//
//  Created by Alex Smith on 13/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviousGameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

+(int)cellHeight;

@end
