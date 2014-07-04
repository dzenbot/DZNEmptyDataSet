//
//  NSString+Safe.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 12/5/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSString+Safe.h"

@implementation NSString (Safe)

- (NSString *)safeStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    if (target != nil && replacement != nil) {
        return [self stringByReplacingOccurrencesOfString:target withString:replacement];
    }
    else {
        return nil;
    }
}

@end
