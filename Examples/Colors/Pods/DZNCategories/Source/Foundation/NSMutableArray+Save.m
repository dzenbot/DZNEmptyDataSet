//
//  NSMutableArray+Save.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/4/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSMutableArray+Save.h"
#import "NSString+Path.h"

@implementation NSMutableArray (Save)

- (void)saveArrayToFile:(NSString *)filename
{
    NSString *path = [NSString getLibraryDirectoryPathForFile:[NSString stringWithFormat:@"%@.plist",filename]];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (NSMutableArray *)loadArrayfromFile:(NSString *)fileName
{
    NSString *path = [NSString getLibraryDirectoryPathForFile:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSLog(@"path : %@", path);
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
