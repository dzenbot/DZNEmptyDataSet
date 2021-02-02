//
//  DetailViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DetailViewController.h"
#import "Palette.h"
#import "Color.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadView
{
    [super loadView];

    self.title = @"Detail";
    
    for (UIView *subview in self.view.subviews) {
        subview.autoresizingMask = UIViewAutoresizingNone;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateLayoutAnimatedWithDuration:0.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateContent];
}


#pragma mark - Actions

- (void)updateLayoutAnimatedWithDuration:(NSTimeInterval)duration
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.colorView.frame = CGRectMake(60.0, 130.0, 200.0, 200.0);
    self.nameLabel.frame = CGRectMake(20.0, 350.0, 280.0, 35.0);
    self.hexLabel.frame = CGRectMake(120.0, 420.0, 140.0, 20.0);
    self.rgbLabel.frame = CGRectMake(120.0, 450.0, 140.0, 20.0);
    self.hexLegend.frame = CGRectMake(60.0, 420.0, 60.0, 20.0);
    self.rgbLegend.frame = CGRectMake(60.0, 450.0, 60.0, 20.0);

    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [UIView commitAnimations];
}

- (void)updateContent
{
    BOOL hide = self.selectedColor ? NO : YES;
    
    self.colorView.hidden = hide;
    self.nameLabel.hidden = hide;
    self.hexLabel.hidden = hide;
    self.rgbLabel.hidden = hide;
    self.hexLegend.hidden = hide;
    self.rgbLegend.hidden = hide;
    
    self.colorView.image = [Color roundImageForSize:self.colorView.frame.size withColor:self.selectedColor.color];
    
    self.nameLabel.text = self.selectedColor.name;
    self.hexLabel.text = [NSString stringWithFormat:@"#%@", self.selectedColor.hex];
    self.rgbLabel.text = self.selectedColor.rgb;
}

@end
