//
//  NSObject+System.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 11/25/12.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSObject+System.h"
#include <sys/utsname.h>

@implementation NSObject (System)

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceName
{
    NSString *platform = [NSObject deviceModel];
    
    if ([platform hasPrefix:@"iPhone1,1"])      return @"iPhone 2G";
    if ([platform hasPrefix:@"iPhone1,2"])      return @"iPhone 3G";
    if ([platform hasPrefix:@"iPhone2,1"])      return @"iPhone 3GS";
    if ([platform hasPrefix:@"iPhone3,1"])      return @"iPhone 4";
    if ([platform hasPrefix:@"iPhone3,3"])      return @"Verizon iPhone 4";
    if ([platform hasPrefix:@"iPhone4,1"])      return @"iPhone 4S";
    if ([platform hasPrefix:@"iPhone5,1"])      return @"iPhone 5";
    if ([platform hasPrefix:@"iPhone5,2"])      return @"iPhone 5";
    if ([platform hasPrefix:@"iPhone5,3"])      return @"iPhone 5C (GSM)";
    if ([platform hasPrefix:@"iPhone5,4"])      return @"iPhone 5C (Global)";
    if ([platform hasPrefix:@"iPhone6,1"])      return @"iPhone 5S (GSM)";
    if ([platform hasPrefix:@"iPhone6,2"])      return @"iPhone 5S (Global)";
    if ([platform hasPrefix:@"iPod1,1"])        return @"iPod Touch 1G";
    if ([platform hasPrefix:@"iPod2,1"])        return @"iPod Touch 2G";
    if ([platform hasPrefix:@"iPod3,1"])        return @"iPod Touch 3G";
    if ([platform hasPrefix:@"iPod4,1"])        return @"iPod Touch 4G";
    if ([platform hasPrefix:@"iPad1,1"])        return @"iPad 1G";
    if ([platform hasPrefix:@"iPad2,1"])        return @"iPad 2(WiFi)";
    if ([platform hasPrefix:@"iPad2,2"])        return @"iPad 2(GSM)";
    if ([platform hasPrefix:@"iPad2,3"])        return @"iPad 2(CDMA)";
    if ([platform hasPrefix:@"iPad3,1"])        return @"iPad 3";
    if ([platform hasPrefix:@"iPad3,2"])        return @"iPad 3(GSM/CDMA)";
    if ([platform hasPrefix:@"iPad3,3"])        return @"iPad 3(GSM)";
    if ([platform hasPrefix:@"iPad3,4"])        return @"iPad 3(GSM)";
    if ([platform hasPrefix:@"iPad2,5"])        return @"iPad mini 1G";
    if ([platform hasPrefix:@"i386"])           return @"Simulator i386";
    if ([platform hasPrefix:@"x86_64"])         return @"Simulator x86_64";
    
    return platform;
}

+ (NSString *)OSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (BOOL)isOSMinimumRequired:(NSString *)minimum
{
    // eg  NSString *reqSysVer = @"4.0";
    
    NSString *currSysVer = [NSObject OSVersion];
    if ([currSysVer compare:minimum options:NSNumericSearch] != NSOrderedAscending) return YES;
    else return NO;
}

+ (float)density
{
    return [UIScreen mainScreen].scale;
}

+ (NSString *)bundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (BOOL)isJailbroken
{
    NSURL *URL = [NSURL URLWithString:@"cydia://"];
    return [[UIApplication sharedApplication] canOpenURL:URL];
}

@end
