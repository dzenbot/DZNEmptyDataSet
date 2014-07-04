//
//  NSString+Path.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/4/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSString+Path.h"

@implementation NSString (Path)

+ (NSString *)getMainBundlePathForFile:(NSString *)fileName
{
    return [NSString getBundlePath:[NSBundle mainBundle] forFile:fileName];
}

+ (NSString *)getBundlePath:(NSBundle *)bundle forFile:(NSString *)fileName
{
    NSString *fileExtension = [fileName pathExtension];
    return [bundle pathForResource:[fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",fileExtension] withString:@""] ofType:fileExtension];
}

+ (NSString *)getDocumentsDirectoryPathForFile:(NSString *)fileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",fileName]];
}

+ (NSString *)getLibraryDirectoryPathForFile:(NSString *)fileName
{
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",fileName]];
}

+ (NSString *)getCacheDirectoryPathForFile:(NSString *)fileName
{
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",fileName]];
}

@end
