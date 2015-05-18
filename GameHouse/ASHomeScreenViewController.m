//
//  ASHomeScreenViewController.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASHomeScreenViewController.h"
#import "ASGameSelectionTableViewController.h"
#import "ASHighScoresTableViewController.h"
#import "ASGameDatabase.h"
#import "ASGame.h"

@interface ASHomeScreenViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *theHSButtons;

@end

@implementation ASHomeScreenViewController

#pragma mark - Helper Methods

-(NSArray *)cornersForView:(UIView *)view
{
    CGPoint topLeft = CGPointMake(0, 0);
    CGPoint topRight = CGPointMake(CGRectGetMaxX(self.view.bounds), 0);
    CGPoint bottomLeft = CGPointMake(0, CGRectGetMaxY(self.view.bounds));
    CGPoint bottomRight = CGPointMake(CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds));
    
    NSArray *corners = @[ [NSValue valueWithCGPoint:topLeft],
                          [NSValue valueWithCGPoint:topRight],
                          [NSValue valueWithCGPoint:bottomLeft],
                          [NSValue valueWithCGPoint:bottomRight] ];
    return corners;
}

-(void)animateEntranceForButton:(UIButton *)button
{
    // Which button are we animating?
    NSInteger buttonIndex = [self.theHSButtons indexOfObject:button];
    
    // Store the original center so we can move the button back here later
    CGPoint originalCenter = button.center;
    
    // Set the button's initial properties
    NSArray *corners = [self cornersForView:self.view];
    button.center = [corners[buttonIndex] CGPointValue];
    button.alpha = 0.0;

    // Buttons will fly in from corners to view center and then spring into their original locations
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         button.center = self.view.center;
                         button.alpha = 0.75;
                     }
                     completion: ^(BOOL finished) {
                         NSLog(@"springing");
                         [UIView animateWithDuration:2.0
                                               delay:0.0
                              usingSpringWithDamping:0.25
                               initialSpringVelocity:0
                                             options:0
                                          animations:^{ button.center = originalCenter; }
                                          completion:NULL]; }
     ];

}

#pragma mark - View Life Cycle

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES; // Other view controller's that have been presented (e.g. high scores) will have changed this to NO. Need to set it back to YES.
    
    for (UIButton *button in self.theHSButtons) {
        [self animateEntranceForButton:button];
    }
}

#pragma mark - Action Methods

- (IBAction)beginNewGame:(UIButton *)sender
{
    ASGameSelectionTableViewController *gameSelectionScreen = [[ASGameSelectionTableViewController alloc] init];
    [self.navigationController pushViewController:gameSelectionScreen animated:YES];
}

- (IBAction)showHighScores:(UIButton *)sender
{
    UITabBarController *highScoresTBC = [[UITabBarController alloc] init];
    
    NSMutableArray *highScoreTables = [NSMutableArray array];
    for (ASGame *game in [[ASGameDatabase sharedGameDatabase] allGames]) {
        ASHighScoresTableViewController *HSTable = [[ASHighScoresTableViewController alloc] initWithGame:game];
        [highScoreTables addObject:HSTable];
    }
    
    highScoresTBC.viewControllers = [NSArray arrayWithArray:highScoreTables];
    
    [self.navigationController pushViewController:highScoresTBC animated:YES];
    highScoresTBC.navigationController.navigationBar.hidden = NO;
    highScoresTBC.navigationItem.title = @"High Scores";
}

@end
