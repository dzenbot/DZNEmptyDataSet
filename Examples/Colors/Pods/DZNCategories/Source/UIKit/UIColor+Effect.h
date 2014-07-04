//
//  UIColor+Frame.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
 * Special effects to be applied to UIColor objects.
 */
@interface UIColor (Effect)

/*
 * Returns a darker color version of current color.
 *
 * @returns A darker color.
 */
- (UIColor *)darkerColor;

/*
 * Returns a lighter color version of current color.
 *
 * @returns A light color.
 */
- (UIColor *)lighterColor;

/*
 * Returns a totally random color.
 *
 * @returns A random color.
 */
+ (UIColor *)randomColor;

@end
