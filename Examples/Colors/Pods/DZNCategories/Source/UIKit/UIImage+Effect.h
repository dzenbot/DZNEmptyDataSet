//
//  UIImage+Effect.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
 * Special effects to be applied to UIImage objects.
 */
@interface UIImage (Effect)

/*
 */
- (UIImage *)imageWithMask:(UIImage *)maskImg;

/*
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/*
 */
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/*
 */
- (UIImage *)coloredImage:(UIColor *)color;

/*
 * Transforms the image to grayscale.
 *
 * @returns The new grayscale image.
 */
- (UIImage *)imageToGrayscale;

/*
 */
- (UIImage *)circular;

/*
 */
- (UIImage *)circularWithBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width;

/*
 */
- (UIImage *)circularWithOutterBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width;


@end
