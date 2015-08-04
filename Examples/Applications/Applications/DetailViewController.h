//
//  DetailViewController.h
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Application.h"

@interface DetailViewController : UITableViewController

@property (nonatomic, weak) NSArray *applications;
@property (nonatomic) BOOL allowShuffling;

- (instancetype)initWithApplication:(Application *)app;

@end
