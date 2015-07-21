//
//  AppDelegate.m
//  WebBrowser
//
//  Created by Ignacio Romero Z. on 7/21/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "WebViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    WebViewController *webVC = [[WebViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/dzenbot/"]];
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:webVC];
    
    self.window.rootViewController = rootVC;
    [self.window  makeKeyAndVisible];
    
    return YES;
}

@end
