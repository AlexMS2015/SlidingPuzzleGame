//
//  ASSlidingPuzzleSettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleSettingsVC.h"
#import "Enums.h"

@interface ASSlidingPuzzleSettingsVC ()

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;

// other
@property (nonatomic) int newNumTiles;
@property (nonatomic) Difficulty newDifficulty;
@end

@implementation ASSlidingPuzzleSettingsVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.numberOfTiles;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
}

#pragma mark - Actions

- (IBAction)saveSettings:(UIButton *)sender
{
    int initialNumTiles = self.gameVCForSettings.puzzleGame.numberOfTiles;
    Difficulty initialDifficulty = self.gameVCForSettings.puzzleGame.difficulty;

    if (self.newNumTiles != initialNumTiles || self.newDifficulty != initialDifficulty) {
        [self.gameVCForSettings setupNewGameWithNumTiles:self.newNumTiles
                                           andDifficulty:self.newDifficulty];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)numTilesChanges:(UISlider *)sender
{
    int numTilesAdjusted = (int)(sqrt(sender.value)) * (int)(sqrt(sender.value));
    
    if (numTilesAdjusted <= 9) {
        numTilesAdjusted = 9;
    }
    
    self.numTilesSlider.value = numTilesAdjusted;
}

#pragma mark - Properties

-(int)newNumTiles
{
    return (int)self.numTilesSlider.value;
}

-(Difficulty)newDifficulty
{
    if (self.difficultySegmentedControl.selectedSegmentIndex == 0) {
        return EASY;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 1) {
        return MEDIUM;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 2) {
        return HARD;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 3) {
        return IMPOSSIBLE;
    } else {
        return self.gameVCForSettings.puzzleGame.difficulty;
    }
}

@end
