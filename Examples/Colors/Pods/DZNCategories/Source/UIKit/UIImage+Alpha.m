//
//  UIImage+Alpha.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIImage+Alpha.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Alpha)

- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

- (UIImage *)removeAlpha
{
    if (![self hasAlpha]) return self;
    
    CGImageRef imageRef = [self CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height, 8, 0, colorSpace, bitmapInfo);
	CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
	CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	UIImage *returnImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
	CGImageRelease(mainViewContentBitmapContext);
    
    return returnImage;
}

- (UIImage *)fillAlpha
{
	return [self fillAlphaWithColor:[UIColor whiteColor]];
}

- (UIImage *)fillAlphaWithColor:(UIColor *)color
{
    if (![self hasAlpha]) return self;
    
    CGRect im_r;
	im_r.origin = CGPointZero;
	im_r.size = self.size;
    
    CGColorRef cgColor = [color CGColor];
    
    UIGraphicsBeginImageContextWithOptions(self.size,NO,0.0);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, cgColor);
    CGContextFillRect(context,im_r);
    [self drawInRect:im_r];
    
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return returnImage;
}

@end
