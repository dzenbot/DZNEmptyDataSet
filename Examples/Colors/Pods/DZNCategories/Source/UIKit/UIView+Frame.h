//
//  UIView+Frame.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 10/28/11.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
 * Useful methods to simplify the way to modify a rectangle.
 */
@interface UIView (Frame)

/*
 * Sets the rectangle's size, respecting the origin values it already has.
 *
 * @param newSize The new size to be applied.
 */
- (void)setFrameSize:(CGSize)newSize;

/*
 * Sets the rectangle's width, respecting the other values it already has.
 *
 * @param newWidth The new width to be applied.
 */
- (void)setFrameWidth:(CGFloat)newWidth;

/*
 * Sets the rectangle's height, respecting the other values it already has.
 *
 * @param newHeight The new height to be applied.
 */
- (void)setFrameHeight:(CGFloat)newHeight;

/*
 * Sets the rectangle's origin, respecting the size values it already has.
 *
 * @param newOrigin The new origin to be applied.
 */
- (void)setFrameOrigin:(CGPoint)newOrigin;

/*
 * Sets the rectangle's horizontal origin, respecting the other values it already has.
 *
 * @param newX The new horizontal origin to be applied.
 */
- (void)setFrameOriginX:(CGFloat)newX;

/*
 * Sets the rectangle's vertical origin, respecting the other values it already has.
 *
 * @param newX The new vertical origin to be applied.
 */
- (void)setFrameOriginY:(CGFloat)newY;

/*
 * Adds a value to the rectangle's existent width size.
 * Works also with negative values.
 *
 * @param newWidth The new width value to be added.
 */
- (void)addSizeWidth:(CGFloat)newWidth;

/*
 * Adds a value to the rectangle's existent vertical size.
 * Works also with negative values.
 *
 * @param newHeight The new height value to be added.
 */
- (void)addSizeHeight:(CGFloat)newHeight;

/*
 * Adds a value to the rectangle's existent horizontal origin.
 * Works also with negative values.
 *
 * @param newX The new horizontal value to be added.
 */
- (void)addOriginX:(CGFloat)newX;

/*
 * Adds a value to the rectangle's existent vertical origin.
 * Works also with negative values.
 *
 * @param newY The new vertical value to be added.
 */
- (void)addOriginY:(CGFloat)newY;

@end
