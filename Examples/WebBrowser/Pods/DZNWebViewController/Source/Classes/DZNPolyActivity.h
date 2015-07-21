//
//  DZNPolyActivity.h
//  DZNWebViewController
//  https://github.com/dzenbot/DZNWebViewController
//
//  Created by Ignacio Romero Zurbuchen on 3/28/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

/**
 Types of activity kind, used for polymorphic creation.
 */
typedef NS_OPTIONS(NSUInteger, DZNPolyActivityType) {
    DZNPolyActivityTypeLink,
    DZNPolyActivityTypeSafari,
    DZNPolyActivityTypeChrome,
    DZNPolyActivityTypeOpera,
    DZNPolyActivityTypeDolphin
};

/**
 The DZNPolyActivity class is an abstract subclass of UIActivity allowing to easily create polymorphic instances by assigning different activity types. Each type will render a different icon and title, and will perform different actions too.
 */
@interface DZNPolyActivity : UIActivity

@property (nonatomic, readonly) DZNPolyActivityType type;
@property (nonatomic, readonly) NSURL *URL;

/**
 Initializes and returns a newly created activity with a specific type.
 
 @param type The type of the activity to be created.
 @returns The initialized activity.
 */
- (instancetype)initWithActivityType:(DZNPolyActivityType)type;

/**
 Allocates a new instance of the receiving class, sends it an init message, and returns the initialized object.
 This method implements the same logic than initWithActivityType: but is just shorter to call.
 
 @param type The type of the activity to be created.
 */
+ (instancetype)activityWithType:(DZNPolyActivityType)type;

@end
