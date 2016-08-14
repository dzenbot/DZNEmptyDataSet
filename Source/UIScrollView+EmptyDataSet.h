//
//  UIScrollView+EmptyDataSet.h
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2016 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DZNEmptyDataSetSource;
@protocol DZNEmptyDataSetDelegate;

#define DZNEmptyDataSetDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

/**
 A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display.
 @discussion It will work automatically, by just conforming to DZNEmptyDataSetSource, and returning the data you want to show.
 */
@interface UIScrollView (EmptyDataSet)

/** The empty datasets data source. */
@property (nonatomic, weak, nullable) IBOutlet id <DZNEmptyDataSetSource> emptyDataSetSource;
/** The empty datasets delegate. */
@property (nonatomic, weak, nullable) IBOutlet id <DZNEmptyDataSetDelegate> emptyDataSetDelegate;
/** YES if any empty dataset is visible. */
@property (nonatomic, readonly, getter = isEmptyDataSetVisible) BOOL emptyDataSetVisible;

/**
 Reloads the empty dataset content receiver.
 @discussion Call this method to force all the data to refresh. Calling -reloadData is similar, but this forces only the empty dataset to reload, not the entire table view or collection view.
 */
- (void)reloadEmptyDataSet;

@end


/**
 The object that acts as the data source of the empty datasets.
 @discussion The data source must adopt the DZNEmptyDataSetSource protocol. The data source is not retained. All data source methods are optional.
 */
@protocol DZNEmptyDataSetSource <NSObject>
@optional

/**
 Asks the data source for the title of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset title, combining font, text color, text pararaph style, etc.
 */
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
 */
- (nullable NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for the image of the dataset.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An image for the dataset.
 */
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;


/**
 Asks the data source for a tint color of the image dataset. Default is nil.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to tint the image of the dataset.
 */
- (nullable UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView;

/**
 *  Asks the data source for the image animation of the dataset.
 *
 *  @param scrollView A scrollView subclass object informing the delegate.
 *
 *  @return image animation
 */
- (nullable CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for the title to be used for the specified button state.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (nullable NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for the image to be used for the specified button state.
 This method will override buttonTitleForEmptyDataSet:forState: and present the image only without any text.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An image for the dataset button imageview.
 */
- (nullable UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for a background image to be used for the specified button state.
 There is no default style for this call.
 
 @param scrollView A scrollView subclass informing the data source.
 @param state The state that uses the specified image. The values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (nullable UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for the background color of the dataset. Default is clear color.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to be applied to the dataset background view.
 */
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a custom view to be displayed instead of the default views such as labels, imageview and button. Default is nil.
 Use this method to show an activity view indicator for loading feedback, or for complete custom empty data set.
 Returning a custom view will ignore -offsetForEmptyDataSet and -spaceHeightForEmptyDataSet configurations.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The custom view.
 */
- (nullable UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a offset for vertical and horizontal alignment of the content. Default is CGPointZero.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The offset for vertical and horizontal alignment.
 */
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-verticalOffsetForEmptyDataSet:);
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a vertical space between elements. Default is 11 pts.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The space height between elements.
 */
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView;

@end


/**
 The object that acts as the delegate of the empty datasets.
 @discussion The delegate can adopt the DZNEmptyDataSetDelegate protocol. The delegate is not retained. All delegate methods are optional.
 
 @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@protocol DZNEmptyDataSetDelegate <NSObject>
@optional

/**
 Asks the delegate to know if the empty dataset should fade in when displayed. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should fade in.
 */
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView;

/**
 Asks the delegate to know if the empty dataset should still be displayed when the amount of items is more than 0. Default is NO
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if empty dataset should be forced to display
 */
- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView;

/**
 Asks the delegate to know if the empty dataset should be rendered and displayed. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should show.
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;

/**
 Asks the delegate for touch permission. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset receives touch gestures.
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView;

/**
 Asks the delegate for scroll permission. Default is NO.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to be scrollable.
 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;

/**
 Asks the delegate for image view animation permission. Default is NO.
 Make sure to return a valid CAAnimation object from imageAnimationForEmptyDataSet:
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to animate
 */
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataSet:didTapView:);

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataSet:didTapButton:);

/**
 Tells the delegate that the empty dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param view the view tapped by the user
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

/**
 Tells the delegate that the empty data set will appear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set did appear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set will disappear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set did disappear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView;

@end

#undef DZNEmptyDataSetDeprecated

NS_ASSUME_NONNULL_END
