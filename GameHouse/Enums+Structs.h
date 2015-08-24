//
//  Enums+Structs.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#ifndef GameHouse_EnumsAndStructs_h
#define GameHouse_EnumsAndStructs_h

typedef enum {
    EASY = 0,
    MEDIUM = 1,
    HARD = 2,
}Difficulty;

typedef struct {
    int row;
    int column;
}Position;

typedef struct {
    int rows;
    int columns;
}GridSize;

/*extern NSString * difficultyStringFromDifficulty(Difficulty difficulty) {
    NSString *difficultyString = @"";
    if (difficulty == EASY) difficultyString = @"EASY";
    if (difficulty == MEDIUM) difficultyString = @"MEDIUM";
    if (difficulty == HARD) difficultyString = @"HARD";
    
    return difficultyString;
}*/

#endif
