//
//  NSObject+System.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 11/25/12.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

#define IPHONE_5_HEIGHT 568.0f
#define IPHONE_4_HEIGHT 480.0f
#define IPHONE_HEIGHT_DELTA 568.0f - 480.0f

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == IPHONE_5_HEIGHT)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == IPHONE_4_HEIGHT)

#define IS_IOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IS_IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#define IS_RETINA ([UIScreen mainScreen].scale > 1.0)

/*
 Useful system methods.
*/
@interface NSObject (System)

/*
 Returns the URL to the application's Documents directory.
 
 @returns The documents directory URL.
*/
+ (NSURL *)applicationDocumentsDirectory;

/* Returns the device model name.

 @returns The device name.
*/
+ (NSString *)deviceModel;

/* 
 Returns the device complete name (ie: iPod Touch 4G).
 TODO: This method must be kept updated for new device incoming device models.

 @returns The device name.
*/
+ (NSString *)deviceName;

/* Returns the OS version name and number.

 @returns The OS version.
*/
+ (NSString *)OSVersion;

/*

*/
+ (BOOL)isOSMinimumRequired:(NSString *)minimum;

/*
 Returns the device density value.

 @retuns The device density value.
*/
+ (float)density;

/*
 Returns the bundle name.

 @returns The bundle name.
*/
+ (NSString *)bundleName;

/*
 Returns the app display name.

 @returns The app name.
*/
+ (NSString *)appName;

/*
 Returns the app version number.

 @returns The app version.
*/
+ (NSString *)appVersion;

/*
 Returns the build version number.

 @returns The build version.
*/
+ (NSString *)buildVersion;

/* 
 Checks if the device is jailbroken or not.

 @returns  Yes if the device is jailbroken.
*/
+ (BOOL)isJailbroken;

@end
