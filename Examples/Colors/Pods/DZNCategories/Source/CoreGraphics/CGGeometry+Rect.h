//
//  CGGeometry+Rect.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <CoreGraphics/CoreGraphics.h>

/*
 Returns a rectangle with none null width and height based on the provided CGSize, and empty origin.
 */
CGRect CGRectWithSize(CGSize size);

/*
 Returns a rectangle with based on the provided CGPoint & CGSize.
 */
CGRect CGRectCreate(CGPoint point, CGSize size);

/*
 Returns a rectangle with none null width and height, and empty origin.
 */
CGRect CGRectSizeMake(CGFloat width, CGFloat height);

/*
 
 */
CGRect CGRectPointMake(CGFloat x, CGFloat y);

/*
 
 */
CGRect CGRectInvert(CGRect containingRect, CGRect rect);