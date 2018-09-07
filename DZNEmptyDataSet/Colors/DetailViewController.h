//
//  DetailViewController.h
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Color;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Color *selectedColor;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portrait1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portrait2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portrait3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portrait4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscape1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscape2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscape3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscape4;

@property (weak, nonatomic) IBOutlet UIView *firstContainerView;
@property (weak, nonatomic) IBOutlet UIView *secondContainerView;

@end
