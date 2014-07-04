//
//  UIImage+Cache.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 5/28/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/*
 * A drop-in API for replacing +imageNamed: for flat images to be colored on runtime, with cache support.
 */
@interface UIImage (Cache)

/*
 * Renders an image by relacing it's color channel with a custom color, caching the result for reusing later.
 *
 * @param name The name of the file. If this is the first time the image is being loaded, the method renders a new image and saves it in the system cache folder for reusing later. The image source should have 1 single color, with translucent background for desired alpha.
 * @param color The color to be used to render the image.
 */
+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;

/*
 * Removes all cached images that have been generated with the [+imageNamed:withColor:] method.
 * It will wipe all created images located in com.dzn.UIImageCache.default cache folder.
 */
+ (void)clearCachedImages;

@end
