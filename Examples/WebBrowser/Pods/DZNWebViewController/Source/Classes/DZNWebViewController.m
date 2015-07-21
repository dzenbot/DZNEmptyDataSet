//
//  DZNWebViewController.m
//  DZNWebViewController
//  https://github.com/dzenbot/DZNWebViewController
//
//  Created by Ignacio Romero Zurbuchen on 10/25/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "DZNWebViewController.h"
#import "DZNPolyActivity.h"

#define DZN_IS_IPAD [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define DZN_IS_LANDSCAPE ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)

static char DZNWebViewControllerKVOContext = 0;

@interface DZNWebViewController ()

@property (nonatomic, strong) UIBarButtonItem *backwardBarItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarItem;
@property (nonatomic, strong) UIBarButtonItem *stateBarItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarItem;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILongPressGestureRecognizer *backwardLongPress;
@property (nonatomic, strong) UILongPressGestureRecognizer *forwardLongPress;

@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, weak) UINavigationBar *navigationBar;
@property (nonatomic, weak) UIView *navigationBarSuperView;

@end

@implementation DZNWebViewController
@synthesize URL = _URL;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    NSParameterAssert(URL);

    self = [self init];
    if (self) {
        _URL = URL;
    }
    return self;
}

- (instancetype)initWithFileURL:(NSURL *)URL
{
    return [self initWithURL:URL];
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    self.supportedWebNavigationTools = DZNWebNavigationToolAll;
    self.supportedWebActions = DZNWebActionAll;
    self.showLoadingProgress = YES;
    self.hideBarsWithGestures = YES;
    self.allowHistory = YES;
}


#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view = self.webView;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView performWithoutAnimation:^{
        static dispatch_once_t willAppearConfig;
        dispatch_once(&willAppearConfig, ^{
            [self configureToolBars];
        });
    }];
    
    if (!self.webView.URL) {
        [self loadURL:self.URL];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t didAppearConfig;
    dispatch_once(&didAppearConfig, ^{
        [self configureBarItemsGestures];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [self clearProgressViewAnimated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [self.webView stopLoading];
}


#pragma mark - Getter methods

- (DZNWebView *)webView
{
    if (!_webView)
    {
        DZNWebView *webView = [[DZNWebView alloc] initWithFrame:self.view.bounds configuration:[WKWebViewConfiguration new]];
        webView.backgroundColor = [UIColor whiteColor];
        webView.allowsBackForwardNavigationGestures = YES;
        webView.UIDelegate = self;
        webView.navDelegate = self;
        webView.scrollView.delegate = self;
        
        _webView = webView;
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        CGFloat lineHeight = 2.0f;
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.navigationBar.bounds) - lineHeight, CGRectGetWidth(self.navigationBar.bounds), lineHeight);
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:frame];
        progressView.trackTintColor = [UIColor clearColor];
        progressView.alpha = 0.0f;
        
        [self.navigationBar addSubview:progressView];
        
        _progressView = progressView;
    }
    return _progressView;
}

- (UIBarButtonItem *)backwardBarItem
{
    if (!_backwardBarItem)
    {
        _backwardBarItem = [[UIBarButtonItem alloc] initWithImage:[self backwardButtonImage] landscapeImagePhone:nil style:0 target:self action:@selector(goBackward:)];
        _backwardBarItem.accessibilityLabel = NSLocalizedStringFromTable(@"Backward", @"DZNWebViewController", @"Accessibility label button title");
        _backwardBarItem.enabled = NO;
    }
    return _backwardBarItem;
}

- (UIBarButtonItem *)forwardBarItem
{
    if (!_forwardBarItem)
    {
        _forwardBarItem = [[UIBarButtonItem alloc] initWithImage:[self forwardButtonImage] landscapeImagePhone:nil style:0 target:self action:@selector(goForward:)];
        _forwardBarItem.landscapeImagePhone = nil;
        _forwardBarItem.accessibilityLabel = NSLocalizedStringFromTable(@"Forward", @"DZNWebViewController", @"Accessibility label button title");
        _forwardBarItem.enabled = NO;
    }
    return _forwardBarItem;
}

