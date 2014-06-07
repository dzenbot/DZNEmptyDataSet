//
//  DetailViewController.m
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DetailViewController.h"
#import "UITableView+DataSet.h"
#import "UIColor+Hexadecimal.h"

@interface DetailViewController () <DZNTableViewDataSetSource, DZNTableViewDataSetDelegate>
@property (nonatomic, strong) Application *application;
@end

@implementation DetailViewController

- (instancetype)initWithApplication:(Application *)application
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.application = application;
        self.title = application.displayName;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSetDelegate = self;
    self.tableView.dataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithHex:@"efeff4"];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
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

- (void)configureNavigationBar
{
    UIColor *barColor = nil;
    UIColor *tintColor = nil;
    UIStatusBarStyle barstyle = UIStatusBarStyleDefault;
    
    switch (self.application.type) {
        case ApplicationTypeAirbnb:
        {
            barColor = [UIColor colorWithHex:@"f8f8f8"];
            tintColor = [UIColor colorWithHex:@"08aeff"];
            
            break;
        }
        case ApplicationTypeInstagram:
        {
            barColor = [UIColor colorWithHex:@"2e5e86"];
            tintColor = [UIColor whiteColor];
            barstyle = UIStatusBarStyleLightContent;

            break;
        }
        case ApplicationTypeTumblr:
        {
            barColor = [UIColor colorWithHex:@"2e3e53"];
            tintColor = [UIColor whiteColor];
            barstyle = UIStatusBarStyleLightContent;

            break;
        }
        case ApplicationTypeVesper:
        {
            barColor = [UIColor colorWithHex:@"5e7d9a"];
            tintColor = [UIColor colorWithHex:@"f8f8f8"];
            barstyle = UIStatusBarStyleLightContent;

            break;
        }
        default:
            break;
    }
    
    UIImage *logo = [UIImage imageNamed:[NSString stringWithFormat:@"logo_%@", [self.application.displayName lowercaseString]]];
    if (logo) self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    self.navigationController.navigationBar.barTintColor = barColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back_button"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:barstyle animated:YES];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


#pragma mark - DZNTableViewDataSetDataSource Methods

- (NSAttributedString *)titleForDataSetInTableView:(UITableView *)tableView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    switch (self.application.type) {
        case ApplicationTypeAirbnb:
        {
            text = @"No Messages";
            font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
            textColor = [UIColor colorWithHex:@"c9c9c9"];
            
            break;
        }
        case ApplicationTypeInstagram:
        {
            text = @"Instagram Direct";
            font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0];
            textColor = [UIColor colorWithHex:@"444444"];
            
            break;
        }
        case ApplicationTypeTumblr:
        {
            text = @"This is your Dashboard.";
            font = [UIFont boldSystemFontOfSize:18.0];
            textColor = [UIColor colorWithHex:@"aab6c4"];
            
            break;
        }
        case ApplicationTypeVesper:
        {
            text = @"No Notes";
            font = [UIFont fontWithName:@"IdealSans-Medium" size:16.0];
            textColor = [UIColor colorWithHex:@"d9dce1"];
            
            break;
        }
        default:
            return nil;
    }
    
    if (!text) {
        return nil;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForDataSetInTableView:(UITableView *)tableView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    switch (self.application.type) {
        case ApplicationTypeAirbnb:
        {
            text = @"When you have messages, you’ll\nsee them here.";
            font = [UIFont systemFontOfSize:13.0];
            textColor = [UIColor colorWithHex:@"cfcfcf"];
            paragraph.lineSpacing = 4.0;

            break;
        }
        case ApplicationTypeInstagram:
        {
            text = @"Send photos and videos directly to your friends. Only the people you send to can see these posts.";
            font = [UIFont systemFontOfSize:16.0];
            textColor = [UIColor colorWithHex:@"444444"];
            paragraph.lineSpacing = 4.0;
            
            break;
        }
        case ApplicationTypeTumblr:
        {
            text = @"When you follow some blogs, their latest posts will show up here!";
            font = [UIFont systemFontOfSize:17.0];
            textColor = [UIColor colorWithHex:@"828e9c"];
            
            break;
        }
        case ApplicationTypeVesper:
            return nil;
        default:
            return nil;
    }
    
    if (!text) {
        return nil;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];

    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForDataSetInTableView:(UITableView *)tableView
{
    switch (self.application.type) {
        case ApplicationTypeAirbnb:     return [UIImage imageNamed:@"placeholder_airbnb"];
        case ApplicationTypeInstagram:  return [UIImage imageNamed:@"placeholder_instagram"];
        case ApplicationTypeTumblr:     return [UIImage imageNamed:@"placeholder_tumblr"];
        case ApplicationTypeVesper:     return [UIImage imageNamed:@"placeholder_vesper"];
        default:                        return nil;
    }
}

- (NSAttributedString *)buttonTitleForDataSetInTableView:(UITableView *)tableView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    switch (self.application.type) {
        case ApplicationTypeAirbnb:
        {
            text = @"Start Browsing";
            font = [UIFont boldSystemFontOfSize:16.0];
            textColor = [UIColor colorWithHex:@"05adff"];

            break;
        }
        default:
            return nil;
    }
    
    if (!text) {
        return nil;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForDataSetInTableView:(UITableView *)tableView
{
    switch (self.application.type) {
        case ApplicationTypeAirbnb:     return [UIColor whiteColor];
        case ApplicationTypeInstagram:  return [UIColor whiteColor];
        case ApplicationTypeTumblr:     return [UIColor colorWithHex:@"34465c"];
        case ApplicationTypeVesper:     return [UIColor colorWithHex:@"f8f8f8"];
        default:                        return nil;
    }
}


#pragma mark - DZNTableViewDataSetDelegate Methods

- (BOOL)tableViewDataSetShouldAllowTouch:(UITableView *)tableView
{
    return YES;
}

- (BOOL)tableViewDataSetShouldAllowScroll:(UITableView *)tableView
{
    return YES;
}

- (CGFloat)tableViewDataSetVerticalSpace:(UITableView *)tableView
{
    switch (self.application.type) {
        case ApplicationTypeAirbnb:     return 24.0;
        case ApplicationTypeInstagram:  return 24.0;
        case ApplicationTypeTumblr:     return 10.0;
        case ApplicationTypeVesper:     return 22.0;
        default:                        return 0.0;
    }
}

- (void)tableViewDataSetDidTapView:(UITableView *)tableView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)tableViewDataSetDidTapButton:(UITableView *)tableView
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@", self.application.identifier]];
    
    NSLog(@"%s: %@",__FUNCTION__, URL);
    
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
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
    self.tableView.dataSetSource = nil;
    self.tableView.dataSetDelegate = nil;
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
