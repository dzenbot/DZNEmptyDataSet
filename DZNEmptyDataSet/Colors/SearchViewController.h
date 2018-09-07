//
//  SearchViewController.h
//  Colors
//
//  Created by Ignacio Romero Z. on 7/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Color;

@interface SearchViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate>
@property (nonatomic, strong) Color *selectedColor;

@end
