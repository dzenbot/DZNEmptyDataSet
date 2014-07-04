//
//  SearchViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "SearchViewController.h"
#import "Palette.h"

#import "UIScrollView+EmptyDataSet.h"

@interface SearchViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation SearchViewController

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.title = @"Search";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_search"] tag:self.title.hash];
}

- (void)loadView
{
    [super loadView];
    
    if ([self.navigationController.viewControllers count] == 1) {
        self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    }
    else {
        self.title = @"Detail";
    }
    
    self.searchDisplayController.searchResultsTableView.emptyDataSetSource = self;
    self.searchDisplayController.searchResultsTableView.emptyDataSetDelegate = self;
    
    self.searchDisplayController.searchBar.placeholder = @"Search color";
    self.searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
    [self.searchDisplayController setValue:@"" forKey:@"_noResultsMessage"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateLayout];
}


#pragma mark - Getters

- (NSArray *)searchResult
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    
    NSArray *colors = [[Palette sharedPalette] colors];
    NSPredicate *precidate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ || hex CONTAINS[cd] %@", searchString, searchString];
    
    return [colors filteredArrayUsingPredicate:precidate];
}


#pragma mark - Actions

- (void)updateLayout
{
    BOOL hide = self.selectedColor ? NO : YES;
    self.colorView.hidden = hide;
    self.nameLabel.hidden = hide;
    self.hexLabel.hidden = hide;
    self.rgbLabel.hidden = hide;
    self.hexLegend.hidden = hide;
    self.rgbLegend.hidden = hide;
    
    self.colorView.image = [Color roundImageForSize:self.colorView.frame.size withColor:self.selectedColor.color];
    
    self.nameLabel.text = self.selectedColor.name;
    self.hexLabel.text = [NSString stringWithFormat:@"#%@", self.selectedColor.hex];
    self.rgbLabel.text = self.selectedColor.rgb;
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No colors Found";
    
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
    NSString *text = @"Make sure that all words are\nspelled correctly.";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"search_icon"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointMake(0, -80);
}


#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self.searchDisplayController setActive:NO animated:YES];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self searchResult].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.125 alpha:1.0];
    }
    
    Color *color = [self searchResult][indexPath.row];
    
    cell.textLabel.text = color.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"#%@", color.hex];
    
    cell.imageView.image = [Color roundThumbWithColor:color.color];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedColor = [self searchResult][indexPath.row];
    [self updateLayout];
    
    [self.searchDisplayController setActive:NO animated:YES];
}


#pragma mark - UISearchDisplayControllerDelegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

@end
