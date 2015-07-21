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

#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>

#define kDZNWebViewControllerContentTypeImage @"image"
#define kDZNWebViewControllerContentTypeLink @"link"

@interface DZNLongPressGestureRecognizer : UILongPressGestureRecognizer
@end

@implementation DZNLongPressGestureRecognizer
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}
@end

@interface DZNWebViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgress *_progressProxy;
    
    UIBarButtonItem *_actionBarItem;
    UIBarButtonItem *_backwardBarItem;
    UIBarButtonItem *_forwardBarItem;
    UIBarButtonItem *_loadingBarItem;
    
    int _loadBalance;
    BOOL _didLoadContent;
    BOOL _presentingActivities;
}
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation DZNWebViewController
@synthesize URL = _URL;

- (id)init
{
    self = [super init];
    if (self) {
        _loadingStyle = DZNWebViewControllerLoadingStyleProgressView;
        _supportedActions = DZNWebViewControllerActionAll;
        _toolbarBackgroundColor = [UIColor blackColor];
        _toolbarTintColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL
{
    NSParameterAssert(URL);
    NSAssert(URL != nil, @"Invalid URL");
    NSAssert(URL.scheme != nil, @"URL has no scheme");

    self = [self init];
    if (self) {
        _URL = URL;
    }
    return self;
}

- (id)initWithFileURL:(NSURL *)URL
{
    return [self initWithURL:URL];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.supportedActions > 0) {
        _actionBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(presentActivityController:)];
        [self.navigationItem setRightBarButtonItem:_actionBarItem];
    }
    
    self.view = self.webView;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setToolbarItems:self.navigationItems animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];

    self.navigationController.toolbar.barTintColor = _toolbarBackgroundColor;
    self.navigationController.toolbar.tintColor = _toolbarTintColor;
    self.navigationController.toolbar.translucent = NO;
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(handleInteractivePopGesture:)];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_didLoadContent) {
        [self startRequestWithURL:_URL];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [self clearProgressViewAnimated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    [self stopLoading];
}


#pragma mark - Getter methods

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        
        if (_loadingStyle == DZNWebViewControllerLoadingStyleProgressView)
        {
            _progressProxy = [[NJKWebViewProgress alloc] init];
            _webView.delegate = _progressProxy;
            _progressProxy.webViewProxyDelegate = self;
            _progressProxy.progressDelegate = self;
        }
        else {
            _webView.delegate = self;
        }
        
        DZNLongPressGestureRecognizer *gesture = [[DZNLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        gesture.allowableMovement = 20;
        gesture.delegate = self;
        [_webView addGestureRecognizer:gesture];
    }
    return _webView;
}

- (NJKWebViewProgressView *)progressView
{
    if (!_progressView && _loadingStyle == DZNWebViewControllerLoadingStyleProgressView)
    {
        CGFloat progressBarHeight = 2.5f;
        CGSize navigationBarSize = self.navigationController.navigationBar.bounds.size;
        CGRect barFrame = CGRectMake(0, navigationBarSize.height - progressBarHeight, navigationBarSize.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        
        [self.navigationController.navigationBar addSubview:_progressView];
    }
    return _progressView;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.color = _toolbarTintColor;
    }
    return _activityIndicatorView;
}

- (NSArray *)navigationItems
{
    _backwardBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_backward"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    _backwardBarItem.enabled = NO;
    
    _forwardBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward:)];
    _forwardBarItem.enabled = NO;
    
    if (_loadingStyle == DZNWebViewControllerLoadingStyleActivityIndicator) {
        _loadingBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    fixedSpace.width = 20.0;
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:@[_backwardBarItem,fixedSpace,_forwardBarItem,flexibleSpace]];
    if (_loadingBarItem) {
        [items addObject:_loadingBarItem];
    }
    
    return items;
}

- (UIFont *)titleFont
{
    if (!_titleFont) {
        return [[UINavigationBar appearance].titleTextAttributes objectForKey:NSFontAttributeName];
    }
    
    return _titleFont;
}

