//
//  DZNScrollViewDataSetDelegate.h
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>

/**
 * The object that acts as the delegate of the datasets.
 * The delegate must adopt the DZNScrollViewDataSetDelegate protocol. The delegate is not retained.
 *
 * @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@protocol DZNScrollViewDataSetDelegate <NSObject>
@required
@optional

/**
 * Asks the delegate for touch permission. Default is YES.
 *
 * @param scrollView A scrollView subclass object informing the delegate.
 * @return YES if the dataset receives touch gestures.
 */
- (BOOL)scrollViewDataSetShouldAllowTouch:(UIScrollView *)scrollView;

/**
 * Asks the delegate for scroll permission. Default is NO.
 *
 * @param scrollView A scrollView subclass object informing the delegate.
 * @return YES if the dataset is allowed to be scrollable.
 */
- (BOOL)scrollViewDataSetShouldAllowScroll:(UIScrollView *)scrollView;

/**
 * Tells the delegate that the dataset view was tapped.
 * Use this method either to resignFirstResponder of a textfield or searchBar.
 *
 * @param scrollView A scrollView subclass informing the delegate.
 */
- (void)scrollViewDataSetDidTapView:(UIScrollView *)scrollView;

/**
 * Tells the delegate that the option button was tapped.
 *
 * @param scrollView A scrollView subclass informing the delegate.
 */
- (void)scrollViewDataSetDidTapButton:(UIScrollView *)scrollView;


@end
