//
//  NSMutableDictionary+Safe.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/8/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 Safe methods for saving and retrieving data from a NSMutableDictionary.
*/
@interface NSMutableDictionary (Safe)

/*
 Returns the none-nil value associated with a given key.

 @param aKey The key for which to return the corresponding value.
 @returns The none-nil value associated with aKey.
*/
- (id)safeObjectForKey:(id)aKey;

/*
 Adds a given safe key-value pair to the dictionary.

 @param anObject The none-nil value for aKey. A strong reference to the object is maintained by the dictionary. Raises an NSInvalidArgumentException if anObject is nil. If the value is nil value, sets automatically a NSNull reference instead.
 @param aKey The key for value. The key is copied (using copyWithZone:; keys must conform to the NSCopying protocol). Raises an NSInvalidArgumentException if aKey is nil. If aKey already exists in the dictionary anObject takes its place.
*/
- (void)setSafeObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end
