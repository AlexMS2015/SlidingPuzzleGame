//
//  ASPreviousGameDatabase.h
//  GameHouse
//
//  Created by Alex Smith on 8/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASGame;

@interface ASPreviousGameDatabase : NSObject

@property (strong, nonatomic) NSArray *games;

+(instancetype)sharedDatabase; // singleton
-(void)addGame:(ASGame *)game;
-(BOOL)save;

@end
