//
//  MainViewController.m
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "UIColor+Hexadecimal.h"

@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray *applications;
@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self serializeApplications];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Popular Applications";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.titleTextAttributes = nil;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:@"f8f8f8"];;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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


#pragma mark - UITableViewDataSource Methods

- (void)serializeApplications
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"applications" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *objects = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];
    
    self.applications = [NSMutableArray new];
    
    for (NSDictionary *dictionary in objects) {
        Application *app = [[Application alloc] initWithDictionary:dictionary];
        [self.applications addObject:app];
    }
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.applications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"main_cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    Application *app = [self.applications objectAtIndex:indexPath.row];
    
    cell.textLabel.text = app.displayName;
    cell.detailTextLabel.text = app.developerName;
    
    UIImage *image = [UIImage imageNamed:app.iconName];
    cell.imageView.image = image;
    
    cell.imageView.layer.cornerRadius = image.size.width*0.2;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
    cell.imageView.layer.borderWidth = 0.5;
    
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Application *app = [self.applications objectAtIndex:indexPath.row];
    DetailViewController *controller = [[DetailViewController alloc] initWithApplication:app];
    
    [self.navigationController pushViewController:controller animated:YES];
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
