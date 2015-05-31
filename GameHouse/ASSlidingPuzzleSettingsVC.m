//
//  ASSlidingPuzzleSettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleSettingsVC.h"
#import "Enums.h"
#import "ASPictureSelectionScreenVC.h"

@interface ASSlidingPuzzleSettingsVC ()

// outlets
@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;

// other
@property (nonatomic) int newNumTiles;
@property (nonatomic) Difficulty newDifficulty;
@property (nonatomic) GameMode newMode;
@end

@implementation ASSlidingPuzzleSettingsVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.numTilesSlider.value = self.gameVCForSettings.puzzleGame.numberOfTiles;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameVCForSettings.puzzleGame.difficulty;
    self.gameModeSegmentedControl.selectedSegmentIndex = self.gameVCForSettings.mode;
    
}

#pragma mark - Actions

- (IBAction)cancelWithNoChanges:(UIButton *)sender
{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveSettings:(UIButton *)sender
{
    int initialNumTiles = self.gameVCForSettings.puzzleGame.numberOfTiles;
    Difficulty initialDifficulty = self.gameVCForSettings.puzzleGame.difficulty;
    GameMode initialMode = self.gameVCForSettings.mode;

    if (self.newNumTiles != initialNumTiles || self.newDifficulty != initialDifficulty || self.newMode != initialMode) {
        [self.gameVCForSettings setupNewGameWithNumTiles:self.newNumTiles
                                           andDifficulty:self.newDifficulty
                                                 andMode:self.newMode
                                          withImageNamed:self.gameVCForSettings.imageName];
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

- (IBAction)gameModeChanged:(UISegmentedControl *)sender
{
    if (self.newMode == PICTUREMODE) {
        ASPictureSelectionScreenVC *pictureSelection = [[ASPictureSelectionScreenVC alloc] init];
        [self presentViewController:pictureSelection animated:YES completion:NULL];
    }
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
    } else {
        return self.gameVCForSettings.puzzleGame.difficulty;
    }
}

-(GameMode)newMode
{
    if (self.gameModeSegmentedControl.selectedSegmentIndex == 0) {
        return NUMBERMODE;
    } else if (self.gameModeSegmentedControl.selectedSegmentIndex == 1) {
        return PICTUREMODE;
    } else {
        return self.gameVCForSettings.mode;
    }
}

@end
