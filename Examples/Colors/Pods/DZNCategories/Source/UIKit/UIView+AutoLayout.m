//
//  UIView+AutoLayout.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 5/1/14.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)alignCenterToSuperview
{
    [self alignToSuperviewWithAxes:NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY];
}

- (void)alignTopLeftToSuperview
{
    [self alignToSuperviewWithAxes:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllLeft];
}

- (void)alignTopRightToSuperview
{
    [self alignToSuperviewWithAxes:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllRight];
}

- (void)alignBottomLeftToSuperview
{
    [self alignToSuperviewWithAxes:NSLayoutFormatAlignAllBottom|NSLayoutFormatAlignAllLeft];
}

- (void)alignBottomRightToSuperview
{
    [self alignToSuperviewWithAxes:NSLayoutFormatAlignAllBottom|NSLayoutFormatAlignAllRight];
}

- (void)alignToSuperviewWithAxes:(NSLayoutFormatOptions)axes
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if ((axes & NSLayoutFormatAlignAllLeft) > 0) {
        [self addEqualConstraintForAttribute:NSLayoutAttributeLeft];
    }
    
    if ((axes & NSLayoutFormatAlignAllRight) > 0) {
        [self addEqualConstraintForAttribute:NSLayoutAttributeRight];
    }
    
    if ((axes & NSLayoutFormatAlignAllTop) > 0) {
        [self addEqualConstraintForAttribute:NSLayoutAttributeTop];
    }
    
    if ((axes & NSLayoutFormatAlignAllBottom) > 0) {
        [self addEqualConstraintForAttribute:NSLayoutAttributeBottom];
    }
    
    if ((axes & NSLayoutFormatAlignAllCenterX) > 0) {
        [self addEqualConstraintForAttribute:NSLayoutAttributeCenterX];
    }
    
    if ((axes & NSLayoutFormatAlignAllCenterY) > 0) {
        [self addEqualConstraintForAttribute:NSLayoutAttributeCenterY];
    }
}

- (void)addEqualConstraintForAttribute:(NSLayoutAttribute)attribute
{
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:attribute
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:attribute
                                                              multiplier:1
                                                                constant:0]];
}

@end
