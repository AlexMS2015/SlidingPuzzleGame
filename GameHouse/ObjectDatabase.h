//
//  PreviousGameDatabase.h
//  GameHouse
//
//  Created by Alex Smith on 8/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodableObject.h"

@interface ObjectDatabase : NSObject

// THIS CLASS SHOULD BE A 'PREVIOUS ENCODED OBJECT' CLASS

@property (strong, nonatomic) NSArray *objects;

+(instancetype)sharedDatabase; // singleton
-(void)addObjectAndSave:(CodableObject*)object;
//-(void)removeObject:(CodableObject *)object;

@end
