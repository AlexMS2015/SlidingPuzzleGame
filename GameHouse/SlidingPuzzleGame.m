//
//  SlidingPuzzleGame.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SlidingPuzzleGame.h"
#import "UIImage+Crop.h"
#import "GridOfObjects+NSCoding.h"
#import "SlidingPuzzleTile.h"

@interface SlidingPuzzleGame () <NSCoding>

@property (nonatomic, readwrite) Difficulty difficulty;
@property (strong, nonatomic, readwrite) NSString *difficultyString;
@property (nonatomic, readwrite) BOOL solved;
@property (nonatomic, readwrite) int numberOfMovesMade;
@property (nonatomic, strong, readwrite) GridOfObjects *board; // contains 'SlidingPuzzleTile' objects
@property (nonatomic, readwrite) NSString *imageName;
@property (nonatomic, strong, readwrite) NSDate *datePlayed;
@property (nonatomic, readwrite) Position positionOfBlankTile;
@property (strong, nonatomic, readwrite) NSString *boardSizeString;

@end

@implementation SlidingPuzzleGame

#pragma mark - Coding/Decoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.board forKey:@"board"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:@"datePlayed" forKey:@"datePlayed"];
    [aCoder encodeBool:self.solved forKey:@"solved"];
    [aCoder encodeInt:self.difficulty forKey:@"difficulty"];
    [aCoder encodeInt:self.numberOfMovesMade forKey:@"numberOfMovesMade"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.board = [aDecoder decodeObjectForKey:@"board"];
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        self.datePlayed = [aDecoder decodeObjectForKey:@"datePlayed"];
        
        self.solved = [aDecoder decodeBoolForKey:@"solved"];
        self.difficulty = [aDecoder decodeIntForKey:@"difficulty"];
        self.numberOfMovesMade = [aDecoder decodeIntForKey:@"numberOfMovesMade"];
        
        // give the tiles their images back (not saved for efficiency)
        NSArray *tileImages = [[UIImage imageNamed:self.imageName] divideImageIntoGridWithRows:self.board.numRows andColumns:self.board.numCols];
        if ([self.board.objects count] > 0) {
            for (SlidingPuzzleTile *tile in self.board.objects) {
                tile.image = tileImages[tile.value - 1];
            }
        }
    }

    return self;
}

#pragma mark - Other

#define MOVE_FACTOR 15;
-(void)startGame
{
    int numMovesToRandomise = (self.difficulty + 1) * MOVE_FACTOR;
    Position positionNotToSelect; // prevents reversal of the previously selected random move
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

-(instancetype)initWithRows:(NSInteger)rows andColumns:(NSInteger)cols andDifficulty:(Difficulty)difficulty andImageNamed:(NSString *)imageName
{
    if (self = [super init]) {
        self.board = [[GridOfObjects alloc] initWithRows:rows andColumns:cols];
        self.difficulty = difficulty;
        self.imageName = imageName;
        self.numberOfMovesMade = 0;
        
        NSArray *tileImages = [[UIImage imageNamed:self.imageName] divideImageIntoGridWithRows:self.board.numRows andColumns:self.board.numCols];
        [tileImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SlidingPuzzleTile *nextTile = [[SlidingPuzzleTile alloc] initWithValue:(int)idx + 1
                                                                          andImage:(UIImage *)obj];
            NSInteger row = idx / self.board.numCols;
            NSInteger col = idx % self.board.numCols;
            self.board.objects[row][col] = nextTile;
        }];
    }
    
    return self;
}

-(void)selectTileAtPosition:(Position)position
{
    if (!PositionsAreEqual(position, self.positionOfBlankTile)) {
        
        Position newPosition = position;
        
        if (position.row == self.positionOfBlankTile.row) {
            newPosition.column = position.column < self.positionOfBlankTile.column ?
                            newPosition.column + 1 : newPosition.column - 1;
        } else if (position.column == self.positionOfBlankTile.column) {
            newPosition.row = position.row < self.positionOfBlankTile.row ?
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

-(NSDate *)datePlayed
{
    return [NSDate date];
}

-(NSString *)difficultyString
{
    NSString *difficultyString = @"";
    if (self.difficulty == EASY) difficultyString = @"EASY";
    if (self.difficulty == MEDIUM) difficultyString = @"MEDIUM";
    if (self.difficulty == HARD) difficultyString = @"HARD";
    
    return difficultyString;
}

-(NSString *)boardSizeString
{
    return [NSString stringWithFormat:@"%ldx%ld", (unsigned long)self.board.numRows, (unsigned long)self.board.numCols];
}

-(Position)positionOfBlankTile
{
    __block Position blankTilePos;
    NSInteger maxTileValue = self.board.numRows * self.board.numCols;
    
    [self.board enumerateWithBlock:^(Position position, id obj) {
        SlidingPuzzleTile *tile = (SlidingPuzzleTile *)obj;
        if (tile.value == maxTileValue)
            blankTilePos = [self.board positionOfObject:tile];
    }];
    
    return blankTilePos;
}

-(BOOL)solved
{
    __block BOOL solved = YES;
    
    [self.board enumerateWithBlock:^(Position position, id obj) {
        SlidingPuzzleTile *tile = (SlidingPuzzleTile *)obj;
        NSInteger objIdx = self.board.numCols * position.row + position.column;
        if (tile.value != objIdx + 1) solved = NO;
    }];
    
    return solved;
}

@end
