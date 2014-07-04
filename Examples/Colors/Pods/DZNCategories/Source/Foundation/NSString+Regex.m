//
//  NSString+Regex.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 10/28/11.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSString+Regex.h"
#include <sys/utsname.h>

@implementation NSString (Regex)

- (BOOL)isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [emailTest evaluateWithObject:self];
}

//- (BOOL)isNumeric
//{
//    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
//    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:self];
//    return [alphaNumbersSet isSupersetOfSet:stringSet];
//}

- (BOOL)isValidUrl
{
    NSString *regex = @"(http|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
//    NSString *regex = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    return ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound);
}

- (BOOL)isNumeric
{
    BOOL isValid = YES;
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"_!@#$%^&*()[]{}'\"<>:;|\\/?+=~`"];
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        if ([myCharSet characterIsMember:c])
            isValid = NO;
    }
    return isValid;
}

- (BOOL)isValidFloat
{
    NSString *regex = @"([-+]?[0-9]*\\.?[0-9]*)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isBackSpace
{
    return ([self isEqualToString:@""] && self.length == 1) ? YES : NO;
}

- (BOOL)containsString:(NSString *)substring
{
    NSRange range = [self rangeOfString:substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}

- (NSMutableArray *)stringsBetweenString:(NSString *)start andString:(NSString *)end
{
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:0];
    NSRange startRange = [self rangeOfString:start];
    
    for ( ;; ) {
        
        if (startRange.location != NSNotFound) {
            NSRange targetRange;
            
            targetRange.location = startRange.location + startRange.length;
            targetRange.length = [self length] - targetRange.location;
            
            NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
            
            if (endRange.location != NSNotFound) {
                
                targetRange.length = endRange.location - targetRange.location;
                [strings addObject:[self substringWithRange:targetRange]];
                
                NSRange restOfString;
                
                restOfString.location = endRange.location + endRange.length;
                restOfString.length = [self length] - restOfString.location;
                
                startRange = [self rangeOfString:start options:0 range:restOfString];
                
            }
            else {
                break;
            }
        }
        else {
            break;
        }
    }
    return strings;
}

@end
