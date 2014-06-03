//
//  UITableView+DataSet.m
//  UITableView-DataSet
//  https://github.com/dzenbot/UITableView-DataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/1/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
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
        _dataSetView.backgroundColor = [UIColor clearColor];
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
        @try {
            [self removeObserver:self forKeyPath:kContentSize];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kDZNTableDataSetViewDidTapButtonNotification object:nil];
            [self invalidateContent];
        }
        @catch(id anException) {
            
        }
    }
    else if (enabled) {
        @try {
            [self addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:&observanceCtx];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapDataSetButton:) name:kDZNTableDataSetViewDidTapButtonNotification object:nil];
        }
        @catch(id anException) {
            
        }
    }
    
    _dataSetEnabled = enabled;
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
    if (![self.dataSetView.titleLabel.attributedText.string isEqualToString:[self titleLabelText].string]) {
        return YES;
    }
    if (![self.dataSetView.detailLabel.attributedText.string isEqualToString:[self detailLabelText].string]) {
        return YES;
    }
    if (![[self.dataSetView.button attributedTitleForState:UIControlStateNormal].string isEqualToString:[self buttonTitle].string]) {
        return YES;
    }
    if (!([UIImagePNGRepresentation(self.dataSetView.imageView.image) isEqualToData:UIImagePNGRepresentation([self image])])) {
        return YES;
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
    
    _totalNumberOfRows = [self totalNumberOfRows];
    
    if (_totalNumberOfRows == 0)
    {
        self.dataSetView.titleLabel.attributedText = [self titleLabelText];
        self.dataSetView.detailLabel.attributedText = [self detailLabelText];
        self.dataSetView.imageView.image = [self image];
        [self.dataSetView.button setAttributedTitle:[self buttonTitle] forState:UIControlStateNormal];

        [self.dataSetView updateConstraints];
        [self.dataSetView layoutIfNeeded];
        
        self.dataSetView.hidden = NO;
        self.scrollEnabled = NO;

        [UIView animateWithDuration:0.25
                         animations:^{
                             self.dataSetView.alpha = 1.0;
                         }
                         completion:NULL];
    }
    else if (isDataSetVisible) {
        [self invalidateContent];
    }
}

- (void)reloadDataSetIfNeeded
{
    if ([self needsReloadSets]) {
        [self reloadDataSet];
    }
}

- (void)invalidateContent
{
    _dataSetView.titleLabel.text = nil;
    _dataSetView.detailLabel.text = nil;
    _dataSetView.imageView.image = nil;
    
    _dataSetView = nil;
    _totalNumberOfRows = 0;
    
    observanceCtx = 0;
    
    self.scrollEnabled = YES;
}


#pragma mark - NSKeyValueObserving methods

// Based on Abdullah Umer's answer http://stackoverflow.com/a/14920005/590010
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &observanceCtx)
    {
        NSValue *new = [change objectForKey:@"new"];
        NSValue *old = [change objectForKey:@"old"];
        
        if (new && old && [new isEqualToValue:old]) {
            if ([keyPath isEqualToString:kContentSize]) {
                [self didReloadData];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
