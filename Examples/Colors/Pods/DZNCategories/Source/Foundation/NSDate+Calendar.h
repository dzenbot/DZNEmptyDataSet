//
//  NSDate+Calendar.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/15/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)

+ (NSCalendar *)userCalendar;

+ (NSUInteger)fullCalendarComponents;
+ (NSUInteger)dayCalendarComponents;

+ (NSDate *)today;
+ (NSDate *)todayByComponents:(NSUInteger)comp;

+ (NSDate *)yesterday;
+ (NSDate *)yesterdayByComponents:(NSUInteger)comp;

- (NSInteger)weekdayUnit;

@end
