//
//  UIImage+Frame.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
 * Easier way to retrieve your app's screenshot based the device type & orientation.
 */
@interface UIImage (Splash)

/*
 * Returns the appropriate splash image based on the device type
 *
 * @returns A the original splash screen image.
 */
+ (UIImage *)splashImage;

/*
 * Returns the appropriate splash image based on the device type and orientation.
 *
 * @param orientation The orientation of the device.
 * @returns A the original splash screen image.
 */
+ (UIImage *)splashImageForInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
