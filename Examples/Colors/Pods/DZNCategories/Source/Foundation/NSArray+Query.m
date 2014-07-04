//
//  NSArray+Query.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSArray+Query.h"

@implementation NSArray (Query)

- (NSUInteger)lastObjectIndex
{
    return [self indexOfObject:[self lastObject]];
}

- (NSArray *)reversedArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    
    for (id element in enumerator) [array addObject:element];
    
    return array;
}

@end
