//
//  NSString+Regex.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 10/28/11.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 Useful regular expression methods for NSString.
 */
@interface NSString (Regex)

/*
 Checks if the string is a valid email.

 @returns YES if the string is a valid email.
*/
- (BOOL)isValidEmail;

/*
 Checks if the string is a valid URL.

 @returns YES if the string is a valid URL.
*/
- (BOOL)isValidUrl;

/*
 Checks if the string is numeric.

 @returns YES if the string is numeric.
*/
- (BOOL)isNumeric;

/*

*/
- (BOOL)isValidFloat;

/*
 
*/
- (BOOL)isBackSpace;

/*

*/
- (BOOL)containsString:(NSString *)substring;

/*
 Returns an array of strings contained between 2 strings.
 Based Si's answer on StackOverflow http://stackoverflow.com/a/9227750/590010
*/
- (NSMutableArray *)stringsBetweenString:(NSString *)start andString:(NSString *)end;

@end
