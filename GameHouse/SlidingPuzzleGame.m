//
//  SlidingPuzzleGame.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SlidingPuzzleGame.h"
#import "PreviousGameDatabase.h"

@interface SlidingPuzzleGame () <NSCoding>

@property (nonatomic, readwrite) BOOL puzzleIsSolved;
@property (nonatomic, readwrite) Difficulty difficulty;
@property (nonatomic, strong, readwrite) NSDate *datePlayed;
@property (nonatomic, strong) NSMutableArray *solvedTiles;

@end

@implementation SlidingPuzzleGame

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

#pragma mark - Other

-(void)save
{
    self.datePlayed = [NSDate date];
    //[[PreviousGameDatabase sharedDatabase] addGameAndSave:self];
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

-(void)startGame
{
    int numMovesToRandomise = [self numMovesToRandomiseForDifficulty:self.difficulty];
    
    Position positionNotToSelect;
    Position randomAdjacentTilePos;
    
    for (int move = 0; move < numMovesToRandomise; move++) {
        randomAdjacentTilePos = [self.board randomPositionAdjacentToPosition:self.positionOfBlankTile];
        if (PositionsAreEqual(randomAdjacentTilePos, positionNotToSelect)) {
            move--;
        } else {
            positionNotToSelect = self.positionOfBlankTile;
            [self selectTileAtPosition:randomAdjacentTilePos];
        }
    }
    self.numberOfMovesMade = 0;
}

-(instancetype)initWithBoardSize:(GridSize)boardSize andOrientation:(Orientation)orientation andDifficulty:(Difficulty)difficulty andImageNamed:(NSString *)imageName
{
    if (self = [super init]) {
        self.board = [[GridOfObjects alloc] initWithSize:boardSize andOrientation:orientation andObjects:nil];
        self.board.objects = self.solvedTiles;
        self.difficulty = difficulty;
        self.imageName = imageName;
        self.numberOfMovesMade = 0;
    }
    
    return self;
}

-(void)selectTileAtPosition:(Position)position
{
    if (!PositionsAreEqual(position, self.positionOfBlankTile)) {
        
        Position blankTilePos = self.positionOfBlankTile;
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
        
        if (PositionsAreAdjacent(self.positionOfBlankTile, position)) {
            [self.board swapObjectAtPosition:self.positionOfBlankTile withObjectAtPosition:position];
            self.numberOfMovesMade++;
            [self save];
        }
    }
}

#pragma mark - Properties

-(Position)positionOfBlankTile
{
    return [self.board positionOfObject:[NSNumber numberWithInt:0]];
}

-(BOOL)puzzleIsSolved
{
    return [self.board.objects isEqualToArray:self.solvedTiles];
}

-(NSMutableArray *)solvedTiles
{
    if (!_solvedTiles) {
        _solvedTiles = [NSMutableArray array];
        for (int tileValue = 1; tileValue < self.board.size.rows * self.board.size.columns; tileValue++) {
            [_solvedTiles addObject:[NSNumber numberWithInt:tileValue]];
        }
        [_solvedTiles addObject:[NSNumber numberWithInt:0]];
    }
    
    return _solvedTiles;
}

@end
