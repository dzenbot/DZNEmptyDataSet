//
//  NSArray+Safe.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/19/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Safe methods for saving and retrieving data from a NSArray.
 */
@interface NSArray (Safe)

/*
 Returns a value associated with a given index, safely without exceeding bounds.

 @param index An index within the bounds of the array.
 @returns Returns the object located at index.
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

@end
