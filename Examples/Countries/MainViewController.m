//
//  ViewController.m
//  Countries
//
//  Created by Ignacio on 6/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "MainViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface MainViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    CGFloat _bottomMargin;
}
@property (nonatomic, strong) NSMutableArray *countries;
@property (nonatomic, strong) NSMutableArray *filteredCountries;
@property (nonatomic) BOOL loading;
@end

@implementation MainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"Countries of the World";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadContent)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loading = YES;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    [self updateViewConstraints];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.view removeConstraints:self.view.constraints];
    
    NSDictionary *views = @{@"searchBar": self.searchBar, @"tableView": self.tableView};
    NSDictionary *metrics = @{@"bottomMargin": @(_bottomMargin)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBar(44)][tableView]-bottomMargin-|" options:0 metrics:metrics views:views]];
}

- (void)updateTableViewConstraints:(NSNotification *)note
{
    CGRect endFrame = CGRectZero;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    
    CGFloat minY = CGRectGetMinY(endFrame);
    CGFloat keyboardHeight = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? endFrame.size.width : endFrame.size.height;
    if (keyboardHeight == CGRectGetHeight([UIScreen mainScreen].bounds)) keyboardHeight = 0;
    _bottomMargin = (minY == [UIScreen mainScreen].bounds.size.height) ? 0.0 : keyboardHeight;
    
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat curve = [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    [self updateViewConstraints];
    [self.tableView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self.tableView layoutIfNeeded];
                     }
                     completion:NULL];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
 
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        _searchBar.delegate = self;
        
        _searchBar.placeholder = @"Search Country";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}


#pragma mark - Sample Methods

- (void)loadContent
{
    if (_countries) {
        _countries = nil;
    }
    
    // A list of countries in JSON by Félix Bellanger
    // https://gist.github.com/Keeguon/2310008
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.countries = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];
}

- (void)reloadContent
{
    self.loading = NO;
    
    [self loadContent];
    [self.tableView reloadData];
}

- (void)addMissingUser
{
    NSString *name = self.searchBar.text;
    
    if ([self.countries containsObject:name]) {
        return;
    }
    
    [self.countries addObject:name];
    
    [self filtercountries];
}

- (void)filtercountries
{
    if (self.searchBar.text.length > 0) {
        
        if (!self.filteredCountries) {
            self.filteredCountries = [NSMutableArray new];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", self.searchBar.text];
        self.filteredCountries = [[self.countries filteredArrayUsingPredicate:predicate] mutableCopy];
        
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        [self.filteredCountries sortUsingDescriptors:@[sorter]];
    }
    else {
        self.filteredCountries = nil;
    }
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filteredCountries) {
        return self.filteredCountries.count;
    }
    return self.countries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *country = nil;
    if (self.filteredCountries) country = [self.filteredCountries objectAtIndex:indexPath.row];
    else country = [self.countries objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [country objectForKey:@"name"];
    cell.detailTextLabel.text = [country objectForKey:@"code"];
    
    UIImage *image = [UIImage imageNamed:[[country objectForKey:@"code"] lowercaseString]];
    if (!image) image = [UIImage imageNamed:@"unknown"];
    cell.imageView.image = image;
    
    cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.imageView.layer.shadowOpacity = 0.4;
    cell.imageView.layer.shadowRadius = 1.5;
    cell.imageView.layer.shadowOffset = CGSizeZero;
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading) {
        return nil;
    }
    
    NSString *text = [NSString stringWithFormat:@"No countries found matching\n%@.", self.searchBar.text];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:[text rangeOfString:self.searchBar.text]];
    
    return attributedTitle;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.loading || ([self.searchBar isFirstResponder] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))) {
        return nil;
    }
    
    NSString *text = @"Search in Wikipedia";
    UIColor *textColor = (state == UIControlStateNormal) ? [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] : [UIColor colorWithRed:204/255.0 green:228/255.0 blue:255/255.0 alpha:1.0];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: textColor};
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedTitle;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading || ([self.searchBar isFirstResponder] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))) {
        return nil;
    }
    
    return [UIImage imageNamed:@"search_icon"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading) {
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.translatesAutoresizingMaskIntoConstraints = NO;
        [activityView startAnimating];
        [contentView addSubview:activityView];
        
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = activityView.color;
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = @"Loading countries...";
        [contentView addSubview:label];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(activityView, label);
        
        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[activityView]|" options:0 metrics:nil views:views]];
        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:views]];
        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[activityView][label(25)]|" options:0 metrics:nil views:views]];
        
        return contentView;
    }
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
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    if ([self.searchBar isFirstResponder] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", self.searchBar.text]];
    
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
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
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        return;
    }
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    if (self.filteredCountries) {
        self.filteredCountries = nil;
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filtercountries];
    
    // If the data set is visiable, but the user keeps typing text
    // let's force the data set to redraw data according to the data source updates.
    if (self.tableView.isEmptyDataSetVisible && self.filteredCountries.count == 0) {
        [self.tableView reloadDataSetIfNeeded];
    }
}


#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)note
{
    [self updateTableViewConstraints:note];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [self updateTableViewConstraints:note];
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    _tableView.emptyDataSetSource = nil;
    _tableView.emptyDataSetDelegate = nil;
    _tableView = nil;
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
