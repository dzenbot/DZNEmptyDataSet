//
//  UIFont+System.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
Complementary methods to add missing system fonts to UIFont API.
 */
@interface UIFont (System)

/*
 * Returns the font object used for standard interface items that are rendered in boldface and italic type in the specified size.
 *
 * @param size The size (in points) to which the font is scaled. This value must be greater than 0.0.
 * @returns A font object of the specified size.
 */
+ (UIFont *)boldItalicSystemFontOfSize:(CGFloat)size;

/*
 * Returns the font object used for standard interface items that are rendered in medium boldface type in the specified size.
 *
 * @param size The size (in points) to which the font is scaled. This value must be greater than 0.0.
 * @returns A font object of the specified size.
 */
+ (UIFont *)mediumSystemFontOfSize:(CGFloat)size;

/*
 * Returns the font object used for standard interface items that are rendered in lightface type in the specified size.
 *
 * @param size The size (in points) to which the font is scaled. This value must be greater than 0.0.
 * @returns A font object of the specified size.
 */
+ (UIFont *)lightSystemFontOfSize:(CGFloat)size;

/*
 * Returns the font object used for standard interface items that are rendered in lightface & italic type in the specified size.
 *
 * @param size The size (in points) to which the font is scaled. This value must be greater than 0.0.
 * @returns A font object of the specified size.
 */
+ (UIFont *)lightItalicSystemFontOfSize:(CGFloat)size;

/*
 * Returns the font object used for standard interface items that are rendered in ultra lightface type in the specified size.
 *
 * @param size The size (in points) to which the font is scaled. This value must be greater than 0.0.
 * @returns A font object of the specified size.
 */
+ (UIFont *)ultraLightSystemFontOfSize:(CGFloat)size;

/*
 * Returns the font object used for standard interface items that are rendered in thinface type in the specified size.
 *
 * @param size The size (in points) to which the font is scaled. This value must be greater than 0.0.
 * @returns A font object of the specified size.
 */
+ (UIFont *)thinSystemFontOfSize:(CGFloat)size;

/*
 * Returns an unloaded font with size.
 *
 * @param size The size (in points) to which the font is scaled. This value must be greater than 0.0.
 * @returns A font object of the specified size.
 */
+ (UIFont *)loadFontWithName:(NSString *)fontName size:(CGFloat)size;

@end