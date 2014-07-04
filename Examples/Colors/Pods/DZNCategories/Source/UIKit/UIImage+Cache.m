//
//  UIImage+Cache.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 5/28/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIImage+Cache.h"
#import "UIColor+Hex.h"
#import "UIImage+Effect.h"

static NSString *kCacheFolderName = @"com.dzn.UIImageCache.default";

@implementation UIImage (Cache)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color
{
    BOOL directory;
    NSError *error = nil;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachedImagesDirectory = [cacheDirectory stringByAppendingPathComponent:kCacheFolderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachedImagesDirectory isDirectory:&directory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachedImagesDirectory withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) NSLog(@"contentsOfDirectoryAtPath error : %@",error.localizedDescription);
    }
    
    NSString *hex = [color hexFromColor];
    NSString *path = [cachedImagesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",name,hex]];
    if (scale == 2.0) path = [path stringByAppendingString:@"@2x"];
    
    path = [path stringByAppendingString:@".png"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage *image = [[UIImage imageNamed:name] coloredImage:color];
        [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
        return image;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data scale:scale];
}

+ (void)clearCachedImages
{
    NSError *error = nil;
    
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachedImagesDirectory = [cacheDirectory stringByAppendingPathComponent:kCacheFolderName];
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachedImagesDirectory error:&error];
    if (error) {
        NSLog(@"%s contentsOfDirectoryAtPath error : %@",__FUNCTION__, error.localizedDescription);
        return;
    }
    
    for (NSString *filePath in contents) {
        
        NSString *path = [cachedImagesDirectory stringByAppendingPathComponent:filePath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if (error) NSLog(@"removeItemAtPath error : %@",error.localizedDescription);
            else NSLog(@"removed Item At Path : %@",path);
        }
    }
}

@end
