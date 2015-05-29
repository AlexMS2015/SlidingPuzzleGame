//
//  ASSlidingPuzzleSettingsVC.m
//  GameHouse
//
//  Created by Alex Smith on 25/05/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASSlidingPuzzleSettingsVC.h"

@interface ASSlidingPuzzleSettingsVC ()

@property (weak, nonatomic) IBOutlet UISlider *numTilesSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;

@end

@implementation ASSlidingPuzzleSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.numTilesSlider.value = self.gameForSettings.numberOfTiles;
    self.difficultySegmentedControl.selectedSegmentIndex = self.gameForSettings.difficulty;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.gameForSettings.numberOfTiles = self.numTilesSlider.value;
    
    if (self.difficultySegmentedControl.selectedSegmentIndex == 0) {
        self.gameForSettings.difficulty = EASY;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 1) {
        self.gameForSettings.difficulty = MEDIUM;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 2) {
        self.gameForSettings.difficulty = HARD;
    } else if (self.difficultySegmentedControl.selectedSegmentIndex == 3) {
        self.gameForSettings.difficulty = IMPOSSIBLE;
    }
}

- (IBAction)saveSettings:(UIButton *)sender
{
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

@end
