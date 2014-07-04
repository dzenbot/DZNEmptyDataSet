//
//  CGGeometry+UIEdgeInsets.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 3/25/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

/*
 Returns true if `edge' is empty (that is, if it has zero top, right, bottom and left),
 Returns false otherwise. A null edgeInsets is defined to be empty.
 */
bool UIEdgeInsetsIsEmpty(UIEdgeInsets edgeInsets);

/*
 Returns a squared inset distances (that means that every edge distance are equal).
 */
UIEdgeInsets UIEdgeInsetsSquare(CGFloat inset);