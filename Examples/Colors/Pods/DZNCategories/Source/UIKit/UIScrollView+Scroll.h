//
//  UIScrollView+Scroll.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/20/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIScrollViewDirection) {
    UIScrollViewDirectionNone,
    UIScrollViewDirectionTop,
    UIScrollViewDirectionBottom,
    UIScrollViewDirectionRight,
    UIScrollViewDirectionLeft
};

@interface UIScrollView (Scroll)

- (void)scrollToTopAnimated:(BOOL)animated;

- (void)scrollToBottomAnimated:(BOOL)animated;

- (BOOL)isOnTop;

- (BOOL)isOnBottom;

@end
