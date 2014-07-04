//
//  CGGeometry+UIEdgeInsets.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "CGGeometry+UIEdgeInsets.h"

bool UIEdgeInsetsIsEmpty(UIEdgeInsets edgeInsets)
{
    return (edgeInsets.top == 0 && edgeInsets.bottom == 0 &&
            edgeInsets.right == 0 && edgeInsets.left == 0) ? true : false;
}

UIEdgeInsets UIEdgeInsetsSquare(CGFloat inset) {
    return UIEdgeInsetsMake(inset, inset, inset, inset);
}