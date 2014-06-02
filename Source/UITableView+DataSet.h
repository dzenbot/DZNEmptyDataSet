//
//  UITableView+DataSet.h
//  UITableView-DataSet
//
//  Created by Ignacio on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNTableViewDataSetSource.h"

@interface UITableView (DataSet)
/** */
@property (nonatomic, weak) id <DZNTableViewDataSetSource> dataSetSource;
@property (nonatomic, readonly, getter = isDataSetVisible) BOOL dataSetVisible;

/**
 *
 */
- (void)reloadDataSetIfNeeded;

@end
