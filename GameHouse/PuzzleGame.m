//
//  PuzzleGame.m
//  GameHouse
//
//  Created by Alex Smith on 14/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "PuzzleGame.h"
#import "PreviousGameDatabase.h"

@interface PuzzleGame () <NSCoding>

@property (nonatomic, readwrite) BOOL puzzleIsSolved;
@property (nonatomic, readwrite) Difficulty difficulty;
@property (nonatomic, strong, readwrite) NSDate *datePlayed;

@end

@implementation PuzzleGame

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.puzzleIsSolved forKey:@"puzzleIsSolved"];
    [aCoder encodeInt:self.difficulty forKey:@"difficulty"];
    [aCoder encodeInteger:self.numberOfMovesMade forKey:@"numberOfMovesMade"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.board forKey:@"board"];
    [aCoder encodeObject:self.datePlayed forKey:@"datePlayed"];
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
        _datePlayed = [aDecoder decodeObjectForKey:@"datePlayed"];
    }
    
    return self;
}

#pragma mark - Properties

-(BOOL)puzzleIsSolved
{
    int numTiles = self.board.numberOfTiles;
    int numRowsAndCols = sqrt(numTiles);
    
    Position currentPosition;
    int completedTileValue = 1;
    
    for (currentPosition.row = 0; currentPosition.row < numRowsAndCols; currentPosition.row++) {
        for (currentPosition.column = 0; currentPosition.column < numRowsAndCols; currentPosition.column++) {

            int nextTileValue = [self.board valueOfTileAtPosition:currentPosition];
            
            if (nextTileValue != completedTileValue && nextTileValue != 0) {
                return NO;
            }
            
            completedTileValue++;
        }
    }
    return YES;
}

#pragma mark - Other

-(void)save
{
    NSLog(@"saving game with nummoves: %d and image: %@", self.numberOfMovesMade, self.imageName);

    [[PreviousGameDatabase sharedDatabase] addGameAndSave:self];
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

#define MOVES_TO_SOLVE_EASY 3
#define MOVES_TO_SOLVE_MEDIUM 30
#define MOVES_TO_SOLVE_HARD 60

-(void)setDifficulty:(Difficulty)difficulty
{
    _difficulty = difficulty;
    
    Position positionNotToSelect;
    Position randomAdjacentTilePos;
    int numMovesToRandomise;
    
    if (_difficulty == EASY) {
        numMovesToRandomise = MOVES_TO_SOLVE_EASY;
    } else if (_difficulty == MEDIUM) {
        numMovesToRandomise = MOVES_TO_SOLVE_MEDIUM;
    } else if (_difficulty == HARD) {
        numMovesToRandomise = MOVES_TO_SOLVE_HARD;
    }
    
    for (int move = 0; move < numMovesToRandomise; move++) {
        randomAdjacentTilePos = [self randomTileAdjacentToBlank];
        if ([self position:randomAdjacentTilePos isEqualToPosition:positionNotToSelect]) {
            move--;
        } else {
            positionNotToSelect = [self.board positionOfBlankTile];
            [self selectTileAtPosition:randomAdjacentTilePos];
        }
    }
}

-(void)setTilesInInitialPositions
{
    int numTiles = self.board.numberOfTiles;
    int numRowsAndCols = sqrt(numTiles);
    
    Position currentPosition;
    int tileValue = 1;
    
    for (currentPosition.row = 0; currentPosition.row < numRowsAndCols; currentPosition.row++) {
        for (currentPosition.column = 0; currentPosition.column < numRowsAndCols; currentPosition.column++) {
            if (tileValue < numTiles) {
                [self.board setTileAtPosition:currentPosition withValue:tileValue];
                tileValue++;
            }
        }
    }
    
    currentPosition.row = sqrt(numTiles) - 1;
    currentPosition.column = sqrt(numTiles) - 1;
    [self.board setTileAtPosition:currentPosition withValue:0];
}


-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName;
{
    self = [super init];
    
    if (self) {
        self.board = [[PuzzleBoard alloc] initWithNumTiles:numTiles];
        [self setTilesInInitialPositions];
        self.difficulty = difficulty;
        self.imageName = imageName;
        self.numberOfMovesMade = 0;
        self.datePlayed = [NSDate date];
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
        if (abs(self.board.positionOfBlankTile.row - position.row) <= 1 &&
            abs(self.board.positionOfBlankTile.column - position.column) <= 1 &&
            (self.board.positionOfBlankTile.row == position.row
                || self.board.positionOfBlankTile.column == position.column))
        {
            [self.board swapBlankTileWithTileAtPosition:position];
            self.numberOfMovesMade++;
            //NSLog(@"%@", [self description]);
        }
    }
}

-(BOOL)position:(Position)firstPosition isEqualToPosition:(Position)secondPosition
{
    if (firstPosition.row == secondPosition.row &&
        firstPosition.column == secondPosition.column) {
        return YES;
    } else {
        return NO;
    }
}

-(Position)randomTileAdjacentToBlank
{
    Position blankTilePosition = [self.board positionOfBlankTile];
    Position adjacentTilePos = blankTilePosition;
    
    int maxCol = sqrt(self.board.numberOfTiles) - 1;
    int maxRow = sqrt(self.board.numberOfTiles) - 1;

    while ([self position:adjacentTilePos isEqualToPosition:blankTilePosition]) {
        int randomTile = arc4random() % 4;

        if (randomTile == 0 && blankTilePosition.column > 0) {
            adjacentTilePos.column--;
        } else if (randomTile == 1 && blankTilePosition.column < maxCol) {
            adjacentTilePos.column++;
        } else if (randomTile == 2 && blankTilePosition.row > 0) {
            adjacentTilePos.row--;
        } else if (randomTile == 3 && blankTilePosition.row < maxRow) {
            adjacentTilePos.row++;
        }
    }
    
    return adjacentTilePos;
}

@end
