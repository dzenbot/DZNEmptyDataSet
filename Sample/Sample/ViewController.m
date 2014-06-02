//
//  ViewController.m
//  Sample
//
//  Created by Ignacio on 5/26/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CGFloat _bottomMargin;
}
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *filteredUsers;
@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _users = @[@"Amanda",@"Allie",@"Alyson",@"Byron",@"Britanny",@"Carl",@"Caroline",@"Connie",@"Daniel",@"Donnie",@"Donkey",@"Emanuel",@"Emerson",@"Eliseo",@"Emrih",@"Fabienne",@"Fabio",@"Fabiola",@"Francisco",@"Fernando",@"Flor",@"Facundo",@"Fatima",@"Felipe",@"Florencia",@"Filomena",@"Felicia",@"Flavio",@"Federico",@"Fanny",@"Francia",@"Hector",@"Horacio",@"Homero",@"Hilda",@"Hilia",@"Hernan",@"Geronimo",@"Gabriela",@"Gonzalo",@"Guido",@"Giovanni",@"George",@"Galileo",@"Gilberto"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"My Cool App";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
    
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


#pragma mark - Getter Methods

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.dataSetSource = self;
        
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
//        headerView.backgroundColor = [UIColor redColor];
//        _tableView.tableHeaderView = headerView;
        
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


#pragma mark - Actions Methods

- (void)reloadData
{
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_filteredUsers) {
        return _filteredUsers.count;
    }
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *name = nil;
    if (_filteredUsers) name = [_filteredUsers objectAtIndex:indexPath.row];
    else name = [_users objectAtIndex:indexPath.row];
    
    cell.textLabel.text = name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


#pragma mark - DZNTableViewDataSetSource Methods

- (NSString *)titleForDataSetInTableView:(UITableView *)tableView
{
    return NSLocalizedString(@"No Users Found", nil);
}

- (NSString *)descriptionForDataSetInTableView:(UITableView *)tableView;
{
    return NSLocalizedString(@"Make sure that all words are spelled correctly.", nil);
}

- (UIImage *)imageForDataSetInTableView:(UITableView *)tableView
{
    return nil;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    searchBar.text = nil;
    
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
    NSLog(@"textDidChange : %@", searchText);
    
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
