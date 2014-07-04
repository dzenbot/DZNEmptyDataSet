//
//  UIView+AutoLayout.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 5/1/14.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

// Center alignment to superview
- (void)alignCenterToSuperview;

// Top alignments to superview
- (void)alignTopLeftToSuperview;
- (void)alignTopRightToSuperview;

// Bottom alignments to superview
- (void)alignBottomLeftToSuperview;
- (void)alignBottomRightToSuperview;

// Custom alignments to superview
- (void)alignToSuperviewWithAxes:(NSLayoutFormatOptions)axes;

@end
