//
//  DZNTableDataSetView.h
//  UITableView-DataSet
//  https://github.com/dzenbot/UITableView-DataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

#define kDZNTableDataSetViewDidTapButtonNotification @"kDZNTableDataSetViewDidTapButtonNotification"

/**
 * The data set view, containing visual controls such as labels, buttons, imageviews, etc.
 *
 * @discussion This wrapper view allows multiple combinations, based on the content retrieved from the data source. You can decide to just show an image with a button, or a title with a description, or all together. Is up to you and what your view controller needs to successfuly communicate to the user what's going on and why there is no content to display.
 */
@interface DZNTableDataSetView : UIView

/** The primary label used for the title, with 1 line of text. */
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/** The secondary label with unlimited number of lines. */
@property (nonatomic, strong, readonly) UILabel *detailLabel;
/** The image view view. */
@property (nonatomic, strong, readonly) UIImageView *imageView;
/** The button of the view. */
@property (nonatomic, strong, readonly) UIButton *button;

@end
