//
//  UIColor+System.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 12/26/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
 * Complementary methods to add iOS7 system colors.
 * Based on color palette defined in http://ios7colors.com/
 */
@interface UIColor (System)

/*
 * Returns the system blue color.
 *
 * @returns A system blue color.
 */
+ (UIColor *)systemBlueColor;

/*
 * Returns the system red color.
 *
 * @returns A system red color.
 */
+ (UIColor *)systemRedColor;

/*
 * Returns the system green color.
 *
 * @returns A system green color.
 */
+ (UIColor *)systemGreenColor;

/*
 * Returns the system grey color.
 *
 * @returns A system grey color.
 */
+ (UIColor *)systemGreyColor;

@end
