//
//  DZNDataSetView.h
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

#define kDZNDataSetViewDidTapButtonNotification @"kDZNDataSetViewDidTapButtonNotification"

/**
 * The dataset view, containing visual controls such as labels, buttons, imageviews, etc.
 *
 * @discussion This wrapper view allows multiple combinations, based on the content retrieved from the data source. You can decide to just show an image with a button, or a title with a description, or all together. Is up to you and what your view controller needs to successfuly communicate to the user what's going on and why there is no content to display.
 */
@interface DZNDataSetView : UIView

/** The primary label used for the title, with 1 line of text. */
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/** The secondary label with unlimited number of lines. */
@property (nonatomic, strong, readonly) UILabel *detailLabel;
/** The image view view. */
@property (nonatomic, strong, readonly) UIImageView *imageView;
/** The button of the view. */
@property (nonatomic, strong, readonly) UIButton *button;
/** The vertical space between controls. */
@property (nonatomic, assign) CGFloat verticalSpace;

- (instancetype)initWithFrame:(CGRect)frame customView:(UIView *)view;

/** 
 * Removes and deallocates all the view's controls.
 */
- (void)invalidateContent;

@end
