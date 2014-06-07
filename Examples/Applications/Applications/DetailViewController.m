//
//  DetailViewController.m
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DetailViewController.h"
#import "UITableView+DataSet.h"

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
    UIImage *logoImage = nil;
    UIImage *backImage = nil;
    UIImage *backIndicator = [UIImage imageNamed:[NSString stringWithFormat:@"back_%@", [self.application.displayName lowercaseString]]];
    
    switch (self.application.type) {
        case ApplicationTypeInstagram:
        {
            barColor = [UIColor whiteColor];
            backImage = backIndicator;
            tintColor = [UIColor colorWithRed:31/255.0 green:98/255.0 blue:153/255.0 alpha:1.0];
            backIndicator = [UIImage imageNamed:@"back_instagram"];

            break;
        }
        case ApplicationTypeTumblr:
        {
            barColor = [UIColor colorWithRed:46/255.0 green:62/255.0 blue:83/255.0 alpha:1.0];
            tintColor = [UIColor whiteColor];
            logoImage = [UIImage imageNamed:@"logo_tumblr"];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

            break;
        }
        case ApplicationTypeVesper:
        {
            barColor = [UIColor colorWithRed:94/255.0 green:125/255.0 blue:154/255.0 alpha:1.0];
            backImage = backIndicator;
            tintColor = [UIColor whiteColor];
            backIndicator = [UIImage imageNamed:@"back_vesper"];

            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

            break;
        }
        default:
            break;
    }
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    self.navigationController.navigationBar.barTintColor = barColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    self.navigationController.navigationBar.backIndicatorImage = backImage;
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
        case ApplicationTypeInstagram:
        {
            text = @"Instagram Direct";
            font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0];
            textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            
            break;
        }
        case ApplicationTypeTumblr:
        {
            text = @"This is your Dashboard.";
            font = [UIFont boldSystemFontOfSize:18.0];
            textColor = [UIColor colorWithRed:170/255.0 green:182/255.0 blue:196/255.0 alpha:1.0];
            
            break;
        }
        case ApplicationTypeVesper:
        {
            text = @"No Notes";
            font = [UIFont fontWithName:@"IdealSans-Medium" size:16.0];
            textColor = [UIColor colorWithRed:217/255.0 green:220/255.0 blue:225/255.0 alpha:1.0];
            
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
    NSMutableParagraphStyle *paragraph = nil;
    
    switch (self.application.type) {
        case ApplicationTypeInstagram:
        {
            text = @"Send photos and videos directly to your friends. Only the people you send to can see these posts.";
            font = [UIFont systemFontOfSize:16.0];
            textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];

            paragraph = [NSMutableParagraphStyle new];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            paragraph.alignment = NSTextAlignmentCenter;
            paragraph.lineSpacing = 4.0;
            
            break;
        }
        case ApplicationTypeTumblr:
        {
            text = @"When you follow some blogs, their latest posts will show up here!";
            font = [UIFont systemFontOfSize:17.0];
            textColor = [UIColor colorWithRed:130/255.0 green:142/255.0 blue:156/255.0 alpha:1.0];
            
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
        case ApplicationTypeInstagram:  return [UIImage imageNamed:@"placeholder_instagram"];
        case ApplicationTypeTumblr:     return [UIImage imageNamed:@"placeholder_tumblr"];
        case ApplicationTypeVesper:     return [UIImage imageNamed:@"placeholder_vesper"];
        default:                        return nil;
    }
}

- (NSAttributedString *)buttonTitleForDataSetInTableView:(UITableView *)tableView
{
    return nil;
}

- (UIColor *)backgroundColorForDataSetInTableView:(UITableView *)tableView
{
    switch (self.application.type) {
        case ApplicationTypeInstagram:  return [UIColor whiteColor];
        case ApplicationTypeTumblr:     return [UIColor colorWithRed:52/255.0 green:70/255.0 blue:92/255.0 alpha:1.0];
        case ApplicationTypeVesper:     return [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
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
    return NO;
}

- (CGFloat)tableViewDataSetVerticalSpace:(UITableView *)tableView
{
    switch (self.application.type) {
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
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/en/app/instagram/id%@?mt=8", self.application.identifier]];
    
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