- (UIBarButtonItem *)stateBarItem
{
    if (!_stateBarItem)
    {
        _stateBarItem = [[UIBarButtonItem alloc] initWithImage:nil landscapeImagePhone:nil style:0 target:nil action:nil];
        [self updateStateBarItem];
    }
    return _stateBarItem;
}

- (UIBarButtonItem *)actionBarItem
{
    if (!_actionBarItem)
    {
        _actionBarItem = [[UIBarButtonItem alloc] initWithImage:[self actionButtonImage] landscapeImagePhone:nil style:0 target:self action:@selector(presentActivityController:)];
        _actionBarItem.accessibilityLabel = NSLocalizedStringFromTable(@"Share", @"DZNWebViewController", @"Accessibility label button title");
        _actionBarItem.enabled = NO;
    }
    return _actionBarItem;
}

- (NSArray *)navigationToolItems
{
    NSMutableArray *items = [NSMutableArray new];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    if ((self.supportedWebNavigationTools & DZNWebNavigationToolBackward) > 0 || self.supportsAllNavigationTools) {
        [items addObject:self.backwardBarItem];
    }
    
    if ((self.supportedWebNavigationTools & DZNWebNavigationToolForward) > 0 || self.supportsAllNavigationTools) {
        if (!DZN_IS_IPAD) [items addObject:flexibleSpace];
        [items addObject:self.forwardBarItem];
    }
    
    if ((self.supportedWebNavigationTools & DZNWebNavigationToolStopReload) > 0 || self.supportsAllNavigationTools) {
        if (!DZN_IS_IPAD) [items addObject:flexibleSpace];
        [items addObject:self.stateBarItem];
    }
    
    if (self.supportedWebActions > 0) {
        if (!DZN_IS_IPAD) [items addObject:flexibleSpace];
        [items addObject:self.actionBarItem];
    }
    
    return items;
}

- (BOOL)supportsAllNavigationTools
{
    return (_supportedWebNavigationTools == DZNWebNavigationToolAll) ? YES : NO;
}

- (UIImage *)backwardButtonImage
{
    if (!_backwardButtonImage) {
        _backwardButtonImage = [UIImage imageNamed:@"dzn_icn_toolbar_backward" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil];
    }
    return _backwardButtonImage;
}

- (UIImage *)forwardButtonImage
{
    if (!_forwardButtonImage) {
        _forwardButtonImage = [UIImage imageNamed:@"dzn_icn_toolbar_forward" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil];
    }
    return _forwardButtonImage;
}

- (UIImage *)reloadButtonImage
{
    if (!_reloadButtonImage) {
        _reloadButtonImage = [UIImage imageNamed:@"dzn_icn_toolbar_reload" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil];
    }
    return _reloadButtonImage;
}

- (UIImage *)stopButtonImage
{
    if (!_stopButtonImage) {
        _stopButtonImage = [UIImage imageNamed:@"dzn_icn_toolbar_stop" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil];
    }
    return _stopButtonImage;
}

- (UIImage *)actionButtonImage
{
    if (!_actionButtonImage) {
        _actionButtonImage = [UIImage imageNamed:@"dzn_icn_toolbar_action" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil];
    }
    return _actionButtonImage;
}

- (NSArray *)applicationActivitiesForItem:(id)item
{
    NSMutableArray *activities = [NSMutableArray new];
    
    if ([item isKindOfClass:[UIImage class]]) {
        return activities;
    }
    
    if ((_supportedWebActions & DZNWebActionCopyLink) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeLink]];
    }
    if ((_supportedWebActions & DZNWebActionOpenSafari) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeSafari]];
    }
    if ((_supportedWebActions & DZNWebActionOpenChrome) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeChrome]];
    }
    if ((_supportedWebActions & DZNWebActionOpenOperaMini) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeOpera]];
    }
    if ((_supportedWebActions & DZNWebActionOpenDolphin) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeDolphin]];
    }
    
    return activities;
}

