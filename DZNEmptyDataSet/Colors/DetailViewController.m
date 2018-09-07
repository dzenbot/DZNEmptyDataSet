//
//  DetailViewController.m
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DetailViewController.h"
#import "Color.h"
#import "FirstContainerController.h"
#import "SecondContainerController.h"

#import <DZNEmptyDataSet/DZNEmptyDataSet.h>

@interface DetailViewController ()
@property (nonatomic,strong) NSArray* portraitConstraints;
@property (nonatomic,strong) NSArray* landscapeConstraints;
@end

@implementation DetailViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // As shown in *.storyboard, the DetailViewController's content comprises
    // two container views managed by a FirstContainerController and a
    // SecondContainerController .
    FirstContainerController* firstContainerController = NULL;
    SecondContainerController* secondContainerController = NULL;
    for (UIViewController* child in [self childViewControllers]) {
        if ([child isKindOfClass:[FirstContainerController class]]) {
            firstContainerController = (FirstContainerController*)child;
        } else if ([child isKindOfClass:[SecondContainerController class]]) {
            secondContainerController = (SecondContainerController*)child;
        }
    }
    // Populate content managed by firstContainerController .  (image)
    if (firstContainerController != NULL) {
        firstContainerController.colorView.image = [Color roundImageForSize:firstContainerController.colorView.frame.size withColor:self.selectedColor.color];
    }
    // Populate content managed by secondContainerController .  (labels)
    if (secondContainerController != NULL) {
        secondContainerController.nameLabel.text = self.selectedColor.name;
        secondContainerController.hexLabel.text = [NSString stringWithFormat:@"#%@", self.selectedColor.hex];
        secondContainerController.rgbLabel.text = self.selectedColor.rgb;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Constraints
    self.portraitConstraints=@[self.portrait1,self.portrait2,self.portrait3,self.portrait4];
    self.landscapeConstraints=@[self.landscape1,self.landscape2,self.landscape3,self.landscape4];
    [NSLayoutConstraint deactivateConstraints: self.portraitConstraints];
    [NSLayoutConstraint deactivateConstraints: self.landscapeConstraints];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Restrict app to presenting at most one DetailViewController at any time.
    // This prevents situation where Collection, Table, and Search are all
    // presenting their own different DetailViewController's with different
    // colors.  This behavior seems odd.  Our remedy here is to pop the
    // DetailViewController is user selects different item in the app's
    // tab controller.
    [super viewWillDisappear:animated];
    [self.navigationController popToRootViewControllerAnimated:animated];
}

#pragma mark - Adaptive User Interface

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    ////////////////////////////////////////////////////////////////
    // "UIKit calls this method before changing the size of a presented
    // view controller’s view. You can override this method in your own
    // objects and use it to perform additional tasks related to the
    // size change."
    // https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIContentContainer_Ref/index.html
    ////////////////////////////////////////////////////////////////
    [coordinator animateAlongsideTransition:^ (id <UIViewControllerTransitionCoordinatorContext> context) {
        if (size.width<size.height) {
            // Portrait Orientation
            [NSLayoutConstraint deactivateConstraints: self.landscapeConstraints];
            [NSLayoutConstraint activateConstraints: self.portraitConstraints];
        } else {
            // Landscape Orientation
            [NSLayoutConstraint deactivateConstraints: self.portraitConstraints];
            [NSLayoutConstraint activateConstraints: self.landscapeConstraints];
        }
    } completion:^ (id <UIViewControllerTransitionCoordinatorContext> context) {
        [self.view setNeedsLayout];
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
