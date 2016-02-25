//
//  ObjectDatabase.m
//
//  Created by Alex Smith on 8/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ObjectDatabase.h"

@interface ObjectDatabase ()

@property (strong, nonatomic) NSMutableArray *objectsPrivate;
@property (strong, nonatomic) NSString *previousFilePath;

@end

@implementation ObjectDatabase

#pragma mark - Properties

-(NSArray *)objects
{
    return [self.objectsPrivate copy];
}

-(NSString *)previousFilePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"previousObjects.archive"];
}

#pragma mark - Initialisers

+(instancetype)sharedDatabase
{
    static ObjectDatabase *sharedDatabase;
    
    if (!sharedDatabase)
        sharedDatabase = [[self alloc] initPrivate];
    
    return sharedDatabase;
}

-(instancetype)initPrivate
{
    if (self = [super init]) {
        self.objectsPrivate = [NSKeyedUnarchiver unarchiveObjectWithFile:self.previousFilePath];
        
        if (!self.objectsPrivate)
            self.objectsPrivate = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Saving and Loading

-(void)addObjectAndSave:(id)object
{
    if (![self.objectsPrivate containsObject:object])
        [self.objectsPrivate addObject:object];
    [self save];
}

-(BOOL)save
{
    return [NSKeyedArchiver archiveRootObject:self.objectsPrivate toFile:self.previousFilePath];
}

@end
