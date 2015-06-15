//
//  ASPuzzleGame.m
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASPuzzleGame.h"
#import "ASPreviousGameDatabase.h"

@interface ASPuzzleGame () <NSCoding>

@property (nonatomic, readwrite) BOOL puzzleIsSolved;
@property (nonatomic, readwrite) Difficulty difficulty;
@end

@implementation ASPuzzleGame

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.puzzleIsSolved forKey:@"puzzleIsSolved"];
    [aCoder encodeInt:self.difficulty forKey:@"difficulty"];
    [aCoder encodeInteger:self.numberOfMovesMade forKey:@"numberOfMovesMade"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.board forKey:@"board"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _puzzleIsSolved = [aDecoder decodeBoolForKey:@"puzzleIsSolved"];
        _difficulty = [aDecoder decodeIntForKey:@"difficulty"];
        _numberOfMovesMade = [aDecoder decodeIntForKey:@"numberOfMovesMade"];
        _imageName = [aDecoder decodeObjectForKey:@"imageName"];
        _board = [aDecoder decodeObjectForKey:@"board"];
    }
    
    return self;
}

#pragma mark - Other

-(void)save
{
    [[ASPreviousGameDatabase sharedDatabase] addGameAndSave:self];
}

-(NSString *)difficultyStringFromDifficulty
{
    if (self.difficulty == EASY) {
        return @"EASY";
    } else if (self.difficulty == MEDIUM) {
        return @"MEDIUM";
    } else if (self.difficulty == HARD) {
        return @"HARD";
    }
    
    return @"";
}

-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName;
{
    self = [super init];
    
    if (self) {
        
        self.board = [[ASPuzzleBoard alloc] initWithNumTiles:numTiles];
        
        Position currentPosition;
        int tileValue = 1;
        for (currentPosition.row = 0; currentPosition.row < sqrt(numTiles); currentPosition.row++) {
            for (currentPosition.column = 0; currentPosition.column < sqrt(numTiles); currentPosition.column++) {
                if (tileValue < numTiles) {
                    [self.board setTileAtPosition:currentPosition withValue:tileValue];
                    tileValue++;
                }
            }
        }
        
        currentPosition.row = sqrt(numTiles) - 1;
        currentPosition.column = sqrt(numTiles) - 1;
        [self.board setTileAtPosition:currentPosition withValue:0];
        
        self.difficulty = difficulty;
        self.imageName = imageName;
    }
    
    return self;
}

-(void)selectTileAtPosition:(Position)position
{
    if ([self.board valueOfTileAtPosition:position] != 0) {
        
        // use recursion to make moving multiple tiles possible
        Position newPosition = position;
        if (position.row == self.board.positionOfBlankTile.row) {
            if (position.column < self.board.positionOfBlankTile.column) {
                newPosition.column++;
            } else if (position.column > self.board.positionOfBlankTile.column) {
                newPosition.column--;
            }
        } else if (position.column == self.board.positionOfBlankTile.column) {
            if (position.row < self.board.positionOfBlankTile.row) {
                newPosition.row++;
            } else if (position.row > self.board.positionOfBlankTile.row) {
                newPosition.row--;
            }
        }
        
        if (position.row != newPosition.row || position.column != newPosition.column) {
            [self selectTileAtPosition:newPosition];
        }
        
        
        // is the selected cell adjacent to the blank tile? swap them if so
        if (abs(self.board.positionOfBlankTile.row - position.row) <= 1 && abs(self.board.positionOfBlankTile.column - position.column) <= 1 &&
            (self.board.positionOfBlankTile.row == position.row || self.board.positionOfBlankTile.column == position.column))
        {
            [self.board swapBlankTileWithTileAtPosition:position];
            self.numberOfMovesMade++;
            //NSLog(@"%@", [self description]);
        }
    }
}

@end
