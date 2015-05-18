//
//  ASGame.h
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGame : NSObject

@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) UIImage *gameLogo;
@property (nonatomic, strong) NSString *gameDescription;

@end
