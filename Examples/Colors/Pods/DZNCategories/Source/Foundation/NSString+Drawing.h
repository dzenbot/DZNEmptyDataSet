//
//  NSString+Drawing.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 11/16/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (Drawing)

- (NSInteger)numberOfLinesWithinSize:(CGSize)size withFont:(UIFont *)font;

- (NSInteger)numberOfLineBreaks;

- (NSUInteger)visibleStringLengthWithinSize:(CGSize)size withFont:(UIFont *)font andParagraphStyle:(NSParagraphStyle *)style;

- (NSString *)visibleStringWithinSize:(CGSize)size withFont:(UIFont *)font andParagraphStyle:(NSParagraphStyle *)style;

@end
