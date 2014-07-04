//
//  NSString+Safe.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 12/5/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

@interface NSString (Safe)

- (NSString *)safeStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;

@end
