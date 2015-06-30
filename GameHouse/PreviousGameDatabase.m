//
//  PreviousGameDatabase.m
//  GameHouse
//
//  Created by Alex Smith on 8/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PreviousGameDatabase.h"
#import "PuzzleGame.h"

@interface PreviousGameDatabase ()

@property (strong, nonatomic) NSMutableArray *gamesPrivate;

@end

@implementation PreviousGameDatabase

#pragma mark - Initialisers

+(instancetype)sharedDatabase
{
    
    static PreviousGameDatabase *sharedDatabase; // WHAT DOES THE STATIC KEYWORD DO??
    
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] initPrivate];
    }
    
    return sharedDatabase;
}

-(instancetype)initPrivate
{
    self = [super init]; // REVISE THIS CODE IN THE BOOK PLEASE?
    
    if (self) {
        NSString *path = [self previousGamesPath];
        self.gamesPrivate = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!self.gamesPrivate) {
            self.gamesPrivate = [[NSMutableArray alloc] init];
        }
    }

    return self;
}

#pragma mark - Saving and Loading

-(NSString *)previousGamesPath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"previousGames.archive"];
}

-(BOOL)save
{    
    NSString *path = [self previousGamesPath];
    
    return [NSKeyedArchiver archiveRootObject:self.gamesPrivate toFile:path];
}

-(void)removeGame:(PuzzleGame *)game
{
    BOOL canRemove = NO;
    
    for (PuzzleGame *nextGame in self.gamesPrivate) {
        if (nextGame == game) {
            canRemove = YES;
        }
    }
    
    if (canRemove) {
        [self.gamesPrivate removeObjectIdenticalTo:game];
    }
}

-(void)addGameAndSave:(PuzzleGame *)game
{
    [self.gamesPrivate addObject:game];
    [self save];
}

#pragma mark - Properties

-(NSArray *)games
{
    return [self.gamesPrivate copy];
}

@end
