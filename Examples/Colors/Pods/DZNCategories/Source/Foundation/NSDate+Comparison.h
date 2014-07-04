//
//  NSDate+Comparison.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/12/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 Useful methods for comparing dates.
*/
@interface NSDate (Comparison)

/**
 
*/
- (BOOL)isToday;

/**
 
 */
- (BOOL)isYesterday;

/**
 
 */
- (BOOL)isFirstDayOfMonth;

/**
 
 */
- (BOOL)hasSameUnit:(unsigned)unitFlags thanDate:(NSDate *)date;

@end
