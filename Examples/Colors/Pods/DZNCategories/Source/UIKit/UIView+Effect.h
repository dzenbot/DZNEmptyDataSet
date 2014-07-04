//
//  UIView+Effect.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/22/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/*
 * Special effects to be applied to UIView objects.
 */
@interface UIView (Effect)

/*
 * Adds rounded corners to the specified radius.
 *
 * @param radius The value of the corner radius.
 */
- (void)addCornerRadius:(CGFloat)radius;

/*
 * Adds rounded corners to the specified radius.
 *
 * @param radius The value of the corner radius.
 * @param corners The corners to be rounded up.
 */
- (void)addCornerRadius:(CGFloat)radius forCorners:(UIRectCorner)corners;

/*
 * Adds borders for any object that Inherits from UIView.
 *
 * @param color The color of the border.
 * @param radius The angle of the border.
 * @param width The tickness of the border.
 */
- (void)addBorderWithColor:(UIColor *)color cornerRadius:(CGFloat)radius andWidth:(CGFloat)width;

/*
 * Removes the border for any object that Inherits from UIView.
 */
- (void)removeBorders;

/*
 * Adds a shadow based on the attributes of an NSShadow object.
 *
 * @param shadow The object that encapsulates the shadow attributes.
 */
- (void)addShadow:(NSShadow *)shadow;

/*
 * Adds a white emboss for any object that Inherits from UIView.
 *
 * @param offset The orientation offset of the shadow.
 * @param opacity The opacity of the shadow.
 */
- (void)addEmbossWithOffset:(CGSize)offset opacity:(CGFloat)opacity;

/*
 * Adds a glow effect for any object that Inherits from UIView.
 *
 * @param color The color of the glow.
 * @param opacity The opacity of the glow.
 */
- (void)addGlowEffectWithColor:(UIColor *)color opacity:(CGFloat)opacity;

/*
 * Adds a shadow for any object that Inherits from UIView.
 *
 * @param offset The orientation offset of the shadow.
 * @param opacity The opacity of the shadow.
 * @param radius The blur radius of the shadow.
 */
- (void)addShadowWithOffset:(CGSize)offset opacity:(CGFloat)opacity andRadius:(CGFloat)radius;

/*
 * Adds a very performant drop shadow for any object that Inherits from UIView.
 *
 * @param offset The orientation offset of the shadow.
 * @param opacity The opacity of the shadow.
 * @param radius The blur radius of the shadow.
 * @param frame The CGRect of the shadow canvas.
 */
- (void)addPathShadowWithOffset:(CGSize)offset opacity:(CGFloat)opacity andRadius:(CGFloat)radius andFrame:(CGRect)frame;

/*
 * Adds a very performant white emboss for any object that Inherits from UIView.
 *
 * @param offset The orientation offset of the shadow.
 * @param opacity The opacity of the shadow.
 * @param radius The blur radius of the shadow.
 * @param frame The CGRect of the shadow canvas.
 */
- (void)addPathEmbossWithOffset:(CGSize)offset opacity:(CGFloat)opacity andRadius:(CGFloat)radius andFrame:(CGRect)frame;

/*
 * Removes the shadow/glow effect for any object that Inherits from UIView.
 */
- (void)removeEffect;

/*
 * Sets the view to be rasterized to the device's scale.
 */
- (void)rasterize;

@end
