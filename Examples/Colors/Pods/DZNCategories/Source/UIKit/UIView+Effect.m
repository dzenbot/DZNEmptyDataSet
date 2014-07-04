//
//  UIView+Effect.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 2/22/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIView+Effect.h"

@implementation UIView (Effect)

- (void)addCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    [self rasterize];
}

- (void)addCornerRadius:(CGFloat)radius forCorners:(UIRectCorner)corners
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds
                                                     byRoundingCorners:corners
                                                           cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.layer.bounds;
    shapeLayer.path = bezierPath.CGPath;
    [self.layer setMask:shapeLayer];
    [self rasterize];
}

- (void)addBorderWithColor:(UIColor *)color cornerRadius:(CGFloat)radius andWidth:(CGFloat)width;
{
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
//    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
//    self.clipsToBounds = YES;
//    self.layer.masksToBounds = YES;
    
    [self rasterize];
}

- (void)removeBorders
{
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.layer.borderColor = nil;
}


- (void)addShadow:(NSShadow *)shadow
{
    UIColor *color = [shadow.shadowColor colorWithAlphaComponent:1.0];
    CGFloat opacity = CGColorGetAlpha([shadow.shadowColor CGColor]);
    
    [self addShadowWithColor:color offset:shadow.shadowOffset opacity:opacity andRadius:shadow.shadowBlurRadius];
}

- (void)addEmbossWithOffset:(CGSize)offset opacity:(CGFloat)opacity
{
    [self addShadowWithColor:[UIColor whiteColor] offset:offset opacity:opacity andRadius:0];
}

- (void)addGlowEffectWithColor:(UIColor *)color opacity:(CGFloat)opacity
{
    [self addShadowWithColor:color offset:CGSizeMake(0, 0) opacity:opacity andRadius:6.0];
}

- (void)addShadowWithOffset:(CGSize)offset opacity:(CGFloat)opacity andRadius:(CGFloat)radius
{
    [self addShadowWithColor:[UIColor blackColor] offset:offset opacity:opacity andRadius:radius];
}

- (void)addShadowWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity andRadius:(CGFloat)radius
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.masksToBounds = NO;
    
    [self rasterize];
}

- (void)addPathEmbossWithOffset:(CGSize)offset opacity:(CGFloat)opacity andRadius:(CGFloat)radius andFrame:(CGRect)frame
{
    [self addPathShadowWithOffset:offset opacity:opacity andRadius:radius andFrame:frame];
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
}

- (void)addPathShadowWithOffset:(CGSize)offset opacity:(CGFloat)opacity andRadius:(CGFloat)radius andFrame:(CGRect)frame
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.masksToBounds = NO;
    
    CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:self.layer.cornerRadius] CGPath];
    self.layer.shadowPath = path;
    
    [self rasterize];
}

- (void)removeEffect
{
    [self.layer setShadowColor: [[UIColor clearColor] CGColor]];
    [self.layer setShadowOpacity: 0.0f];
    [self.layer setShadowOffset: CGSizeMake(0.0f, 0.0f)];
}

- (void)rasterize
{
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
