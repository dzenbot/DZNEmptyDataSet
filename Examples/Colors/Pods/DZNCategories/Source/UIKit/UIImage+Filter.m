//
//  UIImage+Filter.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 9/27/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIImage+Filter.h"

#define kCIGaussianBlur @"CIGaussianBlur"
#define kCIInputBOOLKey @"kCIInputBOOLKey"

@implementation UIImage (Filter)

- (UIImage *)applyFilter:(NSString *)filterName withAttributes:(NSDictionary *)attributes
{
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CGImageRef cgImage = nil;
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    if ([filterName isEqualToString:kCIGaussianBlur]) {
        NSNumber *radius = [attributes objectForKey:@"inputRadius"];
        [filter setValue:radius forKey:@"inputRadius"];
        
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
        
        CGRect rect = [inputImage extent];
        BOOL blurredEdges = [[attributes objectForKey:kCIInputBOOLKey] boolValue];
        
        if (!blurredEdges) {
            rect.size.width -= [radius integerValue]*2;
            rect.size.height -= [radius integerValue]*2;
            rect.origin = CGPointMake([radius integerValue],[radius integerValue]);
        }
        
        cgImage = [context createCGImage:result fromRect:rect];
    }
    
    //return the newly blurred image
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return filteredImage;
}

- (UIImage *)filterGlaussianBlurWithRadius:(CGFloat)radius
{
    return [self filterGlaussianBlurWithRadius:radius andBlurredEdges:NO];
}

- (UIImage *)filterGlaussianBlurWithRadius:(CGFloat)radius andBlurredEdges:(BOOL)edges
{
    return [self applyFilter:kCIGaussianBlur withAttributes:@{@"inputRadius": [NSNumber numberWithFloat:radius], kCIInputBOOLKey: [NSNumber numberWithBool:edges]}];
}

@end
