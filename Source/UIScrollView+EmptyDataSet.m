//
//  UIScrollView+EmptyDataSet.m
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIScrollView+EmptyDataSet.h"
#import "DZNEmptyDataSetView.h"
#import <objc/runtime.h>

static char const * const kEmptyDataSetSource =     "emptyDataSetSource";
static char const * const kEmptyDataSetDelegate =   "emptyDataSetDelegate";
static char const * const kEmptyDataSetView =       "emptyDataSetView";
static char const * const kEmptyDataSetEnabled =    "emptyDataSetEnabled";
static NSString * const kContentSize =              @"contentSize";
static void *DZNContentSizeCtx =                    &DZNContentSizeCtx;

@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) DZNEmptyDataSetView *emptyDataSetView;
@property (nonatomic, getter = isEmptyDataSetEnabled) BOOL emptyDataSetEnabled;
@end

@implementation UIScrollView (DZNEmptyDataSet)

#pragma mark - Getter Methods

- (id<DZNEmptyDataSetSource>)emptyDataSetSource
{
    return objc_getAssociatedObject(self, kEmptyDataSetSource);
}

- (id<DZNEmptyDataSetDelegate>)emptyDataSetDelegate
{
    return objc_getAssociatedObject(self, kEmptyDataSetDelegate);
}

- (DZNEmptyDataSetView *)emptyDataSetView
{
    DZNEmptyDataSetView *view = objc_getAssociatedObject(self, kEmptyDataSetView);
    if (!view)
    {
        view = [[DZNEmptyDataSetView alloc] initWithCustomView:[self customView]];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = nil;
        view.hidden = YES;
        view.alpha = 0;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        gesture.delegate = self;
        [view addGestureRecognizer:gesture];
        
        [self addSubview:view];
        
        objc_setAssociatedObject(self, kEmptyDataSetView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}

- (BOOL)isEmptyDataSetVisible
{
    UIView *view = objc_getAssociatedObject(self, kEmptyDataSetView);
    return !view.hidden;
}

- (BOOL)isEmptyDataSetEnabled
{
    return [objc_getAssociatedObject(self, kEmptyDataSetEnabled) boolValue];
}

- (BOOL)isTouchAllowed
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAllowTouch:)]) {
        return [self.emptyDataSetDelegate emptyDataSetShouldAllowTouch:self];
    }
    return YES;
}

- (BOOL)isScrollAllowed
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAllowScroll:)]) {
        return [self.emptyDataSetDelegate emptyDataSetShouldAllowScroll:self];
    }
    return NO;
}

- (UIColor *)dataSetBackgroundColor
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(backgroundColorForEmptyDataSet:)]) {
        return [self.emptyDataSetSource backgroundColorForEmptyDataSet:self];
    }
    return [UIColor clearColor];
}

- (NSAttributedString *)titleLabelText
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(titleForEmptyDataSet:)]) {
        return [self.emptyDataSetSource titleForEmptyDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)detailLabelText
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(descriptionForEmptyDataSet:)]) {
        return [self.emptyDataSetSource descriptionForEmptyDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)buttonTitleForState:(UIControlState)state
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(buttonTitleForEmptyDataSet:forState:)]) {
        return [self.emptyDataSetSource buttonTitleForEmptyDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)buttonBackgroundImageForState:(UIControlState)state
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(buttonBackgroundImageForEmptyDataSet:forState:)]) {
        return [self.emptyDataSetSource buttonBackgroundImageForEmptyDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)image
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(imageForEmptyDataSet:)]) {
        return [self.emptyDataSetSource imageForEmptyDataSet:self];
    }
    return nil;
}

- (CGFloat)verticalSpace
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(spaceHeightForEmptyDataSet:)]) {
        return [self.emptyDataSetSource spaceHeightForEmptyDataSet:self];
    }
    return 0.0;
}

- (UIView *)customView
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(customViewForEmptyDataSet:)]) {
        return [self.emptyDataSetSource customViewForEmptyDataSet:self];
    }
    return nil;
}

- (BOOL)needsReloadSets
{
    if (![self.emptyDataSetView.titleLabel.attributedText.string isEqualToString:[self titleLabelText].string]) {
        return YES;
    }
    if (![self.emptyDataSetView.detailLabel.attributedText.string isEqualToString:[self detailLabelText].string]) {
        return YES;
    }
    if (![[self.emptyDataSetView.button attributedTitleForState:UIControlStateNormal].string isEqualToString:[self buttonTitleForState:UIControlStateNormal].string]) {
        return YES;
    }
    if (!([UIImagePNGRepresentation(self.emptyDataSetView.imageView.image) isEqualToData:UIImagePNGRepresentation([self image])])) {
        return YES;
    }
    
    return YES;
}

