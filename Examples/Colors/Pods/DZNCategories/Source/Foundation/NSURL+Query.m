//
//  NSURL+Query.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/19/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSURL+Query.h"
#import "NSArray+Query.h"
#import "NSArray+Safe.h"

@implementation NSURL (Query)

- (BOOL)hasScheme
{
    return ([self scheme]) ? YES : NO;
}

- (NSString *)noun
{
    for (NSString *pair in [self pairs]) {
        NSArray *elements = [pair componentsSeparatedByString:@"/"];
        return [elements safeObjectAtIndex:0];
    }
    return nil;
}

- (NSString *)verb
{
    for (NSString *pair in [self pairs]) {
        NSArray *elements = [pair componentsSeparatedByString:@"/"];
        return [elements safeObjectAtIndex:1];
    }
    return nil;
}

- (NSArray *)pairs
{
    NSString *body = [[self absoluteString] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",[self scheme]] withString:@""];
    return [body componentsSeparatedByString:@"?"];
}

- (NSDictionary *)parametersString
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements safeObjectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements safeObjectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
