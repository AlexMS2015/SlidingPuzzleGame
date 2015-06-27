//
//  ASAppDelegate.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenVC.h"
#import "ASSlidingPuzzleGameViewController.h"
#import "PuzzleGame.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeScreenVC *homeScreen = [[HomeScreenVC alloc] init];
    
    UINavigationController *appNC = [[UINavigationController alloc] initWithRootViewController:homeScreen];
    self.window.rootViewController = appNC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