- (NSInteger)itemsCount
{
    NSInteger rows = 0;

    if (![self respondsToSelector:@selector(dataSource)]) {
        return rows;
    }
    
    if ([self isKindOfClass:[UITableView class]])
    {
        id <UITableViewDataSource> dataSource = [self performSelector:@selector(dataSource)];
        UITableView *tableView = (UITableView *)self;
        
        NSInteger sections = [dataSource numberOfSectionsInTableView:tableView];
        for (NSInteger i = 0; i < sections; i++) {
            rows += [dataSource tableView:tableView numberOfRowsInSection:i];
        }
    }
    else if ([self isKindOfClass:[UICollectionView class]])
    {
        id <UICollectionViewDataSource> dataSource = [self performSelector:@selector(dataSource)];
        UICollectionView *collectionView = (UICollectionView *)self;

        NSInteger sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        for (NSInteger i = 0; i < sections; i++) {
            rows += [dataSource collectionView:collectionView numberOfItemsInSection:i];
        }
    }
    
    return rows;
}


#pragma mark - Setter Methods

- (void)setEmptyDataSetSource:(id<DZNEmptyDataSetSource>)source
{
    self.emptyDataSetEnabled = source ? YES : NO;
    objc_setAssociatedObject(self, kEmptyDataSetSource, source, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setEmptyDataSetDelegate:(id<DZNEmptyDataSetDelegate>)delegate
{
    self.emptyDataSetEnabled = delegate ? YES : NO;
    objc_setAssociatedObject(self, kEmptyDataSetDelegate, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setEmptyDataSetEnabled:(BOOL)enabled
{
    if (self.isEmptyDataSetEnabled == enabled) {
        return;
    }
    
    [self enableObservers:enabled];
    
    objc_setAssociatedObject(self, kEmptyDataSetEnabled, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)enableObservers:(BOOL)enable
{
    if (self.isEmptyDataSetEnabled && !enable) {
        @try {
            [self removeObserver:self forKeyPath:kContentSize context:DZNContentSizeCtx];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kDZNEmptyDataSetDidTapButtonNotification object:nil];
            [self invalidateContent];
        }
        @catch(id anException) {
            // Do nothing. An exception might araise due to removing an none existent observer.
        }
    }
    else if (enable) {
        @try {
            [self addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:DZNContentSizeCtx];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapDataSetButton:) name:kDZNEmptyDataSetDidTapButtonNotification object:nil];
        }
        @catch(id anException) {
            // Do nothing. An exception might araise due to removing an none existent observer.
        }
    }
}


#pragma mark - UITableView+DataSet Methods

- (void)didTapContentView:(id)sender
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapView:)]) {
        [self.emptyDataSetDelegate emptyDataSetDidTapView:self];
    }
}

- (void)didTapDataSetButton:(id)sender
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapButton:)]) {
        [self.emptyDataSetDelegate emptyDataSetDidTapButton:self];
    }
}

- (void)didReloadData
{
    if (self.emptyDataSetSource) {
        [self reloadDataSet];
    }
}

- (void)reloadDataSet
{
    if ([self itemsCount] == 0)
    {
        DZNEmptyDataSetView *view = self.emptyDataSetView;
        
        [view updateConstraintsIfNeeded];
        
        if (!view.customView && [self needsReloadSets])
        {
            // Configure labels
            view.detailLabel.attributedText = [self detailLabelText];
            view.titleLabel.attributedText = [self titleLabelText];
            
            // Configure imageview
            view.imageView.image = [self image];
            
            // Configure button
            [view.button setAttributedTitle:[self buttonTitleForState:0] forState:0];
            [view.button setAttributedTitle:[self buttonTitleForState:1] forState:1];
            [view.button setBackgroundImage:[self buttonBackgroundImageForState:0] forState:0];
            [view.button setBackgroundImage:[self buttonBackgroundImageForState:1] forState:1];
            
            // Configure vertical spacing
            view.verticalSpace = [self verticalSpace];
        }
        
        // Configure scroll permission
        self.scrollEnabled = [self isScrollAllowed];
        
        // Configure background color
        view.backgroundColor = [self dataSetBackgroundColor];
        if (self.scrollEnabled && [self dataSetBackgroundColor]) self.backgroundColor = [self dataSetBackgroundColor];
        
        view.hidden = NO;
        
        [view updateConstraints];
        [view layoutIfNeeded];
        
        [UIView animateWithDuration:0.25
                         animations:^{view.alpha = 1.0;}
                         completion:NULL];
    }
    else if (self.isEmptyDataSetVisible) {
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
    [self.emptyDataSetView invalidateContent];
    [self.emptyDataSetView removeFromSuperview];
    
    objc_setAssociatedObject(self, kEmptyDataSetView, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
    if ([gestureRecognizer.view isEqual:self.emptyDataSetView]) {
        return [self isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
