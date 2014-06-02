//
//  DZNDataSetContentView.m
//  UITableView-DataSet
//
//  Created by Ignacio on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DZNDataSetContentView.h"

@implementation DZNDataSetContentView
@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
//        [self addSubview:self.detailLabel];
//        [self addSubview:self.imageView];
    }
    return self;
}


#pragma mark - Getter Methods

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        
        _detailLabel.font = [UIFont systemFontOfSize:17.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 3;
    }
    return _detailLabel;
}


#pragma mark - UIView Constraints & Layout Methods

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self removeConstraints:self.constraints];
    
    NSDictionary *views = @{@"superview": self, @"title": self.titleLabel, @"detail": self.detailLabel};
    NSDictionary *metrics = @{@"padding": @(15)};
    
//    [self.titleLabel sizeToFit];
//    [self.detailLabel sizeToFit];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[title]"
                                                                 options:NSLayoutFormatAlignAllCenterY|NSLayoutFormatDirectionLeftToRight
                                                                 metrics:metrics
                                                                   views:views]];
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[detail]"
//                                                                 options:NSLayoutFormatAlignAllCenterY|NSLayoutFormatDirectionLeftToRight
//                                                                 metrics:metrics
//                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[title]"
                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                 metrics:metrics
                                                                   views:views]];
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[detail]"
//                                                                 options:NSLayoutFormatAlignAllCenterX
//                                                                 metrics:metrics
//                                                                   views:views]];
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
//                                                     attribute:NSLayoutAttributeCenterX
//                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeCenterX
//                                                    multiplier:1
//                                                      constant:0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
//                                                     attribute:NSLayoutAttributeCenterY
//                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeCenterY
//                                                    multiplier:1
//                                                      constant:0]];
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        NSLog(@"constraint : %@", constraint);
    }
    
    NSLog(@"self : %@", self);
    
//
//    [self.titleLabel sizeToFit];
//    [self.detailLabel sizeToFit];
//    
//    CGFloat titleHeight = self.titleLabel.frame.size.height;
//    CGFloat detailHeight = self.detailLabel.frame.size.height;
//    CGFloat leading = roundf((self.frame.size.height-(titleHeight+detailHeight))/2.0); //Top space
//    CGFloat trailing = leading; //Bottom space
//    CGFloat left = 15;
//    CGFloat right = left;
//    NSDictionary *metrics = @{@"titleHeight": @(titleHeight), @"detailHeight": @(detailHeight), @"leading": @(leading), @"trailing": @(trailing), @"left": @(left),  @"right": @(right)};
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[title]-right-|" options:0 metrics:metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[detail]-right-|" options:0 metrics:metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-leading-[title]-0-[detail]-trailing-|" options:0 metrics:metrics views:views]];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
