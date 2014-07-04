//
//  NSDate+Converter.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/6/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

static NSString *const kNSDateFormatStandard = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";

static NSString *const kNSDateFormatDateLarge = @"EEE MMM dd HH:mm:ss Z yyyy";
static NSString *const kNSDateFormatDateFull = @"yyyy-MM-dd'T'HH:mm:ss";
static NSString *const kNSDateFormatDate = @"yyyy-MM-dd";
static NSString *const kNSDateFormatMonthAndYear = @"MMMM yyyy";
static NSString *const kNSDateFormatTime = @"HH:mm:ss";
static NSString *const kNSDateFormatShortTime = @"HH:mm";
static NSString *const kNSDateFormatShortDate = @"MMMM d";
static NSString *const kNSDateFormatShortDay = @"EEE d";

/*
 Useful methods for converting dates from/to string.
*/
@interface NSDate (Converter)

/*
 Returns a date object from string and specified format.

 @param string The string date.
 @param format The date format string.
 @returns A new date from string and format.
*/
+ (NSDate *)dateFromString:(NSString *)string andFormat:(NSString *)format;

/*
 Returns a string from a date object with a specified format and current user's locale.

 @param format The date format string.
 @returns A string from date.
*/
- (NSString *)stringFromDateWithFormat:(NSString *)format;

/*
 Returns a string from a date object with a specified format and locale.

 @param format The date format string.
 @param locale The specified locale.
 @returns A string from date.
*/
- (NSString *)stringFromDateWithFormat:(NSString *)format andLocale:(NSLocale *)locale;

/*
 *
 */
- (NSString *)smartStringDate;

/*
 *
 */
- (NSDate *)dateInDays:(NSUInteger)days;

/*
 *
 */
+ (NSDate *)firstDayFromMonth:(NSUInteger)month andYear:(NSUInteger)year;

/*
 *
 */
+ (NSDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month andYear:(NSUInteger)year;

/*
 *
 */
- (NSDate *)localTime;

/*
 *
 */
- (NSDate *)globalTime;

@end
