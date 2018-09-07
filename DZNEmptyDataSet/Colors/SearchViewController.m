//
//  SearchViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchViewController.h"
#import "Palette.h"
#import "Color.h"

#import <DZNEmptyDataSet/DZNEmptyDataSet.h>

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filteredColors;
@end

@implementation SearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    // SEE: "Listing 1 Creating and configuring a search controller on iOS"
    // https://developer.apple.com/documentation/uikit/uisearchcontroller
    // Create the search results controller and store a reference to it.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    // Use the current view controller to update the search results.
    self.searchController.searchResultsUpdater = self;
    // Install the search bar as the table header.
    self.tableView.tableHeaderView = self.searchController.searchBar;
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;
    
    self.searchController.searchBar.placeholder = @"Search color";
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.filteredColors = nil;
    [self.tableView reloadData];
}

#pragma mark - Getters

- (NSMutableArray *)filteredColors
{
    if (!_filteredColors)
    {
        UISearchBar *searchBar = self.searchController.searchBar;
        _filteredColors = [[[Palette sharedPalette] colors] mutableCopy];
        if ([searchBar isFirstResponder] && searchBar.text.length > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchBar.text];
            [_filteredColors filterUsingPredicate:predicate];
        }
    }
    return _filteredColors;
}

#pragma mark - Actions

- (IBAction)refreshColors:(id)sender
{
    [[Palette sharedPalette] reloadAll];
    self.filteredColors = nil;
    [self.tableView reloadData];
}

- (IBAction)removeColors:(id)sender
{
    [[Palette sharedPalette] removeAll];
    [_filteredColors removeAllObjects];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"search_push_detail"])
    {
        DetailViewController *controller = [segue destinationViewController];
        controller.selectedColor = sender;
    }
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

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"Add a New Color";
    UIColor *color = [UIColor colorWithRed:44/255.0 green:137/255.0 blue:202/255.0 alpha:1.0];
    
    if (state == UIControlStateHighlighted) color = [UIColor colorWithRed:106/255.0 green:187/255.0 blue:227/255.0 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: color,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return nil;
    }
    return [UIImage imageNamed:@"search_icon"];
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor grayColor];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
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

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{

    // TODO: [self.searchController setActive:NO animated:YES];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
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
    NSInteger rowCount = [self filteredColors].count;

    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.125 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    
    Color *color = [[self filteredColors] objectAtIndex:indexPath.row];
    
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
    Color *color = [[self filteredColors] objectAtIndex:indexPath.row];
    
    if ([self shouldPerformSegueWithIdentifier:@"search_push_detail" sender:color]) {
        [self performSegueWithIdentifier:@"search_push_detail" sender:color];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // Do something
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // Do something
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // Do something
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Do something
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchForText:(NSString *)searchString
{
    //NSLog(@"searchString == %@",searchString);
}

#pragma mark - UISearchResultsUpdating Protocol

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = _searchController.searchBar.text;
    [self searchForText:searchString];
    self.filteredColors = nil;
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate Protocol

- (void)didDismissSearchController:(UISearchController *)searchController
{
    // Do something
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    // Do something
}

- (void)presentSearchController:(UISearchController *)searchController
{
    // Do something
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    // Do something
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    // Do something
}

@end
