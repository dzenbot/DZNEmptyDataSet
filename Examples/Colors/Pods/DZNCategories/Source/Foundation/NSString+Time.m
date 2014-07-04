//
//  NSString+Time.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/17/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSString+Time.h"
#import "NSArray+Query.h"

@implementation NSString (Time)

+ (NSString *)elapsedTime:(NSTimeInterval)time
{
    return [NSString stringWithFormat:@"%02li:%02li:%02li",
            lround(floor(time / 3600.)) % 100,
            lround(floor(time / 60.)) % 60,
            lround(floor(time)) % 60];
}

+ (NSString *)yesterday
{
    NSString *localeIdentifier = [[NSLocale preferredLanguages] firstObject];
    if ([localeIdentifier isEqualToString:@"en"]) return @"yesterday";
    else if ([localeIdentifier isEqualToString:@"fr"]) return @"hier";
    else if ([localeIdentifier isEqualToString:@"es"]) return @"ayer";
    else if ([localeIdentifier isEqualToString:@"de"]) return @"gestern";
    else return @"";
}

+ (NSString *)today
{
    NSString *localeIdentifier = [[NSLocale preferredLanguages] firstObject];
    if ([localeIdentifier isEqualToString:@"en"]) return @"today";
    else if ([localeIdentifier isEqualToString:@"fr"]) return @"aujourd'hui";
    else if ([localeIdentifier isEqualToString:@"es"]) return @"hoy";
    else if ([localeIdentifier isEqualToString:@"de"]) return @"heute";
    else return @"";
}

+ (NSString *)tomorrow
{
    NSString *localeIdentifier = [[NSLocale preferredLanguages] firstObject];
    if ([localeIdentifier isEqualToString:@"en"]) return @"tomorrow";
    else if ([localeIdentifier isEqualToString:@"fr"]) return @"demain";
    else if ([localeIdentifier isEqualToString:@"es"]) return @"mañana";
    else if ([localeIdentifier isEqualToString:@"de"]) return @"morgen";
    else return @"";
}

@end
