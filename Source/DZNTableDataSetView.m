//
//  DZNTableDataSetView.m
//  UITableView-DataSet
//
//  Created by Ignacio on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DZNTableDataSetView.h"

@interface DZNTableDataSetView ()
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) BOOL didConfigureConstraints;
@end

@implementation DZNTableDataSetView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}


#pragma mark - Getter Methods

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        
        [_contentView addSubview:self.imageView];
        [_contentView addSubview:self.titleLabel];
        [_contentView addSubview:self.detailLabel];
        [_contentView addSubview:self.button];
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:24.0];
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
        
        _detailLabel.font = [UIFont systemFontOfSize:16.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.userInteractionEnabled = YES;
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDZNTableDataSetViewDidTapButtonNotification object:nil];
}


#pragma mark - UIView Constraints & Layout Methods

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [_contentView removeConstraints:_contentView.constraints];
    
    NSInteger multiplier = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 12 : 4;
    NSNumber *padding = @(roundf(self.frame.size.width/multiplier));
    NSNumber *imgWidth = @(roundf(_imageView.image.size.width));
    NSNumber *imgHeight = @(roundf(_imageView.image.size.height));
    NSNumber *trailing = @(roundf((self.frame.size.width-[imgWidth floatValue])/2.0));
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self,_contentView,_titleLabel,_detailLabel,_imageView,_button);
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding,trailing,imgWidth,imgHeight);
    
    if (!self.didConfigureConstraints) {
        self.didConfigureConstraints = YES;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-(<=1)-[_contentView]"
                                                                     options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-(<=0)-[_contentView]"
                                                                     options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
    }

    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_titleLabel]-padding-|"
                                                                         options:0 metrics:metrics views:views]];

    
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_detailLabel]-padding-|"
                                                                         options:0 metrics:metrics views:views]];

    
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_button]-padding-|"
                                                                         options:0 metrics:metrics views:views]];
    
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-trailing-[_imageView(imgWidth)]-trailing-|"
                                                                         options:0 metrics:metrics views:views]];
    
    NSMutableString *format = [NSMutableString new];
    NSMutableArray *subviews = [NSMutableArray new];
    
    if (_imageView.image) [subviews addObject:@"[_imageView(imgHeight)]"];
    if (_titleLabel.attributedText.string.length > 0) [subviews addObject:@"[_titleLabel]"];
    if (_detailLabel.attributedText.string.length > 0) [subviews addObject:@"[_detailLabel]"];
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0) [subviews addObject:@"[_button]"];

    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [format appendString:obj];
        if (idx < subviews.count-1) {
            [format appendString:@"-"];
        }
    }];
    
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", format]
                                                                         options:0 metrics:metrics views:views]];
}

@end
