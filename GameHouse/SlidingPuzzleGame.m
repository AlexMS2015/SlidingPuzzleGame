//
//  SlidingPuzzleGame.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 23/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "SlidingPuzzleGame.h"
#import "UIImage+Crop.h"
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

-(NSArray *)propertyNames
{
    return @[@"board", @"imageName", @"datePlayed"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:self.solved forKey:@"solved"];
    [aCoder encodeInt:self.difficulty forKey:@"difficulty"];
    [aCoder encodeInt:self.numberOfMovesMade forKey:@"numberOfMovesMade"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _solved = [aDecoder decodeBoolForKey:@"solved"];
        _difficulty = [aDecoder decodeIntForKey:@"difficulty"];
        _numberOfMovesMade = [aDecoder decodeIntForKey:@"numberOfMovesMade"];
        
        // give the tiles their images back (not saved for efficiency)
        NSArray *tileImages = [[UIImage imageNamed:self.imageName] divideSquareImageIntoGrid:self.board];
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

-(instancetype)initWithBoardSize:(GridSize)boardSize andOrientation:(Orientation)orientation andDifficulty:(Difficulty)difficulty andImageNamed:(NSString *)imageName
{
    if (self = [super init]) {
        self.board = [[GridOfObjects alloc] initWithSize:boardSize andOrientation:orientation andObjects:nil];
        self.difficulty = difficulty;
        self.imageName = imageName;
        self.numberOfMovesMade = 0;
        
        NSArray *tileImages = [[UIImage imageNamed:imageName] divideSquareImageIntoGrid:self.board];
        [tileImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SlidingPuzzleTile *nextTile = [[SlidingPuzzleTile alloc] initWithValue:(int)idx + 1
                                                                          andImage:(UIImage *)obj];
            [self.board setPosition:[self.board positionOfIndex:(int)idx] toObject:nextTile];
        }];
    }
    
    return self;
}

/*-(void)swipeAtPosition:(Position)position inDirection:(UISwipeGestureRecognizerDirection)direction
{
    Position startPos;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionDown:
            startPos = (Position){0, self.positionOfBlankTile.column};
            break;
        case UISwipeGestureRecognizerDirectionUp:
            startPos = (Position){self.board.size.rows - 1, self.positionOfBlankTile.column};
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            startPos = (Position){self.positionOfBlankTile.row, self.board.size.columns - 1};
            break;
        case UISwipeGestureRecognizerDirectionRight:
            startPos = (Position){self.positionOfBlankTile.row, 0};
            break;
            
        default:
            break;
    }
    
    [self selectTileAtPosition:startPos];
}*/

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
    return [NSString stringWithFormat:@"%dx%d", self.board.size.rows, self.board.size.columns];
}

-(Position)positionOfBlankTile
{
    Position blankTilePos;
    int maxTileValue = self.board.size.rows * self.board.size.columns;
    
    for (SlidingPuzzleTile *tile in self.board.objects) {
        if (tile.value == maxTileValue)
            blankTilePos = [self.board positionOfObject:tile];
    }
    return blankTilePos;
}

-(BOOL)solved
{
    for (SlidingPuzzleTile *tile in self.board.objects) {
        if (tile.value != [self.board.objects indexOfObject:tile] + 1)
            return NO;
    }
    return YES;
}

@end
