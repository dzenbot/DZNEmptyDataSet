//
//  AppDelegate.m
//  Photos
//
//  Created by Ignacio Romero Z. on 6/19/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    rootController.view.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
