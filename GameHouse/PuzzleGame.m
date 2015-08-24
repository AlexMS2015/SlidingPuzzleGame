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
    self.datePlayed = [NSDate date];
    [[PreviousGameDatabase sharedDatabase] addGameAndSave:self];
}

-(NSString *)difficultyStringFromDifficulty
{
    NSString *difficultyString = @"";
    if (self.difficulty == EASY) difficultyString = @"EASY";
    if (self.difficulty == MEDIUM) difficultyString = @"MEDIUM";
    if (self.difficulty == HARD) difficultyString = @"HARD";
    
    return difficultyString;
}

#define MOVES_TO_SOLVE_EASY 15
#define MOVES_TO_SOLVE_MEDIUM 30
#define MOVES_TO_SOLVE_HARD 60
-(int)numMovesToRandomiseForDifficulty:(Difficulty)difficulty
{
    int numMovesToRandomise = 0;
    if (_difficulty == EASY) numMovesToRandomise = MOVES_TO_SOLVE_EASY;
    if (_difficulty == MEDIUM) numMovesToRandomise = MOVES_TO_SOLVE_MEDIUM;
    if (_difficulty == HARD) numMovesToRandomise = MOVES_TO_SOLVE_HARD;
    return numMovesToRandomise;
}

-(void)setDifficulty:(Difficulty)difficulty
{
    _difficulty = difficulty;
    
    /*int numMovesToRandomise = [self numMovesToRandomiseForDifficulty:difficulty];
    
    Position positionNotToSelect;
    Position randomAdjacentTilePos;
    for (int move = 0; move < numMovesToRandomise; move++) {
        randomAdjacentTilePos = [self.board positionOfRandomTileAdjacentToBlankTile];
        if ([PuzzleBoard position:randomAdjacentTilePos isEqualToPosition:positionNotToSelect]) {
            move--;
        } else {
            positionNotToSelect = [self.board positionOfBlankTile];
            [self selectTileAtPosition:randomAdjacentTilePos];
        }
    }*/
}

-(void)startGame
{
    int numMovesToRandomise = [self numMovesToRandomiseForDifficulty:self.difficulty];
    
    Position positionNotToSelect;
    Position randomAdjacentTilePos;
    
    for (int move = 0; move < numMovesToRandomise; move++) {
        randomAdjacentTilePos = [self.board positionOfRandomTileAdjacentToBlankTile];
        if ([PuzzleBoard position:randomAdjacentTilePos isEqualToPosition:positionNotToSelect]) {
            move--;
        } else {
            positionNotToSelect = [self.board positionOfBlankTile];
            [self selectTileAtPosition:randomAdjacentTilePos];
        }
    }
    self.numberOfMovesMade = 0;
}

-(instancetype)initWithNumberOfTiles:(int)numTiles
                       andDifficulty:(Difficulty)difficulty
                       andImageNamed:(NSString *)imageName
{
    if (self = [super init]) {
        self.board = [[SPGBoard alloc] initWithNumTiles:numTiles];
        self.difficulty = difficulty;
        self.imageName = imageName;
        self.numberOfMovesMade = 0;
    }
    
    return self;
}

-(void)selectTileAtPosition:(Position)position
{
    // THIS SHOULD NOT WORK IF PUZZLEISSOLVED IS TRUE
    
    if ([self.board valueOfTileAtPosition:position] != 0) {
        
        Position blankTilePos = [self.board positionOfBlankTile];
        Position newPosition = position;
        
        if (position.row == blankTilePos.row) {
            newPosition.column = position.column < blankTilePos.column ?
                            newPosition.column + 1 : newPosition.column - 1;
        } else if (position.column == blankTilePos.column) {
            newPosition.row = position.row < blankTilePos.row ?
                            newPosition.row + 1 : newPosition.row - 1;
        } else {
            return;
        }
        // use recursion to make moving multiple tiles possible
        [self selectTileAtPosition:newPosition];
        
        if ([self.board blankTileIsAdjacentToTileAtPosition:position]) {
            [self.board swapBlankTileWithTileAtPosition:position];
            self.numberOfMovesMade++;
            [self save];
        }
    }
}

@end
