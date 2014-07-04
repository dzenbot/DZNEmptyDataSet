//
//  NSURL+Query.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/19/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 * Useful methods to ease NSArray queries.
 */
@interface NSURL (Query)

/*
 *
 */
- (BOOL)hasScheme;

/*
 *
 */
- (NSString *)noun;

/*
 *
 */
- (NSString *)verb;

/*
 *
 */
- (NSDictionary *)parametersString;

@end
