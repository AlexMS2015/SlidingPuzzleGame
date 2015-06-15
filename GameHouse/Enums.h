//
//  Enums.h
//  GameHouse
//
//  Created by Alex Smith on 15/06/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#ifndef GameHouse_Enums_h
#define GameHouse_Enums_h

typedef enum {
    EASY = 0,
    MEDIUM = 1,
    HARD = 2,
}Difficulty;

typedef struct {
    int row;
    int column;
}Position;

#endif
