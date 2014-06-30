//
//  RootViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 6/29/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "RootViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIColor+Random.h"

#import "CollectionViewController.h"
#import "TableViewController.h"

@interface RootViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, readonly) UIScrollView *visibleControl;
@end

@implementation RootViewController

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadColors];
    [self setSelectedSegment:0];
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

- (void)loadColors
{
    if (_colors.count > 0) {
        return;
    }
    
    _colors = [NSMutableArray new];
    
    for (int i = 0; i < 80; i++) {
        UIColor *color = [UIColor randomColor];
        [_colors addObject:color];
    }
}

- (IBAction)reloadColors:(id)sender
{
    [self removeColors:sender];
    [self loadColors];
    
    [self updateChildColors];
}

- (IBAction)removeColors:(id)sender
{
    if (_colors.count == 0) {
        return;
    }
    
    _colors = nil;
    
    [self updateChildColors];
}

- (IBAction)changeSegment:(UISegmentedControl *)sender
{
    [self setSelectedSegment:sender.selectedSegmentIndex];
}

- (UIScrollView *)visibleControl
{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        CollectionViewController *controller = (CollectionViewController *)[self.childViewControllers firstObject];
        return controller.collectionView;
    }
    else {
        TableViewController *controller = (TableViewController *)[self.childViewControllers firstObject];
        return controller.tableView;
    }
}

- (void)updateChildColors
{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        CollectionViewController *controller = (CollectionViewController *)[self.childViewControllers firstObject];
        controller.colors = self.colors;
    }
    else {
        TableViewController *controller = (TableViewController *)[self.childViewControllers firstObject];
        controller.colors = self.colors;
    }
}

- (void)setSelectedSegment:(NSInteger)index
{
    UIViewController *newChildViewController = nil;
    
    if (index == 0) {
        CollectionViewController *controller = [[CollectionViewController alloc] init];
        controller.collectionView.emptyDataSetSource = self;
        controller.collectionView.emptyDataSetDelegate = self;
        newChildViewController = controller;
    }
    else {
        TableViewController *controller = [[TableViewController alloc] init];
        controller.tableView.emptyDataSetSource = self;
        controller.tableView.emptyDataSetDelegate = self;
        newChildViewController = controller;
    }
        
    if (newChildViewController) {
        
        for (UIViewController *childViewController in self.childViewControllers) {
            [childViewController removeFromParentViewController];
            [childViewController.view removeFromSuperview];
        }
        
        [newChildViewController willMoveToParentViewController:self];
        [self addChildViewController:newChildViewController];
        [newChildViewController didMoveToParentViewController:self];
        
        newChildViewController.view.frame = self.view.bounds;
        [self.view addSubview:newChildViewController.view];
        
//        [self updateChildColors];
    }
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
    
    NSString *text = @"No colors loaded";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"To show a list of random colors, tap on the refresh icon in the right top corner.\n\nTo clean the list, tap on the trash icon.";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0;
}


#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}

@end
