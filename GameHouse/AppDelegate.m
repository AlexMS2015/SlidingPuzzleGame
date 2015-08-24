//
//  AppDelegate.m
//  GameHouse
//
//  Created by Alex Smith on 5/04/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenVC.h"

@implementation AppDelegate

// gets called before state restoration occurs
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

// gets called after state restoration occurs
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set up the initial VC heirarchy if state restoration didn't occur
    if (!self.window.rootViewController) {
        HomeScreenVC *homeScreen = [[HomeScreenVC alloc] init];
        
        UINavigationController *appNC = [[UINavigationController alloc] initWithRootViewController:homeScreen];
        appNC.restorationIdentifier = NSStringFromClass([appNC class]);
        
        self.window.rootViewController = appNC;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

// for classes where we have not specified a restoration class, the app delegate will provide a new instance of that class
-(UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIViewController *vc = [[UINavigationController alloc] init];
    
    // The last object in the path array (array of restoration identifiers thus far) will be the restoration identifier for this VC
    vc.restorationIdentifier = [identifierComponents lastObject];
    self.window.rootViewController = vc;
    
    return vc;
}


// opt in to state restoration

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

@end
