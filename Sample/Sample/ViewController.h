//
//  ViewController.h
//  Sample
//
//  Created by Ignacio on 5/26/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DataSet.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DZNTableViewDataSetSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end
