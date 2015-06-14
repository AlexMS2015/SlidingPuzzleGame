//
//  ASPreviousGameDatabase.h
//  GameHouse
//
//  Created by Alex Smith on 8/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASPuzzleGame;

@interface ASPreviousGameDatabase : NSObject

@property (strong, nonatomic) NSArray *games;

+(instancetype)sharedDatabase; // singleton
-(void)addGameAndSave:(ASPuzzleGame *)game;

@end
