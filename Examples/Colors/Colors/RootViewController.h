//
//  RootViewController.h
//  Colors
//
//  Created by Ignacio Romero Z. on 6/29/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)reloadColors:(id)sender;
- (IBAction)removeColors:(id)sender;
- (IBAction)changeSegment:(id)sender;

@end
