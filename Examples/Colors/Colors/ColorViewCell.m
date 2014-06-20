//
//  ColorViewCell.m
//  Colors
//
//  Created by Ignacio Romero Z. on 6/19/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "ColorViewCell.h"

@implementation ColorViewCell
@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundView = [UIView new];
//        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        [self.contentView addSubview:self.textLabel];
        
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    }
    return _textLabel;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (!highlighted && self.textLabel.text) {
        self.textLabel.text = nil;
    }
}

@end
