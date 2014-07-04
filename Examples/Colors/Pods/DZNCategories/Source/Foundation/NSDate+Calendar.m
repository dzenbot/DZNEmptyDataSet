//
//  NSDate+Calendar.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/15/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import "NSDate+Calendar.h"

@implementation NSDate (Calendar)

+ (NSCalendar *)userCalendar
{
    return [[NSCalendar alloc] initWithCalendarIdentifier:[[NSCalendar currentCalendar] calendarIdentifier]];
}

+ (NSUInteger)fullCalendarComponents
{
    return (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
}

+ (NSUInteger)dayCalendarComponents
{
    return (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
}

+ (NSDate *)today
{
    return [NSDate todayByComponents:[NSDate dayCalendarComponents]];
}

+ (NSDate *)todayByComponents:(NSUInteger)comp
{
    NSCalendar *cal = [NSDate userCalendar];
    NSDateComponents *components = [cal components:comp fromDate:[NSDate date]];
    return [cal dateFromComponents:components];
}

+ (NSDate *)yesterday
{
    return [NSDate yesterdayByComponents:[NSDate dayCalendarComponents]];
}

+ (NSDate *)yesterdayByComponents:(NSUInteger)comp
{
    NSCalendar *cal = [NSDate userCalendar];
    NSDate *today = [NSDate today];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    return [cal dateByAddingComponents:components toDate:today options:0];
}

- (NSInteger)weekdayUnit
{
    NSDateComponents *weekdayComponents = [[NSDate userCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    return [weekdayComponents weekday];
}

@end
