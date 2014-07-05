//
//  SearchViewController.h
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Color.h"

@interface SearchViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) Color *selectedColor;

@property (nonatomic, weak) IBOutlet UIImageView *colorView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *hexLabel;
@property (nonatomic, weak) IBOutlet UILabel *rgbLabel;
@property (nonatomic, weak) IBOutlet UILabel *hexLegend;
@property (nonatomic, weak) IBOutlet UILabel *rgbLegend;

@end