- (NSArray *)excludedActivityTypesForItem:(id)item
{
    NSMutableArray *types = [NSMutableArray new];
    
    if (![item isKindOfClass:[UIImage class]]) {
        [types addObjectsFromArray:@[UIActivityTypeCopyToPasteboard,
                                     UIActivityTypeSaveToCameraRoll,
                                     UIActivityTypePostToFlickr,
                                     UIActivityTypePrint,
                                     UIActivityTypeAssignToContact]];
    }
    
    if (self.supportsAllActions) {
        return types;
    }
    
    if ((_supportedWebActions & DZNsupportedWebActionshareLink) == 0) {
        [types addObjectsFromArray:@[UIActivityTypeMail, UIActivityTypeMessage,
                                     UIActivityTypePostToFacebook, UIActivityTypePostToTwitter,
                                     UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo,
                                     UIActivityTypeAirDrop]];
    }
    if ((_supportedWebActions & DZNWebActionReadLater) == 0 && [item isKindOfClass:[UIImage class]]) {
        [types addObject:UIActivityTypeAddToReadingList];
    }
    
    return types;
}

- (BOOL)supportsAllActions
{
    return (_supportedWebActions == DZNWebActionAll) ? YES : NO;
}


#pragma mark - Setter methods

- (void)setURL:(NSURL *)URL
{
    if ([self.URL isEqual:URL]) {
        return;
    }
    
    if (self.isViewLoaded) {
        [self loadURL:URL];
    }
    
    _URL = URL;
}

- (void)setTitle:(NSString *)title
{
    NSString *url = self.webView.URL.absoluteString;
    
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    
    if (!label || ![label isKindOfClass:[UILabel class]]) {
        label = [UILabel new];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.navigationItem.titleView = label;
    }
    
    if (title.length == 0) {
        label.attributedText = nil;
        return;
    }
    
    UIFont *titleFont = self.navigationBar.titleTextAttributes[NSFontAttributeName] ?: [UIFont boldSystemFontOfSize:12.0];
    UIFont *urlFont = [UIFont fontWithName:titleFont.fontName size:titleFont.pointSize-2.0];
    UIColor *textColor = self.navigationBar.titleTextAttributes[NSForegroundColorAttributeName] ?: [UIColor blackColor];
    
    NSMutableString *text = [NSMutableString stringWithString:title];
    
    if (url.length > 0) {
        [text appendFormat:@"\n%@", url];
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: titleFont, NSForegroundColorAttributeName: textColor};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    if (url.length > 0) {
        [attributedString addAttribute:NSFontAttributeName value:urlFont range:[text rangeOfString:url]];
    }
    
    label.attributedText = attributedString;
    [label sizeToFit];
    
    CGRect frame = label.frame;
    frame.size.height = CGRectGetHeight(self.navigationController.navigationBar.frame);
    label.frame = frame;
}

// Sets the request errors with an alert view.
- (void)setLoadingError:(NSError *)error
{
    switch (error.code) {
        case NSURLErrorUnknown:
        case NSURLErrorCancelled:   return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
}


#pragma mark - DZNWebViewController methods

- (void)loadURL:(NSURL *)URL
{
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:URL.path.stringByDeletingLastPathComponent isDirectory:YES];
    [self loadURL:URL baseURL:baseURL];
}

- (void)loadURL:(NSURL *)URL baseURL:(NSURL *)baseURL
{
    if ([URL isFileURL]) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
        NSString *HTMLString = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];

        [self.webView loadHTMLString:HTMLString baseURL:baseURL];
    }
    else {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        [self.webView loadRequest:request];
    }
}

- (void)goBackward:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)goForward:(id)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)dismissHistoryController
{
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            
            // The bar button item's gestures are invalidated after using them, so we must re-assign them.
            [self configureBarItemsGestures];
        }];
    }
}

- (void)showBackwardHistory:(UIGestureRecognizer *)sender
{
    if (!self.allowHistory || self.webView.backForwardList.backList.count == 0 || sender.state != UIGestureRecognizerStateBegan) {
        return;
    }

    [self presentHistoryControllerForTool:DZNWebNavigationToolBackward fromView:sender.view];
}

- (void)showForwardHistory:(UIGestureRecognizer *)sender
{
    if (!self.allowHistory || self.webView.backForwardList.forwardList.count == 0 || sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self presentHistoryControllerForTool:DZNWebNavigationToolForward fromView:sender.view];
}

