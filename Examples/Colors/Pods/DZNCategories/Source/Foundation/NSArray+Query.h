//
//  NSArray+Query.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 Useful methods to ease NSArray queries.
 */
@interface NSArray (Query)

/*
 Returns the lastest object's index in the array.
 
 @returns The last object's index in the array.
*/
- (NSUInteger)lastObjectIndex;


/*
 Returns a reversed array.
 
 @returns A reversed array.
*/
- (NSArray *)reversedArray;

@end
