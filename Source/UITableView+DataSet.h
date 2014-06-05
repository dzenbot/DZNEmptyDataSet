//
//  UITableView+DataSet.h
//  UITableView-DataSet
//  https://github.com/dzenbot/UITableView-DataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>
#import "DZNTableViewDataSetProtocols.h"

/**
 * A drop-in UITableView category for showing empty data sets whenever -reloadData returns no content to display.
 * It will work automatically, by just setting the dataSetSource and dataSetDelegate, and returning the data source content requiered.
 *
 * @discussion It is very important to set the dataSetSource and dataSetDelegate to nil, on the viewcontroller's -dealloc method. This class uses KVO under the hood, so it needs to remove the observer whenever the tableview is going to be released.
 */
@interface UITableView (DataSet)

/** The data set data source. */
@property (nonatomic, weak) id <DZNTableViewDataSetSource> dataSetSource;
/** The data set delegate. */
@property (nonatomic, weak) id <DZNTableViewDataSetDelegate> dataSetDelegate;
/** YES if any data set is visible. */
@property (nonatomic, readonly, getter = isDataSetVisible) BOOL dataSetVisible;


/**
 * Call this methods whenever you want to force the data set update, whitout having to depend of -reloadData.
 * This will update the content of the controls and their constraints. If the content hasn't change, this will take no effect.
 */
- (void)reloadDataSetIfNeeded;

@end