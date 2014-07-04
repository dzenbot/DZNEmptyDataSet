//
//  UITextField+Behaviour.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 11/28/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UITextField+Behaviour.h"

@implementation UITextField (Behaviour)

- (void)shouldCapitalizeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    UITextRange *textRange = [self textRangeFromPosition:start toPosition:end];

    [self replaceRange:textRange withText:[string uppercaseString]];
}

@end