- (UIColor *)titleColor
{
    if (!_titleColor) {
        return [[UINavigationBar appearance].titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    }
    
    return _titleColor;
}

- (NSString *)pageTitle
{
    NSString *js = @"document.body.style.webkitTouchCallout = 'none'; document.getElementsByTagName('title')[0].textContent;";
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:js];
    return [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSURL *)URL
{
    return _webView.request.URL;
}

- (CGSize)HTLMWindowSize
{
    CGSize size = CGSizeZero;
    size.width = [[_webView stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] floatValue];
    size.height = [[_webView stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] floatValue];
    return size;
}

- (CGPoint)convertPointToHTMLSystem:(CGPoint)point
{
    CGSize viewSize = _webView.frame.size;
    CGSize windowSize = [self HTLMWindowSize];
    
    CGPoint scaledPoint = CGPointZero;
    CGFloat factor = windowSize.width / viewSize.width;
    
    scaledPoint.x = point.x * factor;
    scaledPoint.y = point.y * factor;
    
    return scaledPoint;
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
    
    if ((_supportedActions & DZNWebViewControllerActionShareLink) == 0) {
        [types addObjectsFromArray:@[UIActivityTypeMail, UIActivityTypeMessage,
                                     UIActivityTypePostToFacebook, UIActivityTypePostToTwitter,
                                     UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo,
                                     UIActivityTypeAirDrop]];
    }
    if ((_supportedActions & DZNWebViewControllerActionReadLater) == 0 && [item isKindOfClass:[UIImage class]]) {
        [types addObject:UIActivityTypeAddToReadingList];
    }
    
    return types;
}

- (NSArray *)applicationActivitiesForItem:(id)item
{
    NSMutableArray *activities = [NSMutableArray new];
    
    if ([item isKindOfClass:[UIImage class]]) {
        return activities;
    }
    
    if ((_supportedActions & DZNWebViewControllerActionCopyLink) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeLink]];
    }
    if ((_supportedActions & DZNWebViewControllerActionOpenSafari) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeSafari]];
    }
    if ((_supportedActions & DZNWebViewControllerActionOpenChrome) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeChrome]];
    }
    if ((_supportedActions & DZNWebViewControllerActionOpenOperaMini) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeOpera]];
    }
    if ((_supportedActions & DZNWebViewControllerActionOpenDolphin) > 0 || self.supportsAllActions) {
        [activities addObject:[DZNPolyActivity activityWithType:DZNPolyActivityTypeDolphin]];
    }
    
    return activities;
}

- (BOOL)supportsAllActions
{
    return (_supportedActions == DZNWebViewControllerActionAll) ? YES : NO;
}


#pragma mark - Setter methods

- (void)setURL:(NSURL *)URL
{
    [self startRequestWithURL:URL];
}

- (void)setViewTitle:(NSString *)title
{
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    
    if (!label || ![label isKindOfClass:[UILabel class]]) {
        label = [UILabel new];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.titleFont;
        label.textColor = self.titleColor;
        self.navigationItem.titleView = label;
    }
    
    if (title) {
        label.text = title;
        [label sizeToFit];
        
        CGRect frame = label.frame;
        frame.size.height = self.navigationController.navigationBar.frame.size.height;
        label.frame = frame;
    }
}

/*
 * Sets the request errors with an alert view.
 */
- (void)setLoadingError:(NSError *)error
{
    switch (error.code) {
//        case NSURLErrorTimedOut:
        case NSURLErrorUnknown:
        case NSURLErrorCancelled:
            return;
    }
    
    [self setActivityIndicatorsVisible:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
}

/*
 * Toggles the activity indicators on the status bar & footer view.
 */
- (void)setActivityIndicatorsVisible:(BOOL)visible
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    
    if (_loadingStyle != DZNWebViewControllerLoadingStyleActivityIndicator) {
        return;
    }
    
    if (visible) [_activityIndicatorView startAnimating];
    else [_activityIndicatorView stopAnimating];
}


#pragma mark - DZNWebViewController methods

- (void)startRequestWithURL:(NSURL *)URL
{
    _loadBalance = 0;
    
    if (![self.webView.request.URL isFileURL]) {
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:URL]];
    }
    else {
        NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
        NSString *HTMLString = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
        
        [_webView loadHTMLString:HTMLString baseURL:nil];
    }
}

- (void)goBack:(id)sender
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (void)goForward:(id)sender
{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (void)presentActivityController:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
    
    NSString *type = kDZNWebViewControllerContentTypeLink;
    NSString *title = [self pageTitle];
    NSString *url = [self URL].absoluteString;
    
    NSLog(@"type : %@", type);
    NSLog(@"title : %@", title);
    NSLog(@"url : %@", url);
    
    NSDictionary *content = @{@"title": [self pageTitle], @"url": [self URL].absoluteString, @"type": kDZNWebViewControllerContentTypeLink};
    [self presentActivityControllerWithContent:content];
}

