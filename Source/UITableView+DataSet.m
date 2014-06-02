//
//  UITableView+DataSet.m
//  UITableView-DataSet
//
//  Created by Ignacio on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "UITableView+DataSet.h"
#import "DZNDataSetContentView.h"

static id<DZNTableViewDataSetSource> _dataSetSource = nil;
static DZNDataSetContentView *_dataSetContentView;
static NSInteger _totalNumberOfRows;
static BOOL _dataSetEnabled;

static NSInteger observanceCtx = 0;
static NSString *kContentSize = @"contentSize";

@interface UITableView ()
@property (nonatomic, readonly) DZNDataSetContentView *dataSetContentView;
@property (nonatomic) BOOL dataSetEnabled;
@end

@implementation UITableView (DataSet)

#pragma mark - Getter Methods

- (id<DZNTableViewDataSetSource>)dataSetSource
{
    return _dataSetSource;
}

- (DZNDataSetContentView *)dataSetContentView
{
    if (!_dataSetContentView)
    {
        _dataSetContentView = [[DZNDataSetContentView alloc] initWithFrame:self.bounds];
        _dataSetContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _dataSetContentView.backgroundColor = [UIColor clearColor];
        _dataSetContentView.hidden = YES;
        _dataSetContentView.alpha = 0;

        [self addSubview:_dataSetContentView];
    }
    return _dataSetContentView;
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

- (void)setDataSetEnabled:(BOOL)enabled
{
    if (self.dataSetEnabled == enabled) {
        return;
    }
    
    if (self.dataSetEnabled && !enabled) {
        [self removeObserver:self forKeyPath:kContentSize];
    }
    else {
        [self addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:&observanceCtx];
        
        _dataSetEnabled = enabled;
    }
}


#pragma mark - Data Source Methods

- (NSString *)dataSetTitle
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(titleForDataSetInTableView:)]) {
        return [self.dataSetSource titleForDataSetInTableView:self];
    }
    return nil;
}

- (NSString *)dataSetDescription
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(descriptionForDataSetInTableView:)]) {
        return [self.dataSetSource descriptionForDataSetInTableView:self];
    }
    return nil;
}

- (UIImage *)dataSetImage
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(imageForDataSetInTableView:)]) {
        return [self.dataSetSource imageForDataSetInTableView:self];
    }
    return nil;
}

- (BOOL)isDataSetVisible
{
    return !self.dataSetContentView.hidden;
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

- (void)didReloadData
{
    if (self.dataSetSource) {
        [self reloadDataSet];
    }
}

- (void)reloadDataSet
{
    BOOL isDataSetVisible = [self isDataSetVisible];
    DZNDataSetContentView *contentView = self.dataSetContentView;
    
    _totalNumberOfRows = [self totalNumberOfRows];
    
    if (_totalNumberOfRows == 0)
    {
        contentView.titleLabel.text = [self dataSetTitle];
        contentView.detailLabel.text = [self dataSetDescription];
                
        [contentView updateConstraints];
        
        contentView.hidden = NO;
        self.scrollEnabled = NO;

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
    if (_totalNumberOfRows != [self totalNumberOfRows]) {
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
        
        if (new && old) {
            if (![old isEqualToValue:new]) {
                [self didReloadData];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
