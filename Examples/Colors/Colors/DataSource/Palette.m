//
//  ColorSource.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "Palette.h"

@interface Palette ()
@end

static Palette *_sharedPalette = nil;

@implementation Palette
@synthesize colors = _colors;

+ (instancetype)sharedPalette
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPalette = [[Palette alloc] init];
        [_sharedPalette loadColors];
    });
    return _sharedPalette;
}

- (void)loadColors
{
    // A list of crayola colors in JSON by Jjdelc https://gist.github.com/jjdelc/1868136
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *objects = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];
        
    _colors = [[NSMutableArray alloc] initWithCapacity:objects.count];
    
    for (NSDictionary *dictionary in objects) {
        Color *color = [[Color alloc] initWithDictionary:dictionary];
        [_colors addObject:color];
    }
}

- (void)reloadAll
{
    [self removeAll];
    [self loadColors];
}

- (void)removeColor:(Color *)color
{
    NSInteger idx = [_colors indexOfObject:color];
    
    if (idx >= 0 && idx < _colors.count) {
        [_colors removeObjectAtIndex:idx];
    }
}

- (void)removeAll
{
    [_colors removeAllObjects];
    _colors = nil;
}

@end
