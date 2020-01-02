//
//  UIColor+Hex.m
//  Colors
//
//  Created by Ignacio Romero on 4/26/16.
//  Copyright © 2016 DZN Labs. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorFromHex:(NSString *)hex
{
    return [self colorFromHex:hex alpha:1.0];
}

+ (UIColor *)colorFromHex:(NSString *)hex alpha:(CGFloat)alpha
{
    NSUInteger offset = 0;
    
    if ([hex hasPrefix:@"#"]) {
        offset = 1;
    }
    
    NSString *string = [hex substringFromIndex:offset];
    
    if (string.length == 3) {
        string = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                  [string substringWithRange:NSMakeRange(0, 1)],
                  [string substringWithRange:NSMakeRange(0, 1)],
                  [string substringWithRange:NSMakeRange(1, 1)],
                  [string substringWithRange:NSMakeRange(1, 1)],
                  [string substringWithRange:NSMakeRange(2, 1)],
                  [string substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if (string.length == 6) {
        string = [string stringByAppendingString:@"ff"];
    }
    
    if (string == nil) {
        return nil;
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:string] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
