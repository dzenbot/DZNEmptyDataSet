//
//  ColorPalette.h
//  Colors
//
//  Created by Ignacio Romero Z. on 7/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorPalette : NSObject

@property (nonatomic, readonly) NSMutableArray *colors;
@property (nonatomic) NSUInteger lenght;

+ (instancetype)sharedPalette;

- (void)reloadColors;
- (void)removeColor:(UIColor *)color;
- (void)removeAllColors;

@end
