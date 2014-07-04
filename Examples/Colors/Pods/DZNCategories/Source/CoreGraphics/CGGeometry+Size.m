//
//  CGGeometry+Size.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "CGGeometry+Size.h"

CGSize CGSizeScale(CGSize size, CGFloat scale)
{
	return CGSizeMake(size.width * scale, size.height * scale);
}

CGSize CGSizeSquare(CGFloat square)
{
	return CGSizeMake(square, square);
}

CGSize CGSizeFromTwoPoints(CGPoint point1, CGPoint point2)
{
    CGFloat width = abs(roundf(point1.x)-roundf(point2.x));
    CGFloat height = abs(roundf(point1.y)-roundf(point2.y));
    return CGSizeMake(width, height);
}

bool CGSizeIsEmpty(CGSize size)
{
    return (size.width == 0 && size.height == 0) ? true : false;
}