//
//  Palette.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "Color.h"
#import <DZNCategories/UIKit/UIColor+Hex.h>

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

@end
