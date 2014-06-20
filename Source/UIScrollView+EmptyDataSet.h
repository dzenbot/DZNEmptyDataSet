//
//  UIScrollView+EmptyDataSet.h
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>
#import "DZNEmptyDataSetProtocols.h"

/**
 A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display.
 
 @discussion It will work automatically, by just conforming to DZNEmptyDataSetSource, and returning the data you want to show. The -reloadData call will be observed so the empty dataset will be configured whenever needed. It is (extremely) important to set the dataSetSource and dataSetDelegate to nil, whenever the view is going to be released. This class uses KVO under the hood, so it needs to remove the observer before dealocating the view.
 */
@interface UIScrollView (EmptyDataSet)

/** The empty datasets data source. */
@property (nonatomic, weak) id <DZNEmptyDataSetSource> emptyDataSetSource;
/** The empty datasets delegate. */
@property (nonatomic, weak) id <DZNEmptyDataSetDelegate> emptyDataSetDelegate;
/** YES if any empty dataset is visible. */
@property (nonatomic, readonly, getter = isEmptyDataSetVisible) BOOL emptyDataSetVisible;

/**
 Call this methods whenever you want to force the data set update, whitout having to depend on the -reloadData selector.
 
 @discussion This will update the content of the controls and their constraints. If the content hasn't change, this will take no effect.
 */
- (void)reloadDataSetIfNeeded;

@end
