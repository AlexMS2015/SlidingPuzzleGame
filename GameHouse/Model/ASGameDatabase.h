//
//  ASGameDatabase.h
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGameDatabase : NSObject

@property (nonatomic, readonly, copy) NSArray *allGames;

+(instancetype)sharedGameDatabase; // singleton

@end
