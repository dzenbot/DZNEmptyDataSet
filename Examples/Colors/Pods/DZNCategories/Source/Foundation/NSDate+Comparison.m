//
//  NSDate+Comparison.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/12/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MITs
//

#import "NSDate+Comparison.h"
#import "NSDate+Converter.h"
#import "NSDate+Calendar.h"

@implementation NSDate (Comparison)

- (BOOL)isToday
{
    NSCalendar *cal = [NSDate userCalendar];
    NSDate *today = [NSDate today];
    
    NSDateComponents *components = [cal components:[NSDate dayCalendarComponents] fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];

    return ([today compare:otherDate] == NSOrderedSame);
}

- (BOOL)isYesterday
{
    NSCalendar *cal = [NSDate userCalendar];
    NSDate *yesterday = [NSDate yesterday];
    
    NSDateComponents *components = [cal components:[NSDate dayCalendarComponents] fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return ([yesterday compare:otherDate] == NSOrderedSame);
}

- (BOOL)isFirstDayOfMonth
{
    NSCalendar *cal = [NSDate userCalendar];
    
    NSDateComponents *components = [cal components:[NSDate dayCalendarComponents] fromDate:self];
    [components setDay:1];
    NSDate *firstDayOfMonthDate = [cal dateFromComponents:components];
    
    components = [cal components:[NSDate dayCalendarComponents] fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return ([firstDayOfMonthDate compare:otherDate] == NSOrderedSame);
}

- (BOOL)hasSameUnit:(unsigned)unitFlags thanDate:(NSDate *)date
{
    if (unitFlags == NSMinuteCalendarUnit) {
        NSString *selfMinute = [self stringFromDateWithFormat:kNSDateFormatShortTime];
        NSString *comparingMinute = [date stringFromDateWithFormat:kNSDateFormatShortTime];
        if ([selfMinute isEqualToString:comparingMinute]) return YES;
    }
    return NO;
}

@end
