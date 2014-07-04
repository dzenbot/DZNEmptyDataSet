//
//  NSString+Drawing.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 11/16/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSString+Drawing.h"

@implementation NSString (Drawing)

- (NSInteger)numberOfLinesWithinSize:(CGSize)size withFont:(UIFont *)font
{
    return (NSInteger)size.height/font.lineHeight;
}

- (NSInteger)numberOfLineBreaks
{
    NSInteger numberOfBreaks = [self componentsSeparatedByString:@"\n"].count;
    if (numberOfBreaks > 1) return numberOfBreaks-1;
    else return 0;
}

- (NSUInteger)visibleStringLengthWithinSize:(CGSize)size withFont:(UIFont *)font andParagraphStyle:(NSParagraphStyle *)style
{
    return [self visibleStringWithinSize:size withFont:font andParagraphStyle:style].length;
}

- (NSString *)visibleStringWithinSize:(CGSize)size withFont:(UIFont *)font andParagraphStyle:(NSParagraphStyle *)style
{
    NSAssert(!CGSizeEqualToSize(size, CGSizeZero), @"Containment size cannot be zero");
    NSAssert(font != nil, @"Label font cannot be nil");
    NSAssert(style != nil, @"Label style cannot be nil");
    
    CGSize sizeConstraint = CGSizeMake(size.width, CGFLOAT_MAX);

    NSDictionary *att = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading);
    
    CGRect textRect = [self boundingRectWithSize:sizeConstraint options:options attributes:att context:nil];
    
    if (textRect.size.height > size.height) {
        
        for (int i = 1; i < [self length]; i++) {
            
            NSString *reducedString = [self substringToIndex:i];
            CGRect reducedRect = [reducedString boundingRectWithSize:sizeConstraint options:options attributes:att context:nil];
            
            if (reducedRect.size.height > size.height) {
                
                return [self substringToIndex:i-1];
            }
        }
    }
    
    return self;
}

@end
