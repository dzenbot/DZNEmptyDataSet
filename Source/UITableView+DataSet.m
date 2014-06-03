//
//  UITableView+DataSet.m
//  UITableView-DataSet
//
//  Created by Ignacio on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "UITableView+DataSet.h"
#import "DZNTableDataSetView.h"

static id<DZNTableViewDataSetSource> _dataSetSource = nil;
static id<DZNTableViewDataSetDelegate> _dataSetDelegate = nil;
static DZNTableDataSetView *_dataSetView;
static NSInteger _totalNumberOfRows;
static BOOL _dataSetEnabled;

static NSInteger observanceCtx = 0;
static NSString *kContentSize = @"contentSize";

@interface UITableView ()
@property (nonatomic, readonly) DZNTableDataSetView *dataSetView;
@property (nonatomic) BOOL dataSetEnabled;
@end

@implementation UITableView (DataSet)

#pragma mark - Getter Methods

- (id<DZNTableViewDataSetSource>)dataSetSource
{
    return _dataSetSource;
}

- (id<DZNTableViewDataSetDelegate>)dataSetDelegate
{
    return _dataSetDelegate;
}

- (DZNTableDataSetView *)dataSetView
{
    if (!_dataSetView)
    {
        _dataSetView = [[DZNTableDataSetView alloc] initWithFrame:self.bounds];
        _dataSetView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _dataSetView.backgroundColor = [UIColor greenColor];
        _dataSetView.hidden = YES;
        _dataSetView.alpha = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        [_dataSetView addGestureRecognizer:tapGesture];

        [self addSubview:_dataSetView];
    }
    return _dataSetView;
}

- (BOOL)dataSetEnabled
{
    return _dataSetEnabled;
}


#pragma mark - Setter Methods

- (void)setDataSetSource:(id<DZNTableViewDataSetSource>)source
{
    self.dataSetEnabled = source ? YES : NO;
    _dataSetSource = source;
}

- (void)setDataSetDelegate:(id<DZNTableViewDataSetDelegate>)delegate
{
    self.dataSetEnabled = delegate ? YES : NO;
    _dataSetDelegate = delegate;
}

- (void)setDataSetEnabled:(BOOL)enabled
{
    if (self.dataSetEnabled == enabled) {
        return;
    }
    
    if (self.dataSetEnabled && !enabled) {
        [self removeObserver:self forKeyPath:kContentSize];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kDZNTableDataSetViewDidTapButtonNotification object:nil];
    }
    else {
        [self addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:&observanceCtx];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapDataSetButton:) name:kDZNTableDataSetViewDidTapButtonNotification object:nil];

        _dataSetEnabled = enabled;
    }
}


#pragma mark - Data Source Methods

- (NSAttributedString *)titleLabelText
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(titleForDataSetInTableView:)]) {
        return [self.dataSetSource titleForDataSetInTableView:self];
    }
    return nil;
}

- (NSAttributedString *)detailLabelText
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(descriptionForDataSetInTableView:)]) {
        return [self.dataSetSource descriptionForDataSetInTableView:self];
    }
    return nil;
}

- (NSAttributedString *)buttonTitle
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(buttonTitleForDataSetInTableView:)]) {
        return [self.dataSetSource buttonTitleForDataSetInTableView:self];
    }
    return nil;
}

- (UIImage *)image
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(imageForDataSetInTableView:)]) {
        return [self.dataSetSource imageForDataSetInTableView:self];
    }
    return nil;
}

- (BOOL)needsReloadSets
{
    DZNTableDataSetView *contentView = self.dataSetView;

    if ([contentView.titleLabel.attributedText.string isEqualToString:[self titleLabelText].string]) {
        return NO;
    }
    if ([contentView.detailLabel.attributedText.string isEqualToString:[self detailLabelText].string]) {
        return NO;
    }
    if ([[contentView.button attributedTitleForState:UIControlStateNormal].string isEqualToString:[self buttonTitle].string]) {
        return NO;
    }
    if (([UIImagePNGRepresentation(contentView.imageView.image) isEqualToData:UIImagePNGRepresentation([self image])])) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isDataSetVisible
{
    return !self.dataSetView.hidden;
}

- (NSInteger)totalNumberOfRows
{
    NSInteger sections = [self.dataSource numberOfSectionsInTableView:self];
    NSInteger rows = 0;
    
    for (NSInteger i = 0; i < sections; i++) {
        rows += [self.dataSource tableView:self numberOfRowsInSection:i];
    }
    
    return rows;
}


#pragma mark - UITableView+DataSet Methods

- (void)didTapContentView:(id)sender
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(tableViewDataSetDidTapView:)]) {
        [self.dataSetDelegate tableViewDataSetDidTapView:self];
    }
}

- (void)didTapDataSetButton:(id)sender
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(tableViewDataSetDidTapButton:)]) {
        [self.dataSetDelegate tableViewDataSetDidTapButton:self];
    }
}

- (void)didReloadData
{
    if (self.dataSetSource) {
        [self reloadDataSet];
    }
}

- (void)reloadDataSet
{
    BOOL isDataSetVisible = [self isDataSetVisible];
    DZNTableDataSetView *contentView = self.dataSetView;
    
    _totalNumberOfRows = [self totalNumberOfRows];
    
    if (_totalNumberOfRows == 0)
    {
        contentView.titleLabel.attributedText = [self titleLabelText];
        contentView.detailLabel.attributedText = [self detailLabelText];
        contentView.imageView.image = [self image];
        [contentView.button setAttributedTitle:[self buttonTitle] forState:UIControlStateNormal];
        [contentView.button sizeToFit];
        
        [contentView updateConstraints];
        [contentView layoutIfNeeded];
        
        contentView.hidden = NO;
//        self.scrollEnabled = NO;

        [UIView animateWithDuration:0.25
                         animations:^{
                             contentView.alpha = 1.0;
                         }
                         completion:NULL];
    }
    else if (isDataSetVisible)
    {
        contentView.hidden = YES;
        contentView.alpha = 0.0;
        
        contentView.hidden = NO;
        contentView.titleLabel.text = nil;
        contentView.detailLabel.text = nil;
        contentView.imageView.image = nil;
        
        self.scrollEnabled = YES;
    }
}

- (void)reloadDataSetIfNeeded
{
    if ([self needsReloadSets]) {
        [self reloadDataSet];
    }
}


#pragma mark - NSKeyValueObserving methods

// Based on Abdullah Umer's answer http://stackoverflow.com/a/14920005/590010
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &observanceCtx)
    {
        NSValue *new = [change valueForKey:@"new"];
        NSValue *old = [change valueForKey:@"old"];
        
        if ([keyPath isEqualToString:kContentSize]) {
            if (new && old && ![old isEqualToValue:new]) {
                [self didReloadData];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