- (void)presentHistoryControllerForTool:(DZNWebNavigationTools)tool fromView:(UIView *)view
{
    UITableViewController *controller = [UITableViewController new];
    controller.title = NSLocalizedStringFromTable(@"History", @"DZNWebViewController", nil);
    controller.tableView.delegate = self;
    controller.tableView.dataSource = self;
    controller.tableView.tag = tool;
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissHistoryController)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    UIView *bar = DZN_IS_IPAD ? self.navigationBar : self.toolbar;
    
    if (DZN_IS_IPAD) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        [popover presentPopoverFromRect:view.frame inView:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

- (void)configureToolBars
{
    if (DZN_IS_IPAD) {
        self.navigationItem.rightBarButtonItems = [[[self navigationToolItems] reverseObjectEnumerator] allObjects];
    }
    else {
        [self setToolbarItems:[self navigationToolItems]];
    }
    
    self.toolbar = self.navigationController.toolbar;
    self.navigationBar = self.navigationController.navigationBar;
    self.navigationBarSuperView = self.navigationBar.superview;
    
    self.navigationController.hidesBarsOnSwipe = self.hideBarsWithGestures;
    self.navigationController.hidesBarsWhenKeyboardAppears = self.hideBarsWithGestures;
    self.navigationController.hidesBarsWhenVerticallyCompact = self.hideBarsWithGestures;

    if (self.hideBarsWithGestures) {
        [self.navigationBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
        [self.navigationBar addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
        [self.navigationBar addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
    }

    if (!DZN_IS_IPAD && self.navigationController.toolbarHidden && self.toolbarItems.count > 0) {
        [self.navigationController setToolbarHidden:NO];
    }
}

// Light hack for adding custom gesture recognizers to UIBarButtonItems
- (void)configureBarItemsGestures
{
    UIView *backwardButton= [self.backwardBarItem valueForKey:@"view"];
    if (backwardButton.gestureRecognizers.count == 0) {
        if (!_backwardLongPress) {
            _backwardLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showBackwardHistory:)];
        }
        [backwardButton addGestureRecognizer:self.backwardLongPress];
    }
    
    UIView *forwardBarButton= [self.forwardBarItem valueForKey:@"view"];
    if (forwardBarButton.gestureRecognizers.count == 0) {
        if (!_forwardLongPress) {
            _forwardLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showForwardHistory:)];
        }
        [forwardBarButton addGestureRecognizer:self.forwardLongPress];
    }
}

- (void)updateToolbarItems
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self.webView isLoading]];

    self.backwardBarItem.enabled = [self.webView canGoBack];
    self.forwardBarItem.enabled = [self.webView canGoForward];
    
    self.actionBarItem.enabled = !self.webView.isLoading;
    
    [self updateStateBarItem];
}

- (void)updateStateBarItem
{
    self.stateBarItem.target = self.webView;
    self.stateBarItem.action = self.webView.isLoading ? @selector(stopLoading) : @selector(reload);
    self.stateBarItem.image = self.webView.isLoading ? self.stopButtonImage : self.reloadButtonImage;
    self.stateBarItem.landscapeImagePhone = nil;
    self.stateBarItem.accessibilityLabel = NSLocalizedStringFromTable(self.webView.isLoading ? @"Stop" : @"Reload", @"DZNWebViewController", @"Accessibility label button title");
    self.stateBarItem.enabled = YES;
}

- (void)presentActivityController:(id)sender
{
    if (!self.webView.URL.absoluteString) {
        return;
    }
    
    [self presentActivityControllerWithItem:self.webView.URL.absoluteString andTitle:self.webView.title sender:sender];
}

- (void)presentActivityControllerWithItem:(id)item andTitle:(NSString *)title sender:(id)sender
{
    if (!item) {
        return;
    }
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[title, item] applicationActivities:[self applicationActivitiesForItem:item]];
    controller.excludedActivityTypes = [self excludedActivityTypesForItem:item];
    
    if (title) {
        [controller setValue:title forKey:@"subject"];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        controller.popoverPresentationController.barButtonItem = sender;
    }
    
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)clearProgressViewAnimated:(BOOL)animated
{
    if (!_progressView) {
        return;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0
                     animations:^{
                         self.progressView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self destroyProgressViewIfNeeded];
                     }];
}

