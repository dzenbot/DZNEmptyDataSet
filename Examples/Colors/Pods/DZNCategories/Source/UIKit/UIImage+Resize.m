//
//  UIImage+Resize.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Resize)

- (UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}

- (UIImage *)imageScaledFittingToSize:(CGSize)size
{
    UIImage *sourceImage = self;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat height = 0;
    if (imageSize.width > size.width) {
        height = imageSize.height / (imageSize.width / size.width);
    }
    else {
        height = imageSize.height * (imageSize.width / size.width);
    }
    
    CGSize aspectSize = CGSizeMake(size.width, height);
    
    return [self imageByScalingProportionallyToSize:aspectSize];
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)size
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor) scaleFactor = widthFactor;
        else scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor < heightFactor) thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        else if (widthFactor > heightFactor) thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (!newImage) NSLog(@"could not scale image");
    
    return newImage;
}

- (BOOL)isProportionalToSize:(CGSize)size
{
    CGSize imageSize = self.size;
    
    CGFloat factor = 0;
    if (imageSize.width > size.width)
    {
        factor = imageSize.width / size.width;
        
        if (size.height == imageSize.height / factor) {
            return YES;
        }
        else return NO;
    }
    else
    {
        factor = size.width / imageSize.width;
        
        if (size.height == imageSize.height * factor) {
            return YES;
        }
        else return NO;
    }
}

@end
