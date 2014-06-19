//
//  DZNScrollViewDataSetSource.h
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * The object that acts as the data source of the datasets.
 * The data source must adopt the DZNScrollViewDataSetSource protocol. The data source is not retained.
 *
 * @discussion All data source methods are optional.They will not be considered in the layout if they either return nil or the view controller doesn't conform to them.
 */
@protocol DZNScrollViewDataSetSource <NSObject>
@required

@optional

/**
 * Asks the data source for the title of the dataset.
 * The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 *
 * @param scrollView A scrollView subclass informing the data source.
 * @return An attributed string for the dataset title, combining font, text color, text pararaph style, etc.
 */
- (NSAttributedString *)titleForScrollViewDataSet:(UIScrollView *)scrollView;

/**
 * Asks the data source for the description of the dataset.
 * The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 *
 * @param scrollView A scrollView subclass informing the data source.
 * @return An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
 */
- (NSAttributedString *)descriptionForScrollViewDataSet:(UIScrollView *)scrollView;

/**
 * Asks the data source for the image of the dataset.
 *
 * @param scrollView A scrollView subclass informing the data source.
 * @return An image for the dataset.
 */
- (UIImage *)imageForScrollViewDataSet:(UIScrollView *)scrollView;

/**
 * Asks the data source for the title to be used for the specified button state.
 * The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 *
 * @param scrollView A scrollView subclass object informing the data source.
 * @param state The state that uses the specified title. The possible values are described in UIControlState.
 * @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (NSAttributedString *)buttonTitleForScrollViewDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 * Asks the data source for a background image to be used for the specified button state.
 * There is no default style for this call.
 *
 * @param scrollView A scrollView subclass informing the data source.
 * @param state The state that uses the specified image. The values are described in UIControlState.
 * @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (UIImage *)buttonBackgroundImageForScrollViewDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 * Asks the data source for the background color of the dataset. Default is clear color.
 *
 * @param scrollView A scrollView subclass object informing the data source.
 * @return An color to be applied to the dataset background view.
 */
- (UIColor *)backgroundColorForScrollViewDataSet:(UIScrollView *)scrollView;

/**
 * Asks the data source for a custom vertical space. Default is 11 pts.
 *
 * @param scrollView A scrollView subclass object informing the delegate.
 * @return The space height between elements.
 */
- (CGFloat)spaceHeightForScrollViewDataSet:(UIScrollView *)scrollView;

/**
 * Asks the data source for a custom view to be displayed instead of the default views such as labels, imageview and button. Default is nil.
 * Use this method to show an activity view indicator for loading feedback, or for complete custom empty data set.
 *
 * @param scrollView A scrollView subclass object informing the delegate.
 * @return The custom view.
 */
- (UIView *)customViewForScrollViewDataSet:(UIScrollView *)scrollView;

@end