- (void)destroyProgressViewIfNeeded
{
    if (_progressView) {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
}


#pragma mark - DZNNavigationDelegate methods

- (void)webView:(DZNWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self updateStateBarItem];
}

- (void)webView:(DZNWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self.webView isLoading]];
}

- (void)webView:(DZNWebView *)webView didUpdateProgress:(CGFloat)progress
{
    if (!self.showLoadingProgress) {
        [self destroyProgressViewIfNeeded];
        return;
    }
    
    if (self.progressView.alpha == 0 && progress > 0) {
        
        self.progressView.progress = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.alpha = 1.0;
        }];
    }
    else if (self.progressView.alpha == 1.0 && progress == 1.0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.progressView.progress = 0;
        }];
    }
    
    [self.progressView setProgress:progress animated:YES];
}

- (void)webView:(DZNWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self updateToolbarItems];
    
    self.title = self.webView.title;
}

- (void)webView:(DZNWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self updateToolbarItems];
    [self setLoadingError:error];
    
    self.title = nil;
}


#pragma mark - WKUIDelegate methods

- (DZNWebView *)webView:(DZNWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == DZNWebNavigationToolBackward) {
        return self.webView.backForwardList.backList.count;
    }
    if (tableView.tag == DZNWebNavigationToolForward) {
        return self.webView.backForwardList.forwardList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    WKBackForwardListItem *item = nil;
    
    if (tableView.tag == DZNWebNavigationToolBackward) {
        item = [self.webView.backForwardList.backList objectAtIndex:indexPath.row];
    }
    if (tableView.tag == DZNWebNavigationToolForward) {
        item = [self.webView.backForwardList.forwardList objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [item.URL absoluteString];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKBackForwardListItem *item = nil;
    
    if (tableView.tag == DZNWebNavigationToolBackward) {
        item = [self.webView.backForwardList.backList objectAtIndex:indexPath.row];
    }
    if (tableView.tag == DZNWebNavigationToolForward) {
        item = [self.webView.backForwardList.forwardList objectAtIndex:indexPath.row];
    }
    
    [self.webView goToBackForwardListItem:item];
    
    [self dismissHistoryController];
}


#pragma mark - Key Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != &DZNWebViewControllerKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([object isEqual:self.navigationBar]) {
        
        // Skips for landscape orientation, since there is no status bar visible on iPhone landscape
        if (DZN_IS_LANDSCAPE) {
            return;
        }
        
        id new = change[NSKeyValueChangeNewKey];
        
        if ([keyPath isEqualToString:@"hidden"] && [new boolValue] && self.navigationBar.center.y >= -2.0) {
            
            self.navigationBar.hidden = NO;
            
            if (!self.navigationBar.superview) {
                [self.navigationBarSuperView addSubview:self.navigationBar];
            }
        }
        
        if ([keyPath isEqualToString:@"center"]) {
            
            CGPoint center = [new CGPointValue];
            
            if (center.y < -2.0) {
                center.y = -2.0;
                self.navigationBar.center = center;
                
                [UIView beginAnimations:@"DZNNavigationBarAnimation" context:nil];
                
                for (UIView *subview in self.navigationBar.subviews) {
                    if (subview != self.navigationBar.subviews[0]) {
                        subview.alpha = 0.0;
                    }
                }
                
                [UIView commitAnimations];
            }
        }
    }
}


#pragma mark - View Auto-Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return NO;
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
    [self.navigationBar removeObserver:self forKeyPath:@"hidden" context:&DZNWebViewControllerKVOContext];
    [self.navigationBar removeObserver:self forKeyPath:@"center" context:&DZNWebViewControllerKVOContext];
    [self.navigationBar removeObserver:self forKeyPath:@"alpha" context:&DZNWebViewControllerKVOContext];
    
    _backwardBarItem = nil;
    _forwardBarItem = nil;
    _stateBarItem = nil;
    _actionBarItem = nil;
    _progressView = nil;
    
    _backwardLongPress = nil;
    _forwardLongPress = nil;
    
    _webView.scrollView.delegate = nil;
    _webView.navDelegate = nil;
    _webView.UIDelegate = nil;
    _webView.scrollView.delegate = nil;
    _webView = nil;
    _URL = nil;
}

@end
