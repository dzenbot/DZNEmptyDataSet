//
//  ViewController.m
//  WebBrowser
//
//  Created by Ignacio Romero Z. on 7/21/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Show WebBrowser" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showWebBrowser:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    [self.view addSubview:button];
    
    button.center = self.view.center;
}

- (IBAction)showWebBrowser:(id)sender
{
    WebViewController *webViewController = [[WebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www"]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
