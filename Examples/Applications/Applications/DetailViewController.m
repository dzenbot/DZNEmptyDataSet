//
//  DetailViewController.m
//  Applications
//
//  Created by Ignacio on 6/6/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DetailViewController.h"
#import "UIColor+Hexadecimal.h"

#import "UIScrollView+EmptyDataSet.h"

@interface DetailViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    if (self.application.type == ApplicationTypePinterest) {
        self.tableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_pinterest"]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
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
        case ApplicationTypeCamera:
        {
            barColor = [UIColor colorWithHex:@"595959"];
            barstyle = UIStatusBarStyleLightContent;
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
            break;
        }
        case ApplicationTypeDropbox:
        {
            barColor = [UIColor whiteColor];
            tintColor = [UIColor colorWithHex:@"007ee5"];
            break;
        }
        case ApplicationTypeFacebook:
        {
            barColor = [UIColor colorWithHex:@"506da8"];
            tintColor = [UIColor whiteColor];
            barstyle = UIStatusBarStyleLightContent;
            break;
        }
        case ApplicationTypeFancy:
        {
            barColor = [UIColor colorWithHex:@"353b49"];
            tintColor = [UIColor colorWithHex:@"c4c7cb"];
            barstyle = UIStatusBarStyleLightContent;
            break;
        }
        case ApplicationTypeFoursquare:
        {
            barColor = [UIColor colorWithHex:@"00aeef"];
            tintColor = [UIColor whiteColor];
            barstyle = UIStatusBarStyleLightContent;
            break;
        }
        case ApplicationTypeInstagram:
        {
            barColor = [UIColor colorWithHex:@"2e5e86"];
            tintColor = [UIColor whiteColor];
            barstyle = UIStatusBarStyleLightContent;
            break;
        }
        case ApplicationTypePath:
        {
            barColor = [UIColor colorWithHex:@"544f49"];
            tintColor = [UIColor colorWithHex:@"fffff2"];
            barstyle = UIStatusBarStyleLightContent;
            break;
        }
        case ApplicationTypePinterest:
        {
            barColor = [UIColor colorWithHex:@"f4f4f4"];
            tintColor = [UIColor colorWithHex:@"cb2027"];
            break;
        }
        case ApplicationTypeSlack:
        {
            barColor = [UIColor colorWithHex:@"f4f5f6"];
            tintColor = [UIColor colorWithHex:@"3eba92"];
            break;
        }
        case ApplicationTypeSkype:
        {
            barColor = [UIColor colorWithHex:@"00aff0"];
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
        case ApplicationTypeTwitter:
        {
            barColor = [UIColor colorWithHex:@"58aef0"];
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
        case ApplicationTypeVideos:
        {
            barColor = [UIColor colorWithHex:@"4a4b4d"];
            tintColor = [UIColor blackColor];
            break;
        }
        case ApplicationTypeVine:
        {
            barColor = [UIColor colorWithHex:@"00bf8f"];
            tintColor = [UIColor whiteColor];
            barstyle = UIStatusBarStyleLightContent;
            break;
        }
        default:
            barColor = [UIColor colorWithHex:@"f8f8f8"];
            tintColor = [UIApplication sharedApplication].keyWindow.tintColor;
            break;
    }
    
    UIImage *logo = [UIImage imageNamed:[NSString stringWithFormat:@"logo_%@", [self.application.displayName lowercaseString]]];
    if (logo) self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    self.navigationController.navigationBar.barTintColor = barColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    
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


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    switch (self.application.type) {
        case ApplicationTypeAirbnb:
        {
            text = @"No Messages";
            font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
            textColor = [UIColor colorWithHex:@"c9c9c9"];
            break;
        }
        case ApplicationTypeCamera:
        {
            text = @"Please Allow Photo Access";
            font = [UIFont boldSystemFontOfSize:18.0];
            textColor = [UIColor colorWithHex:@"5f6978"];
            break;
        }
        case ApplicationTypeDropbox:
        {
            text = @"Star Your Favorite Files";
            font = [UIFont boldSystemFontOfSize:17.0];
            textColor = [UIColor colorWithHex:@"25282b"];
            break;
        }
        case ApplicationTypeFacebook:
        {
            text = @"No friends to show.";
            font = [UIFont boldSystemFontOfSize:22.0];
            textColor = [UIColor colorWithHex:@"acafbd"];
            
            NSShadow *shadow = [NSShadow new];
            shadow.shadowColor = [UIColor whiteColor];
            shadow.shadowOffset = CGSizeMake(0.0, 1.0);
            [attributes setObject:shadow forKey:NSShadowAttributeName];
            break;
        }
        case ApplicationTypeFancy:
        {
            text = @"No Owns yet";
            font = [UIFont boldSystemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:@"494c53"];
            break;
        }
        case ApplicationTypeiCloud:
        {
            text = @"iCloud Photo Sharing";
            break;
        }
        case ApplicationTypeInstagram:
        {
            text = @"Instagram Direct";
            font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0];
            textColor = [UIColor colorWithHex:@"444444"];
            break;
        }
        case ApplicationTypePath:
        {
            text = @"Message Your Friends";
            font = [UIFont boldSystemFontOfSize:14.0];
            textColor = [UIColor whiteColor];
            break;
        }
        case ApplicationTypePinterest:
        {
            text = @"No boards to display";
            font = [UIFont boldSystemFontOfSize:18.0];
            textColor = [UIColor colorWithHex:@"666666"];
            break;
        }
        case ApplicationTypePhotos:
        {
            text = @"No Photos or Videos";
            break;
        }
        case ApplicationTypeTumblr:
        {
            text = @"This is your Dashboard.";
            font = [UIFont boldSystemFontOfSize:18.0];
            textColor = [UIColor colorWithHex:@"aab6c4"];
            break;
        }
        case ApplicationTypeTwitter:
        {
            text = @"No lists";
            font = [UIFont boldSystemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:@"292f33"];
            break;
        }
        case ApplicationTypeVesper:
        {
            text = @"No Notes";
            font = [UIFont fontWithName:@"IdealSans-Medium" size:16.0];
            textColor = [UIColor colorWithHex:@"d9dce1"];
            break;
        }
        case ApplicationTypeVideos:
        {
            text = @"AirPlay";
            font = [UIFont systemFontOfSize:17.0];
            textColor = [UIColor colorWithHex:@"414141"];
            break;
        }
        case ApplicationTypeVine:
        {
            text = @"Welcome to VMs";
            font = [UIFont boldSystemFontOfSize:22.0];
            textColor = [UIColor colorWithHex:@"595959"];
            [attributes setObject:@(0.45) forKey:NSKernAttributeName];
            break;
        }
        case ApplicationTypeWhatsapp:
        {
            text = @"No Media";
            font = [UIFont systemFontOfSize:20.0];
            textColor = [UIColor colorWithHex:@"808080"];
            break;
        }
        default:
            return nil;
    }
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
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
        case ApplicationTypeAppstore:
        {
            text = @"There are no results for “wwdc2014”.";
            font = [UIFont systemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:@"333333"];
            break;
        }
        case ApplicationTypeCamera:
        {
            text = @"This allows you to share photos from your library and save photos to your camera roll.";
            font = [UIFont systemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:@"5f6978"];
            break;
        }
        case ApplicationTypeDropbox:
        {
            text = @"Favorites are saved for offline access.";
            font = [UIFont systemFontOfSize:14.5];
            textColor = [UIColor colorWithHex:@"7b8994"];
            break;
        }
        case ApplicationTypeFancy:
        {
            text = @"Tap Add to List and add things to Owns";
            font = [UIFont systemFontOfSize:13.0];
            textColor = [UIColor colorWithHex:@"7a7d83"];
            break;
        }
        case ApplicationTypeFoursquare:
        {
            text = @"Nobody has liked or commented on your check-ins yet.";
            font = [UIFont boldSystemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:@"cecbc6"];
            break;
        }
        case ApplicationTypeiCloud:
        {
            text = @"Share photos and videos with\njust the people you choose,\nand let them add photos,\nvideos, and comments.";
            paragraph.lineSpacing = 2.0;
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
        case ApplicationTypePath:
        {
            text = @"Send a message or create a group.";
            font = [UIFont systemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:@"a6978d"];
            break;
        }
        case ApplicationTypePhotos:
        {
            text = @"You can sync photos and videos onto your iPhone using iTunes.";
            break;
        }
        case ApplicationTypeSafari:
        {
            text = @"Safari cannot open the page because your iPhone is not connected to the Internet.";
            textColor = [UIColor colorWithHex:@"7d7f7f"];
            paragraph.lineSpacing = 2.0;
            break;
        }
        case ApplicationTypeSkype:
        {
            text = @"Keep all your favorite people\ntogether, add favorites.";
            font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.75];
            textColor = [UIColor colorWithHex:@"a6c3d1"];
            paragraph.lineSpacing = 3.0;
            break;
        }
        case ApplicationTypeSlack:
        {
            text = @"You don't have any\nrecent mentions";
            font = [UIFont fontWithName:@"Lato-Regular" size:19.0];
            textColor = [UIColor colorWithHex:@"d7d7d7"];
            break;
        }
        case ApplicationTypeTumblr:
        {
            text = @"When you follow some blogs, their latest posts will show up here!";
            font = [UIFont systemFontOfSize:17.0];
            textColor = [UIColor colorWithHex:@"828e9c"];
            break;
        }
        case ApplicationTypeTwitter:
        {
            text = @"You aren’t subscribed to any lists yet.";
            font = [UIFont systemFontOfSize:12.0];
            textColor = [UIColor colorWithHex:@"8899a6"];
            break;
        }
        case ApplicationTypeVideos:
        {
            text = @"This video is playing on “Apple TV”.";
            font = [UIFont systemFontOfSize:12.0];
            textColor = [UIColor colorWithHex:@"737373"];
            break;
        }
        case ApplicationTypeVine:
        {
            text = @"This is where your private conversations will live";
            font = [UIFont systemFontOfSize:17.0];
            textColor = [UIColor colorWithHex:@"a6a6a6"];
            break;
        }
        case ApplicationTypeWhatsapp:
        {
            text = @"You can exchange media with Ignacio by tapping on the Arrow Up icon in the conversation screen.";
            font = [UIFont systemFontOfSize:15.0];
            textColor = [UIColor colorWithHex:@"989898"];
            break;
        }
        default:
            return nil;
    }
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    switch (self.application.type) {
        case ApplicationTypeSkype:
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"00adf1"] range:[attributedString.string rangeOfString:@"add favorites"]];
            break;
            
        default:
            break;
    }
    
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = [[NSString stringWithFormat:@"placeholder_%@", self.application.displayName] lowercaseString];
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    switch (self.application.type) {
        case ApplicationTypeAirbnb:
        {
            text = @"Start Browsing";
            font = [UIFont boldSystemFontOfSize:16.0];
            textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"05adff" : @"6bceff"];
            break;
        }
        case ApplicationTypeCamera:
        {
            text = @"Continue";
            font = [UIFont boldSystemFontOfSize:17.0];
            textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"007ee5" : @"48a1ea"];
            break;
        }
        case ApplicationTypeDropbox:
        {
            text = @"Learn more";
            font = [UIFont systemFontOfSize:15.0];
            textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"007ee5" : @"48a1ea"];
            break;
        }
        case ApplicationTypeFoursquare:
        {
            text = @"Add friends to get started!";
            font = [UIFont boldSystemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"00aeef" : @"ffffff"];
            break;
        }
        case ApplicationTypeiCloud:
        {
            text = @"Create New Stream";
            font = [UIFont systemFontOfSize:14.0];
            textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"999999" : @"ebebeb"];
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
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = [[NSString stringWithFormat:@"button_background_%@", self.application.displayName] lowercaseString];
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    switch (self.application.type) {
        case ApplicationTypeiCloud:
            rectInsets = UIEdgeInsetsMake(-19.0, -61.0, -19.0, -61.0);
            break;
            
        case ApplicationTypeFoursquare:
            capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
            rectInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10);
            break;
            
        default:
            break;
    }

    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    switch (self.application.type) {
        case ApplicationTypeAirbnb:     return [UIColor whiteColor];
        case ApplicationTypeDropbox:    return [UIColor colorWithHex:@"f0f3f5"];
        case ApplicationTypeFacebook:   return [UIColor colorWithHex:@"eceef7"];
        case ApplicationTypeFancy:      return [UIColor colorWithHex:@"f0f0f0"];
        case ApplicationTypeFoursquare: return [UIColor colorWithHex:@"fcfcfa"];
        case ApplicationTypeInstagram:  return [UIColor whiteColor];
        case ApplicationTypePath:       return [UIColor colorWithHex:@"726d67"];
        case ApplicationTypePinterest:  return [UIColor colorWithHex:@"e1e1e1"];
        case ApplicationTypeSlack:      return [UIColor whiteColor];
        case ApplicationTypeTumblr:     return [UIColor colorWithHex:@"34465c"];
        case ApplicationTypeTwitter:    return [UIColor colorWithHex:@"f5f8fa"];
        case ApplicationTypeVesper:     return [UIColor colorWithHex:@"f8f8f8"];
        case ApplicationTypeVideos:     return [UIColor blackColor];
        case ApplicationTypeWhatsapp:   return [UIColor colorWithHex:@"f2f2f2"];
        default:                        return nil;
    }
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.application.type == ApplicationTypePinterest) {
        return CGPointMake(0, self.tableView.tableHeaderView.frame.size.height/2);
    }
    return CGPointZero;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    switch (self.application.type) {
        case ApplicationTypeAirbnb:     return 24.0;
        case ApplicationTypeAppstore:   return 34.0;
        case ApplicationTypeFacebook:   return 30.0;
        case ApplicationTypeFancy:      return 1.0;
        case ApplicationTypeFoursquare: return 9.0;
        case ApplicationTypeInstagram:  return 24.0;
        case ApplicationTypePath:       return 1.0;
        case ApplicationTypeTumblr:     return 10.0;
        case ApplicationTypeTwitter:    return 0.1;
        case ApplicationTypeVesper:     return 22.0;
        case ApplicationTypeVideos:     return 0.1;
        case ApplicationTypeVine:       return 0.1;
        default:                        return 0.0;
    }
}


#pragma mark - DZNEmptyDataSetDelegate Methods

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
    NSLog(@"%s",__FUNCTION__);
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
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
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
}


#pragma mark - View Auto-Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
