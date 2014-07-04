//
//  NSUserDefaults+Custom.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 10/28/11.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 A category class for serializing and deserializing custom objects.
 */
@interface NSUserDefaults (Custom)

/*
 Adds a given custom object key-value pair to the NSUserDefaults.

 @param anObject The custm object value.
 @param aKey The key for value.
 */
- (void)setCustomObject:(id)anObject forKey:(NSString *)aKey;

/*
 Returns a custom object value associated with a given key from the NSUserDefaults.
 
 @param aKey The key for which to return the corresponding value.
 @returns The value associated with aKey.
 */
- (id)customObjectForKey:(NSString *)aKey;

@end
