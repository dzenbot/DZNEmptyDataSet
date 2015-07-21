//
//  DZNWebViewController.h
//  DZNWebViewController
//  https://github.com/dzenbot/DZNWebViewController
//
//  Created by Ignacio Romero Zurbuchen on 10/25/13.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

/**
 * Types of supported actions (i.e. Share & Copy link, Add to Reading List, Open in Safari/Chrome/Opera/Dolphin).
 */
typedef NS_OPTIONS(NSUInteger, DZNWebViewControllerActions) {
    DZNWebViewControllerActionAll = -1,
    DZNWebViewControllerActionNone = 0,
    DZNWebViewControllerActionShareLink = (1 << 0),
    DZNWebViewControllerActionCopyLink = (1 << 1),
    DZNWebViewControllerActionReadLater = (1 << 2),
    DZNWebViewControllerActionOpenSafari = (1 << 3),
    DZNWebViewControllerActionOpenChrome = (1 << 4),
    DZNWebViewControllerActionOpenOperaMini = (1 << 5),
    DZNWebViewControllerActionOpenDolphin = (1 << 6)
};

/**
 * Types of network loading style.
 */
typedef NS_OPTIONS(NSUInteger, DZNWebViewControllerLoadingStyle) {
    DZNWebViewControllerLoadingStyleNone,
    DZNWebViewControllerLoadingStyleProgressView,
    DZNWebViewControllerLoadingStyleActivityIndicator
};

/**
 * A very simple web browser with useful navigation and exportation tools.
 */
@interface DZNWebViewController : UIViewController

/** The web view that the controller manages. */
@property (nonatomic, strong) UIWebView *webView;
/** The URL identifying the location of the content to load. */
@property (nonatomic, readonly) NSURL *URL;
/** The loading visual style, using a progress bar or a network activity indicator. Default is DZNWebViewControllerLoadingStyleProgressView. */
@property (nonatomic) DZNWebViewControllerLoadingStyle loadingStyle;
/** The supported actions like sharing and copy link, add to reading list, open in Safari, etc. Default is DZNWebViewControllerActionAll. */
@property (nonatomic) DZNWebViewControllerActions supportedActions;
/** The toolbar background color. Default is black, translucent. */
@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
/** The toolbar item's tint color. Default is white. */
@property (nonatomic, strong) UIColor *toolbarTintColor;
/** The navigation bar's title font. Default uses UINavigation's appearance title text attributes with key NSFontAttributeName. */
@property (nonatomic, strong) UIFont *titleFont;
/** The navigation bar's title custom font. Default uses UINavigation's appearance title text attributes with key NSForegroundColorAttributeName. */
@property (nonatomic, strong) UIColor *titleColor;

/**
 * Initializes and returns a newly created webview controller with an initial HTTP URL to be requested as soon as the view appears.
 *
 * @param URL The HTTP URL to be requested.
 * @returns The initialized webview controller.
 */
- (id)initWithURL:(NSURL *)URL;

/**
 * Initializes and returns a newly created webview controller for local HTML navigation.
 *
 * @param URL The file URL of the main html.
 * @returns The initialized webview controller.
 */
- (id)initWithFileURL:(NSURL *)URL;

@end
