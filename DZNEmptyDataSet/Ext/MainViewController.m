//
//  MainViewController.m
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "MainViewController.h"
#import "UIScrollView+DZNEmptyExt.h"
#import "UIColor+Hexadecimal.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"EmptyExt";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString * titleStr = @"Star Your Favorite Files";
    UIFont * titleFont = [UIFont systemFontOfSize:17.0];
    UIColor * titleColor = [UIColor colorWithHex:@"25282b"];
    
    NSString * describeStr = @"Favorites are saved for offline access.";
    UIFont * describeFont = [UIFont systemFontOfSize:14.5];
    UIColor * describeColor = [UIColor colorWithHex:@"7b8994"];
    
    NSString * buttonStr = @"Learn more";
    UIFont * buttonFont = [UIFont systemFontOfSize:15.0];
    UIColor * buttonNormalColor = [UIColor colorWithHex:@"007ee5"];
    UIColor * buttonHighLightColor = [UIColor colorWithHex:@"48a1ea"];
    
    UIImage * loadingImage = [UIImage imageNamed:@"loading_imgBlue_78x78" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    __weak typeof(self) weakSelf = self;
    [[[[self.tableView makeEmptyPage:^(DZNEmptyMaker *make) {
        
        // Configuring the dropbox dataset
        make.displayScene(@"dropbox")
        .image([UIImage imageNamed:@"placeholder_dropbox"])
        .title(titleStr, titleFont, titleColor)
        .describe(describeStr, describeFont, describeColor)
        .buttonTitle(buttonStr, buttonFont, buttonNormalColor, UIControlStateNormal)
        .buttonTitle(buttonStr, buttonFont, buttonHighLightColor, UIControlStateHighlighted)
        .backgroundColor([UIColor colorWithHex:@"f0f3f5"])
        .allowScroll(YES)
        .allowTouch(YES);
        
        // Configuring the loading dataset
        make.displayScene(@"loading")
        .image(loadingImage)
        .title(titleStr, titleFont, titleColor)
        .describe(describeStr, describeFont, describeColor)
        .buttonTitle(buttonStr, buttonFont, buttonNormalColor, UIControlStateNormal)
        .buttonTitle(buttonStr, buttonFont, buttonHighLightColor, UIControlStateHighlighted)
        .backgroundColor([UIColor colorWithHex:@"f0f3f5"])
        .imageAnimation(animation)
        .allowImageAnimate(YES)
        .allowScroll(YES)
        .allowTouch(YES);
        
    }] emptySceneChange:^(DZNDisplayScene type) {
        // do something
    }] emptyViewLifeCycle:^(DZNEmptyViewLifeCycle status) {
        // do something
    }] emptyDisplayClick:^(DZNTapType tapType, UIScrollView *scrollView, UIView *view) {
        // Click to switch scenarios
        [weakSelf.tableView reloadData: @"loading"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData: @"dropbox"];
        });
    }];
    
    // Show a view of the Dropbox scene
    [self.tableView reloadData: @"dropbox"];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"app_cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

@end
