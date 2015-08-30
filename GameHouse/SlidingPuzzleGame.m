//
//  SlidingPuzzleGame.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SlidingPuzzleGame.h"
#import "ObjectDatabase.h"
#import "UIImage+Crop.h"
#import "SlidingPuzzleTile.h"

@interface SlidingPuzzleGame () <NSCoding>

@property (nonatomic, readwrite) BOOL puzzleIsSolved;
@property (nonatomic, readwrite) Difficulty difficulty;
@property (nonatomic, strong, readwrite) NSDate *datePlayed;
@property (nonatomic, strong) NSMutableArray *solvedTiles;

@end

@implementation SlidingPuzzleGame

#pragma mark - Coding/Decoding

-(NSArray *)propertyNames
{
    return @[@"imageName", @"board", @"datePlayed", @"solvedTiles"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:self.puzzleIsSolved forKey:@"solved"];
    [aCoder encodeInt:self.difficulty forKey:@"difficulty"];
    [aCoder encodeInt:self.numberOfMovesMade forKey:@"numberOfMovedMade"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _puzzleIsSolved = [aDecoder decodeBoolForKey:@"solved"];
        _difficulty = [aDecoder decodeIntForKey:@"difficulty"];
        _numberOfMovesMade = [aDecoder decodeIntForKey:@"numberOfMovesMade"];
    }
    
    return self;
}

#pragma mark - Other

-(NSString *)difficultyString
{
    NSString *difficultyString = @"";
    if (self.difficulty == EASY) difficultyString = @"EASY";
    if (self.difficulty == MEDIUM) difficultyString = @"MEDIUM";
    if (self.difficulty == HARD) difficultyString = @"HARD";
    
    return difficultyString;
}

#define MOVE_FACTOR 15;
-(void)startGame
{
    int numMovesToRandomise = (self.difficulty + 1) * MOVE_FACTOR;
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
        self.difficulty = difficulty;
        self.imageName = imageName;
        self.board.objects = self.solvedTiles;

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
        }
    }
}

#pragma mark - Properties

-(void)setNumberOfMovesMade:(int)numberOfMovesMade
{
    _numberOfMovesMade = numberOfMovesMade;
    self.datePlayed = [NSDate date];
    [[ObjectDatabase sharedDatabase] addObjectAndSave:self];
}

-(Position)positionOfBlankTile
{
    int maxTile = self.board.size.rows * self.board.size.columns;
    __block Position posOfBlank;
    [self.board.objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SlidingPuzzleTile *tile = (SlidingPuzzleTile *)obj;
        if (tile.tileValue == maxTile) {
            posOfBlank = [self.board positionOfObject:tile];
        }
    }];
    
    return posOfBlank;
    
    //return [self.board positionOfObject:[NSNumber numberWithInt:maxTile]];
}

-(BOOL)solved
{
    return [self.board.objects isEqualToArray:self.solvedTiles];
}

-(NSMutableArray *)solvedTiles
{
    if (!_solvedTiles) {
        _solvedTiles = [NSMutableArray array];
        /*for (int tileValue = 1; tileValue <= self.board.size.rows * self.board.size.columns; tileValue++) {
            [_solvedTiles addObject:[NSNumber numberWithInt:tileValue]];
        }*/
    }
    
    return _solvedTiles;
}

-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    UIImage *gameImage = [UIImage imageNamed:_imageName];
    NSArray *tileImages = [gameImage divideSquareImageIntoGrid:self.board];
    [tileImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SlidingPuzzleTile *nextTile = [[SlidingPuzzleTile alloc] initWithValue:(int)idx + 1
                                                                      andImage:(UIImage *)obj];
        [self.solvedTiles addObject:nextTile];
    }];
    NSLog(@"Solved tiles: %@", self.solvedTiles);
}

@end
