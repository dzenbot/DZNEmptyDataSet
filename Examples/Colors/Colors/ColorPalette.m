//
//  ColorPalette.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "ColorPalette.h"
#import "UIColor+Random.h"

@interface ColorPalette ()
@end

static ColorPalette *_sharedPalette = nil;

@implementation ColorPalette
@synthesize colors = _colors;

+ (instancetype)sharedPalette
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPalette = [[ColorPalette alloc] init];
        _sharedPalette.lenght = 100;
        
        [_sharedPalette loadColors];
    });
    return _sharedPalette;
}

- (void)loadColors
{
    _colors = [[NSMutableArray alloc] initWithCapacity:self.lenght];
    
    for (int i = 0; i < self.lenght; i++) {
        UIColor *color = [UIColor randomColor];
        [_colors addObject:color];
    }
}

- (void)reloadColors
{
    [self removeAllColors];
    [self loadColors];
}

- (void)removeColor:(UIColor *)color
{
    NSInteger idx = [_colors indexOfObject:color];
    
    if (idx >= 0 && idx < _colors.count) {
        [_colors removeObjectAtIndex:idx];
    }
}

- (void)removeAllColors;
{
    [_colors removeAllObjects];
    _colors = nil;
}

@end