- (void)presentActivityControllerWithContent:(NSDictionary *)content
{
    if (!content) {
        return;
    }
    
    NSString *type = [content objectForKey:@"type"];
    NSString *title = [content objectForKey:@"title"];
    NSString *url = [content objectForKey:@"url"];
    
    NSLog(@"type : %@", type);
    NSLog(@"title : %@", title);
    NSLog(@"url : %@", url);
    
    if ([type isEqualToString:kDZNWebViewControllerContentTypeLink]) {
        
        [self presentActivityControllerWithItem:url andTitle:title];
    }
    if ([type isEqualToString:kDZNWebViewControllerContentTypeImage]) {
        
        [self setActivityIndicatorsVisible:YES];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self presentActivityControllerWithItem:image andTitle:title];
                [self setActivityIndicatorsVisible:NO];
            });
        });
    }
}

- (void)presentActivityControllerWithItem:(id)item andTitle:(NSString *)title
{
    if (!item) {
        return;
    }
    
    _presentingActivities = YES;
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[title, item] applicationActivities:[self applicationActivitiesForItem:item]];
    
    controller.excludedActivityTypes = [self excludedActivityTypesForItem:item];
    
    if (title) {
        [controller setValue:title forKey:@"subject"];
    }
    
    [self presentViewController:controller animated:YES completion:nil];
    
    controller.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);

        _presentingActivities = NO;
    };
}

- (void)handleLongPressGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [self injectJavaScript];
        
        CGPoint point = [self convertPointToHTMLSystem:[gesture locationInView:_webView]];
        
        //// Get the URL link at the touch location
        NSString *function = [NSString stringWithFormat:@"script.getElement(%d,%d);", (int)point.x, (int)point.y];
        NSString *result = [_webView stringByEvaluatingJavaScriptFromString:function];
        NSData *data = [result dataUsingEncoding:NSStringEncodingConversionAllowLossy|NSStringEncodingConversionExternalRepresentation];
        
        if (!data) {
            return;
        }
        
        NSMutableDictionary *content = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]];
        
        if (content.allValues.count > 0) {
            [content setObject:[NSValue valueWithCGPoint:point] forKey:@"location"];
            [self presentActivityControllerWithContent:content];
        }
    }
}

- (void)injectJavaScript
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"inpector-script" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [_webView stringByEvaluatingJavaScriptFromString:script];
}

- (void)handleInteractivePopGesture:(UIGestureRecognizer *)gesture
{
    NSLog(@"%s : %@",__FUNCTION__, gesture);
}

- (void)clearProgressViewAnimated:(BOOL)animated
{
    if (!_progressView) {
        return;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0
                     animations:^{
                         _progressView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_progressView removeFromSuperview];
                     }];
}

- (void)stopLoading
{
    [self.webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    if (request.URL && !_presentingActivities) {
        return YES;
    }
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // load balance is use to see if the load was completed end of the site
    _loadBalance++;
    
    if (_loadBalance == 1) {
        [self setActivityIndicatorsVisible:YES];
    }
    
    _backwardBarItem.enabled = [_webView canGoBack];
    _forwardBarItem.enabled = [_webView canGoForward];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_loadBalance >= 1) _loadBalance--;
    else if (_loadBalance < 0) _loadBalance = 0;

    if (_loadBalance == 0) {
        _didLoadContent = YES;
        [self setActivityIndicatorsVisible:NO];
    }
    
    _backwardBarItem.enabled = [_webView canGoBack];
    _forwardBarItem.enabled = [_webView canGoForward];
    
    [self setViewTitle:[self pageTitle]];
    
    if ([webView.request.URL isFileURL] && _loadingStyle == DZNWebViewControllerLoadingStyleProgressView) {
        [_progressView setProgress:1.0 animated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _loadBalance = 0;
    [self setLoadingError:error];
}


#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[DZNLongPressGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    Class class = [DZNLongPressGestureRecognizer class];
    if ([gestureRecognizer isKindOfClass:class] || [otherGestureRecognizer isKindOfClass:class]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - NJKWebViewProgressDelegate methods

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
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
    _actionBarItem = nil;
    _backwardBarItem = nil;
    _forwardBarItem = nil;
    _loadingBarItem = nil;

    _activityIndicatorView = nil;
    
    _webView = nil;
    _URL = nil;
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

@end
