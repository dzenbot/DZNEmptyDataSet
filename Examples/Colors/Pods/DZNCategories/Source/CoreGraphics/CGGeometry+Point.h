//
//  CGGeometry+Point.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <CoreGraphics/CoreGraphics.h>

/*
Returns a proportionnaly scaled point.
 */
CGPoint CGPointScale(CGPoint point, CGFloat scale);

/*
Returns the center point of the given rectangle.
 */
CGPoint CGRectCenterPoint(CGRect rect);

CGPoint CGPointAddY(CGPoint point, CGFloat y);

/*
 Returns true if `point' is empty (that is, if it has zero width and height).
 Returns false otherwise. A null point is defined to be empty.
 */
bool CGPointIsEmpty(CGPoint point);
