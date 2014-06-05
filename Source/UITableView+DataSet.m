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
#import <objc/runtime.h>

static char const * const kDataSetSource =      "dataSetSource";
static char const * const kDataSetDelegate =    "dataSetDelegate";
static char const * const kDataSetView =        "dataSetView";
static char const * const kDataSetEnabled =     "dataSetEnabled";
static NSString * const kContentSize =          @"contentSize";
static void *DZNContentSizeCtx =                &DZNContentSizeCtx;

@interface UITableView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) DZNTableDataSetView *dataSetView;
@property (nonatomic, getter = isDataSetEnabled) BOOL dataSetEnabled;
@end

@implementation UITableView (DataSet)
@dynamic dataSetDelegate, dataSetSource;


#pragma mark - Getter Methods

- (id<DZNTableViewDataSetSource>)dataSetSource
{
    return objc_getAssociatedObject(self, kDataSetSource);
}

- (id<DZNTableViewDataSetDelegate>)dataSetDelegate
{
    return objc_getAssociatedObject(self, kDataSetDelegate);
}

- (DZNTableDataSetView *)dataSetView
{
    id view = objc_getAssociatedObject(self, kDataSetView);
    if (!view)
    {
        DZNTableDataSetView *view = [[DZNTableDataSetView alloc] initWithFrame:self.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        view.alpha = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        tapGesture.delegate = self;
        [view addGestureRecognizer:tapGesture];
        
        [self addSubview:view];
        
        objc_setAssociatedObject(self, kDataSetView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}

- (BOOL)isDataSetEnabled
{
    return [objc_getAssociatedObject(self, kDataSetEnabled) boolValue];
}

- (BOOL)isTouchAllowed
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(tableViewDataSetShouldAllowTouch:)]) {
        return [self.dataSetDelegate tableViewDataSetShouldAllowTouch:self];
    }
    return YES;
}

- (BOOL)isScrollAllowed
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(tableViewDataSetShouldAllowScroll:)]) {
        return [self.dataSetDelegate tableViewDataSetShouldAllowScroll:self];
    }
    return NO;
}

- (UIColor *)dataSetBackgroundColor
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(backgroundColorForDataSetInTableView:)]) {
        return [self.dataSetSource backgroundColorForDataSetInTableView:self];
    }
    return [UIColor clearColor];
}

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

- (NSInteger)totalNumberOfRows
{
    NSInteger sections = [self.dataSource numberOfSectionsInTableView:self];
    NSInteger rows = 0;
    
    for (NSInteger i = 0; i < sections; i++) {
        rows += [self.dataSource tableView:self numberOfRowsInSection:i];
    }
    
    return rows;
}

- (BOOL)isDataSetVisible
{
    return !self.dataSetView.hidden;
}


#pragma mark - Setter Methods

- (void)setDataSetSource:(id<DZNTableViewDataSetSource>)source
{
    self.dataSetEnabled = source ? YES : NO;
    objc_setAssociatedObject(self, kDataSetSource, source, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setDataSetDelegate:(id<DZNTableViewDataSetDelegate>)delegate
{
    self.dataSetEnabled = delegate ? YES : NO;
    objc_setAssociatedObject(self, kDataSetDelegate, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setDataSetEnabled:(BOOL)enabled
{
    if (self.isDataSetEnabled == enabled) {
        return;
    }
    
    [self enableObservers:enabled];
    
    objc_setAssociatedObject(self, kDataSetEnabled, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)enableObservers:(BOOL)enable
{
    if (self.isDataSetEnabled && !enable) {
        @try {
            [self removeObserver:self forKeyPath:kContentSize context:DZNContentSizeCtx];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kDZNTableDataSetViewDidTapButtonNotification object:nil];
            [self invalidateContent];
        }
        @catch(id anException) {
            
        }
    }
    else if (enable) {
        @try {
            [self addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:DZNContentSizeCtx];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapDataSetButton:) name:kDZNTableDataSetViewDidTapButtonNotification object:nil];
        }
        @catch(id anException) {
            
        }
    }
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
    if ([self totalNumberOfRows] == 0)
    {
        self.dataSetView.titleLabel.attributedText = [self titleLabelText];
        self.dataSetView.detailLabel.attributedText = [self detailLabelText];
        self.dataSetView.imageView.image = [self image];
        [self.dataSetView.button setAttributedTitle:[self buttonTitle] forState:UIControlStateNormal];
        
        [self.dataSetView updateConstraints];
        [self.dataSetView layoutIfNeeded];
        
        self.dataSetView.hidden = NO;
        self.dataSetView.backgroundColor = [self dataSetBackgroundColor];
        
        self.scrollEnabled = [self isScrollAllowed];

        [UIView animateWithDuration:0.25
                         animations:^{
                             self.dataSetView.alpha = 1.0;
                         }
                         completion:NULL];
    }
    else if ([self isDataSetVisible] && [self needsReloadSets]) {
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
    if (self.dataSetView) {
        [self.dataSetView invalidateContent];
        [self.dataSetView removeFromSuperview];
        
        objc_setAssociatedObject(self, kDataSetView, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    self.scrollEnabled = YES;
}


#pragma mark - NSKeyValueObserving methods

// Based on Abdullah Umer's answer http://stackoverflow.com/a/14920005/590010
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == DZNContentSizeCtx)
    {
        NSValue *new = [change objectForKey:@"new"];
        NSValue *old = [change objectForKey:@"old"];
        
        if (new && old && ![new isEqualToValue:old]) {
            if ([keyPath isEqualToString:kContentSize]) {
                [self didReloadData];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)willChangeValueForKey:(NSString *)key
{
    [super willChangeValueForKey:key];
}

- (void)didChangeValueForKey:(NSString *)key
{
    [super didChangeValueForKey:key];
}


#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self.dataSetView]) {
        return [self isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
