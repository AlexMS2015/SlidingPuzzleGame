//
//  HomeScreenVC.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "HomeScreenVC.h"
#import "PreviousGamesByDifficultyTVC.h"
#import "PuzzleGameVC.h"
#import "PreviousGameDatabase.h"

@interface HomeScreenVC ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *theHSButtons;
@property (nonatomic) BOOL viewsInPlace;

@end

@implementation HomeScreenVC

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
                         [UIView animateWithDuration:1.5
                                               delay:0.0
                              usingSpringWithDamping:0.25
                               initialSpringVelocity:0
                                             options:0
                                          animations:^{ button.center = originalCenter; }
                                          completion:NULL];}
     ];

}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    self.viewsInPlace = NO;
    
    for (UIButton *button in self.theHSButtons) {
        button.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES; // other view controller's that have been presented (e.g. high scores) will have changed this to NO. Need to set it back to YES.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.viewsInPlace) {
        
        for (UIButton *button in self.theHSButtons) {
            button.hidden = NO;
            [self animateEntranceForButton:button];
        }
    }
    
    self.viewsInPlace = YES;
}

#pragma mark - Action Methods

- (IBAction)beginNewGame:(UIButton *)sender
{
    PuzzleGameVC *game = [[PuzzleGameVC alloc] init];
    [self.navigationController pushViewController:game animated:YES];
}

- (IBAction)showHighScores:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = NO;
    
    PreviousGamesByDifficultyTVC *prevGamesByDiff = [[PreviousGamesByDifficultyTVC alloc] init];
    prevGamesByDiff.games = [PreviousGameDatabase sharedDatabase].games;
    [self.navigationController pushViewController:prevGamesByDiff animated:YES];
}

@end
