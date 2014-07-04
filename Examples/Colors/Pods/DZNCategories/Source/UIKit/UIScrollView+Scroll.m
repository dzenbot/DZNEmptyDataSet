//
//  UIScrollView+Scroll.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/20/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIScrollView+Scroll.h"

static CGPoint _lastContentOffset;

@implementation UIScrollView (Scroll)

- (void)scrollToTopAnimated:(BOOL)animated
{
    CGPoint topOffset = CGPointZero;
    [self setContentOffset:topOffset animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if ([self canScrollToBottom]) {
        CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height);
        [self setContentOffset:bottomOffset animated:animated];
    }
}

- (BOOL)canScrollToBottom
{
    return (self.contentSize.height > self.bounds.size.height) ? YES : NO;
}

- (BOOL)isOnTop
{
    return (self.contentOffset.y >= 0 && self.contentOffset.y < 100) ? YES : NO;
}

- (BOOL)isOnBottom
{
    CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height);
    return (self.contentOffset.y == bottomOffset.y) ? YES : NO;
}

- (UIScrollViewDirection)scrollDirectionFromContentOffset:(CGPoint)contentOffset
{
    UIScrollViewDirection scrollDirection;
    
    if (_lastContentOffset.y > contentOffset.y) scrollDirection = UIScrollViewDirectionTop;
    else if (_lastContentOffset.y < contentOffset.y) scrollDirection = UIScrollViewDirectionBottom;
    else if (_lastContentOffset.x > contentOffset.x) scrollDirection = UIScrollViewDirectionRight;
    else if (_lastContentOffset.x < contentOffset.x) scrollDirection = UIScrollViewDirectionLeft;
    else scrollDirection = UIScrollViewDirectionNone;

    _lastContentOffset = contentOffset;
    
    return scrollDirection;
}

@end
