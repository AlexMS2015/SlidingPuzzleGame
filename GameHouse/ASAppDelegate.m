//
//  ASAppDelegate.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASHomeScreenViewController.h"
#import "ASSlidingPuzzleGameViewController.h"
#import "ASPuzzleGame.h"

@implementation ASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ASHomeScreenViewController *homeScreen = [[ASHomeScreenViewController alloc] init];
    
    UINavigationController *appNC = [[UINavigationController alloc] initWithRootViewController:homeScreen];
    self.window.rootViewController = appNC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
