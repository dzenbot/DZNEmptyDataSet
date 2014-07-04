//
//  NSMutableDictionary+Safe.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/8/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)

- (id)safeObjectForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]] || !object) return nil;
    else return object;
}

- (void)setSafeObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (!anObject) [self setObject:[NSNull new] forKey:aKey];
    else [self setObject:anObject forKey:aKey];
}

@end
