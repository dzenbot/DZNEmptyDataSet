//
//  Palette.h
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Color : NSObject

@property (nonatomic, strong) NSString *hex;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *rgb;

@property (nonatomic, weak) UIColor *color;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (UIImage *)roundThumbWithColor:(UIColor *)color;
+ (UIImage *)roundImageForSize:(CGSize)size withColor:(UIColor *)color;

@end
