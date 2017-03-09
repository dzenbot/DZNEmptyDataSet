//
//  Palette.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "Color.h"
#import "UIColor+Hex.h"

@implementation Color

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.hex = [dict objectForKey:@"hex"];
        self.name = [dict objectForKey:@"name"];
        self.rgb = [dict objectForKey:@"rgb"];
    }
    return self;
}

- (UIColor *)color
{
    return [UIColor colorFromHex:self.hex];
}

+ (UIImage *)roundThumbWithColor:(UIColor *)color
{
    return [self roundImageForSize:CGSizeMake(32.0, 32.0) withColor:color];
}

+ (UIImage *)roundImageForSize:(CGSize)size withColor:(UIColor *)color
{
    if (!color) {
        return nil;
    }
    
    // Constants
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    
    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:bounds];
    [color setFill];
    [ovalPath fill];
    
    //Create the image using the current context.
    UIImage *_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _image;
}

@end
