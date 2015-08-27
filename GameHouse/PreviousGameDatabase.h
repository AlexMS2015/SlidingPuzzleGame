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

// THIS CLASS SHOULD BE A 'PREVIOUS ENCODED OBJECT' CLASS

@property (strong, nonatomic) NSArray *games;

+(instancetype)sharedDatabase; // singleton
-(void)addGameAndSave:(PuzzleGame *)game;
-(void)removeGame:(PuzzleGame *)game;

@end
