//
//  WebViewController.m
//  WebBrowser
//
//  Created by Ignacio Romero Z. on 7/21/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "WebViewController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface WebViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation WebViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.webView.scrollView.emptyDataSetSource = self;
//    self.webView.scrollView.emptyDataSetDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - View Auto-Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
