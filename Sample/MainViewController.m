//
//  ViewController.m
//  Sample
//
//  Created by Ignacio on 6/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "MainViewController.h"
//#import "UITableView+DataSet.h"

@interface MainViewController () /*<DZNTableViewDataSetSource, DZNTableViewDataSetDelegate>*/ {
    CGFloat _bottomMargin;
}
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *filteredUsers;
@end

@implementation MainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"Sample";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _users = @[@"Amanda",@"Allie",@"Alyson",@"Byron",@"Britanny",@"Carl",@"Caroline",@"Connie",@"Daniel",@"Donnie",@"Donkey",@"Emanuel",@"Emerson",@"Eliseo",@"Emrih",@"Fabienne",@"Fabio",@"Fabiola",@"Francisco",@"Fernando",@"Flor",@"Facundo",@"Fatima",@"Felipe",@"Florencia",@"Filomena",@"Felicia",@"Flavio",@"Federico",@"Fanny",@"Francia",@"Hector",@"Horacio",@"Homero",@"Hilda",@"Hilia",@"Hernan",@"Geronimo",@"Gabriela",@"Gonzalo",@"Guido",@"Giovanni",@"George",@"Galileo",@"Gilberto"];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.tableView action:@selector(reloadDataSetIfNeeded)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _bottomMargin = (minY == [UIScreen mainScreen].bounds.size.height) ? 0.0 : endFrame.size.height;
    
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat curve = [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    [self updateViewConstraints];
    [self.tableView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [self.view layoutIfNeeded];
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
        
//        _tableView.dataSetDelegate = self;
//        _tableView.dataSetSource = self;
 
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
        
        _searchBar.placeholder = @"Search";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *name = [_users objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    
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


//#pragma mark - DZNTableViewDataSetDataSource Methods
//
//- (NSAttributedString *)titleForDataSetInTableView:(UITableView *)tableView
//{
//    return nil;
//}
//
//- (NSAttributedString *)descriptionForDataSetInTableView:(UITableView *)tableView
//{
//    return nil;
//}
//
//- (UIImage *)imageForDataSetInTableView:(UITableView *)tableView
//{
//    return nil;
//}
//
//- (NSAttributedString *)buttonTitleForDataSetInTableView:(UITableView *)tableView
//{
//    return nil;
//}
//
//#pragma mark - DZNTableViewDataSetDelegate Methods
//
//- (BOOL)tableViewDataSetShouldAllowTouch:(UITableView *)tableView
//{
//    return YES;
//}
//
//- (BOOL)tableViewDataSetShouldAllowScroll:(UITableView *)tableView
//{
//    return YES;
//}
//
//- (void)tableViewDataSetDidTapView:(UITableView *)tableView
//{
//    
//}
//
//- (void)tableViewDataSetDidTapButton:(UITableView *)tableView
//{
//    
//}


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
    
    if (_filteredUsers) {
        _filteredUsers = nil;
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
    if (searchText.length > 0) {
        
        if (!_filteredUsers) {
            _filteredUsers = [NSArray new];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchText];
        _filteredUsers = [_users filteredArrayUsingPredicate:predicate];
    }
    else {
        _filteredUsers = nil;
    }
    
    [self.tableView reloadData];
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
