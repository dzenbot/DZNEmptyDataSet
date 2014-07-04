//
//  CGGeometry+Point.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "CGGeometry+Point.h"

CGPoint CGPointScale(CGPoint point, CGFloat scale)
{
	return CGPointMake(point.x * scale, point.y * scale);
}

CGPoint CGRectCenterPoint(CGRect rect)
{
    return CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect)/2,
                       CGRectGetMinY(rect) + CGRectGetHeight(rect)/2);
}

CGPoint CGPointAddY(CGPoint point, CGFloat y)
{
    return CGPointMake(point.x, point.y + y);
}

bool CGPointIsEmpty(CGPoint point)
{
    return (point.x == 0 && point.y == 0) ? true : false;
}