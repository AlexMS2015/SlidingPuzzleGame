//
//  PreviousGameDatabase.h
//  GameHouse
//
//  Created by Alex Smith on 8/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PuzzleGame;

@interface PreviousGameDatabase : NSObject

@property (strong, nonatomic) NSArray *games;

+(instancetype)sharedDatabase; // singleton
-(void)addGameAndSave:(PuzzleGame *)game;

@end
