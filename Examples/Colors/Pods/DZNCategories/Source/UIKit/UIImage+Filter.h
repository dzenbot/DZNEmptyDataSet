//
//  UIImage+Filter.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 9/27/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@interface UIImage (Filter)

- (UIImage *)filterGlaussianBlurWithRadius:(CGFloat)radius;

@end
