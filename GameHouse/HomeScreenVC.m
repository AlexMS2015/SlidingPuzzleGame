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
#import "ObjectDatabase.h"

@interface HomeScreenVC () <UIViewControllerRestoration>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *creditsLabels;
@property (weak, nonatomic) IBOutlet UIImageView *screenBackground;
@property (weak, nonatomic) IBOutlet UIButton *screenTitle;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *theHSButtons;

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
    button.hidden = NO;
    
    // Which button are we animating?
    NSInteger buttonIndex = [self.theHSButtons indexOfObject:button];
    
    // Store the original center so we can move the button back here later
    CGPoint originalCenter = button.center;
    
    // Set the button's initial properties
    NSArray *corners = [self cornersForView:self.view];
    button.center = [corners[buttonIndex] CGPointValue];
    float originalButtonAlpha = button.alpha;
    button.alpha = 0.0;
    
    [UIView animateWithDuration:1.5
                          delay:0.25
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:0
                     animations:^{  button.center =  originalCenter;
                                    button.alpha = originalButtonAlpha; }
                     completion:NULL];
}

#pragma mark - UIViewControllerRestoration

// since this class has a restoration class, that restoration class (this class) will be asked to create a new instance of the view controller
+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

#pragma mark - Initialiser

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    
    return self;
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    for (UIButton *button in self.theHSButtons) {
        button.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    for (UIButton *button in self.theHSButtons) {
        [self animateEntranceForButton:button];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Action Methods

- (IBAction)showCredits:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Credits"]) {
        self.screenBackground.image = [UIImage imageNamed:@"Squirrels"];
        self.screenTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.screenTitle setTitle:@"Credits" forState:UIControlStateNormal];
        [sender setTitle:@"Hide Credits" forState:UIControlStateNormal];
    } else {
        self.screenBackground.image = [UIImage imageNamed:@"ScreenBackground"];
        [self.screenTitle setTitle:@"Sliding Puzzle" forState:UIControlStateNormal];
        [sender setTitle:@"Credits" forState:UIControlStateNormal];
    }
    
    BOOL hidden;
    for (UIButton *button in self.theHSButtons) {
        hidden = button.hidden;
        button.hidden = !hidden;
    }
    
    UILabel *creditsLabel = (UILabel *)[self.creditsLabels firstObject];
    hidden = creditsLabel.hidden;
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        for (UILabel *creditsLabel in self.creditsLabels) {
                            creditsLabel.hidden = !hidden;
                        }
                    }
                    completion:nil];
}


- (IBAction)beginNewGame:(UIButton *)sender
{
    PuzzleGameVC *game = [[PuzzleGameVC alloc] init];
    [self.navigationController pushViewController:game animated:YES];
}

- (IBAction)showPreviousGames:(UIButton *)sender
{
    PreviousGamesByDifficultyTVC *prevGamesByDiff = [[PreviousGamesByDifficultyTVC alloc] init];
    prevGamesByDiff.games = [ObjectDatabase sharedDatabase].objects;
    [self.navigationController pushViewController:prevGamesByDiff animated:YES];
}

@end
