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
        view.backgroundColor = nil;
        view.hidden = YES;
        view.alpha = 0;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        gesture.delegate = self;
        [view addGestureRecognizer:gesture];
        
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
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(backgroundColorForTableViewDataSet:)]) {
        return [self.dataSetSource backgroundColorForTableViewDataSet:self];
    }
    return [UIColor clearColor];
}

- (NSAttributedString *)titleLabelText
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(titleForTableViewDataSet:)]) {
        return [self.dataSetSource titleForTableViewDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)detailLabelText
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(descriptionForTableViewDataSet:)]) {
        return [self.dataSetSource descriptionForTableViewDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)buttonTitleForState:(UIControlState)state
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(buttonTitleForTableViewDataSet:forState:)]) {
        return [self.dataSetSource buttonTitleForTableViewDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)buttonBackgroundImageForState:(UIControlState)state
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(buttonBackgroundImageForTableViewDataSet:forState:)]) {
        return [self.dataSetSource buttonBackgroundImageForTableViewDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)image
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(imageForTableViewDataSet:)]) {
        return [self.dataSetSource imageForTableViewDataSet:self];
    }
    return nil;
}

- (CGFloat)verticalSpace
{
    if (self.dataSetDelegate && [self.dataSetSource respondsToSelector:@selector(spaceHeightForTableViewDataSet:)]) {
        return [self.dataSetSource spaceHeightForTableViewDataSet:self];
    }
    return 0.0;
}

- (BOOL)needsReloadSets
{
    if (![self.dataSetView.titleLabel.attributedText.string isEqualToString:[self titleLabelText].string]) {
        return YES;
    }
    if (![self.dataSetView.detailLabel.attributedText.string isEqualToString:[self detailLabelText].string]) {
        return YES;
    }
    if (![[self.dataSetView.button attributedTitleForState:UIControlStateNormal].string isEqualToString:[self buttonTitleForState:UIControlStateNormal].string]) {
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
        [self.dataSetView updateConstraintsIfNeeded];
        
        // Configure labels
        self.dataSetView.detailLabel.attributedText = [self detailLabelText];
        self.dataSetView.titleLabel.attributedText = [self titleLabelText];
        
        // Configure imageview
        self.dataSetView.imageView.image = [self image];
        
        // Configure button
        [self.dataSetView.button setAttributedTitle:[self buttonTitleForState:0] forState:0];
        [self.dataSetView.button setAttributedTitle:[self buttonTitleForState:1] forState:1];
        [self.dataSetView.button setBackgroundImage:[self buttonBackgroundImageForState:0] forState:0];
        [self.dataSetView.button setBackgroundImage:[self buttonBackgroundImageForState:1] forState:1];
        
        // Configure vertical spacing
        self.dataSetView.verticalSpace = [self verticalSpace];
        
        // Configure scroll permission
        self.scrollEnabled = [self isScrollAllowed];
        
        // Configure background color
        self.dataSetView.backgroundColor = [self dataSetBackgroundColor];
        if (self.scrollEnabled && [self dataSetBackgroundColor]) self.backgroundColor = [self dataSetBackgroundColor];
        
        self.dataSetView.hidden = NO;
        
        [self.dataSetView updateConstraints];
        [self.dataSetView layoutIfNeeded];

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
