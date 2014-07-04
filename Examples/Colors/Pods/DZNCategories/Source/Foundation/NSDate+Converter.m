//
//  NSDate+Converter.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/6/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSDate+Converter.h"
#import "NSDate+Comparison.h"
#import "NSArray+Query.h"
#import "NSString+Time.h"

@implementation NSDate (Converter)

+ (NSDate *)dateFromString:(NSString *)string andFormat:(NSString *)format
{
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:string];
}

- (NSString *)stringFromDateWithFormat:(NSString *)format
{
    NSString *localeIdentifier = [[NSLocale preferredLanguages] firstObject];
    NSLocale *userLocale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    return [self stringFromDateWithFormat:format andLocale:userLocale];
}

- (NSString *)stringFromDateWithFormat:(NSString *)format andLocale:(NSLocale *)locale
{
    if (!self) return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:format];
    
    return [[dateFormatter stringFromDate:self] capitalizedString];
}

- (NSDate *)dateInDays:(NSUInteger)days
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    return [cal dateByAddingComponents:components toDate:self options:0];
}

+ (NSDate *)firstDayFromMonth:(NSUInteger)month andYear:(NSUInteger)year
{
    return [NSDate dateForDay:1 month:month andYear:year];
}

+ (NSDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month andYear:(NSUInteger)year
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[[NSCalendar currentCalendar] calendarIdentifier]];
    return [calendar dateFromComponents:comps];
}

- (NSString *)smartStringDate
{
    if ([self isToday]) return [NSString today];
    if ([self isYesterday]) return  [NSString yesterday];
    
    NSString *localeIdentifier = [[NSLocale preferredLanguages] firstObject];
    NSLocale *userLocale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];

    NSString *conjonction = nil;
    if ([localeIdentifier isEqualToString:@"en"]) conjonction = @"of";
    else if ([localeIdentifier isEqualToString:@"fr"]) conjonction = @"de";
    else if ([localeIdentifier isEqualToString:@"es"]) conjonction = @"de";
    else if ([localeIdentifier isEqualToString:@"de"]) conjonction = @"auf";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:userLocale];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"EEEE d '%@' MMMM", conjonction]];
    
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)localTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDate *)globalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

@end
