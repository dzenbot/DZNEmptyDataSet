//
//  UIImage+Alpha.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
 * Set of methods to manage alpha channels in UIImage objects.
 */
@interface UIImage (Alpha)

/*
 * Checks if the image as an alpha channel.
 */
- (BOOL)hasAlpha;

/*
 * Removes the alpha channel completly.
 *
 * @returns A new non-transparent image.
 */
- (UIImage *)removeAlpha;

/*
 * Fills the alpha channel with white color.
 *
 * @returns A new alpha-filled image.
 */
- (UIImage *)fillAlpha;

/*
 * Fills the alpha channel with a custom color.
 *
 * @param color The custom color of the alpha channel
 * @returns A new alpha-filled image.
 */
- (UIImage *)fillAlphaWithColor:(UIColor *)color;

@end
