//
//  DZNTableViewDataSetSource.h
//  UITableView-DataSet
//
//  Created by Ignacio on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DZNTableViewDataSetSource <NSObject>
@required

@optional

- (NSString *)titleForDataSetInTableView:(UITableView *)tableView;
- (NSString *)descriptionForDataSetInTableView:(UITableView *)tableView;

- (UIImage *)imageForDataSetInTableView:(UITableView *)tableView;

@end
