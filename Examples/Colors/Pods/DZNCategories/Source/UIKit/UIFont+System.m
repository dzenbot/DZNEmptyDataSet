//
//  UIFont+System.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIFont+System.h"
#import <CoreText/CoreText.h>

@implementation UIFont (System)

+ (UIFont *)boldItalicSystemFontOfSize:(CGFloat)size {

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:size];
    }
    else {
        return [UIFont fontWithName:@"Helvetica-BoldOblique" size:size];
    }
}

+ (UIFont *)mediumSystemFontOfSize:(CGFloat)size {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
    }
    else {
        return nil;
    }
}

+ (UIFont *)lightSystemFontOfSize:(CGFloat)size {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    }
    else {
        return [UIFont fontWithName:@"Helvetica-Light" size:size];
    }
}

+ (UIFont *)lightItalicSystemFontOfSize:(CGFloat)size {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:size];
    }
    else {
        return [UIFont fontWithName:@"Helvetica-LightOblique" size:size];
    }
}

+ (UIFont *)ultraLightSystemFontOfSize:(CGFloat)size {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
    }
    else {
        return nil;
    }
}

+ (UIFont *)thinSystemFontOfSize:(CGFloat)size {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
    }
    else {
        return nil;
    }
}

+ (UIFont *)loadFontWithName:(NSString *)fontName size:(CGFloat)size {
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf"];
    CFErrorRef error;
    CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
    error = nil;
    return [UIFont fontWithName:fontName size:size];
}

@end
