//
//  ObjectDatabase.h
//
//  Created by Alex Smith on 8/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodableObject.h"

@interface ObjectDatabase : NSObject

@property (strong, nonatomic) NSArray *objects;

+(instancetype)sharedDatabase; // singleton
-(void)addObjectAndSave:(CodableObject*)object; // if the passed in object already exists in the database, this method will make sure it is not added a second time before saving
@end
