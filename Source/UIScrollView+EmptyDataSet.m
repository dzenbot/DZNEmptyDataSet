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
#import "DZNScrollViewDataSetSource.h"
#import "DZNScrollViewDataSetDelegate.h"
#import "DZNDataSetView.h"
#import <objc/runtime.h>

static char const * const kDataSetSource =      "dataSetSource";
static char const * const kDataSetDelegate =    "dataSetDelegate";
static char const * const kDataSetView =        "dataSetView";
static char const * const kDataSetEnabled =     "dataSetEnabled";
static NSString * const kContentSize =          @"contentSize";
static void *DZNContentSizeCtx =                &DZNContentSizeCtx;

@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) DZNDataSetView *dataSetView;
@property (nonatomic, getter = isDataSetEnabled) BOOL dataSetEnabled;
@end

@implementation UIScrollView (DZNEmptyDataSet)
//@dynamic dataSetDelegate, dataSetSource;

#pragma mark - Getter Methods

- (id<DZNScrollViewDataSetSource>)dataSetSource
{
    return objc_getAssociatedObject(self, kDataSetSource);
}

- (id<DZNScrollViewDataSetDelegate>)dataSetDelegate
{
    return objc_getAssociatedObject(self, kDataSetDelegate);
}

- (DZNDataSetView *)dataSetView
{
    id view = objc_getAssociatedObject(self, kDataSetView);
    if (!view)
    {
        DZNDataSetView *view = [[DZNDataSetView alloc] initWithFrame:self.bounds customView:[self customView]];
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

- (BOOL)isDataSetVisible
{
    UIView *view = objc_getAssociatedObject(self, kDataSetView);
    return !view.hidden;
}

- (BOOL)isDataSetEnabled
{
    return [objc_getAssociatedObject(self, kDataSetEnabled) boolValue];
}

- (BOOL)isTouchAllowed
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(scrollViewDataSetShouldAllowTouch:)]) {
        return [self.dataSetDelegate scrollViewDataSetShouldAllowTouch:self];
    }
    return YES;
}

- (BOOL)isScrollAllowed
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(scrollViewDataSetShouldAllowScroll:)]) {
        return [self.dataSetDelegate scrollViewDataSetShouldAllowScroll:self];
    }
    return NO;
}

- (UIColor *)dataSetBackgroundColor
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(backgroundColorForScrollViewDataSet:)]) {
        return [self.dataSetSource backgroundColorForScrollViewDataSet:self];
    }
    return [UIColor clearColor];
}

- (NSAttributedString *)titleLabelText
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(titleForScrollViewDataSet:)]) {
        return [self.dataSetSource titleForScrollViewDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)detailLabelText
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(descriptionForScrollViewDataSet:)]) {
        return [self.dataSetSource descriptionForScrollViewDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)buttonTitleForState:(UIControlState)state
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(buttonTitleForScrollViewDataSet:forState:)]) {
        return [self.dataSetSource buttonTitleForScrollViewDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)buttonBackgroundImageForState:(UIControlState)state
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(buttonBackgroundImageForScrollViewDataSet:forState:)]) {
        return [self.dataSetSource buttonBackgroundImageForScrollViewDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)image
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(imageForScrollViewDataSet:)]) {
        return [self.dataSetSource imageForScrollViewDataSet:self];
    }
    return nil;
}

- (CGFloat)verticalSpace
{
    if (self.dataSetDelegate && [self.dataSetSource respondsToSelector:@selector(spaceHeightForScrollViewDataSet:)]) {
        return [self.dataSetSource spaceHeightForScrollViewDataSet:self];
    }
    return 0.0;
}

- (UIView *)customView
{
    if (self.dataSetSource && [self.dataSetSource respondsToSelector:@selector(customViewForScrollViewDataSet:)]) {
        return [self.dataSetSource customViewForScrollViewDataSet:self];
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
    if (![[self.dataSetView.button attributedTitleForState:UIControlStateNormal].string isEqualToString:[self buttonTitleForState:UIControlStateNormal].string]) {
        return YES;
    }
    if (!([UIImagePNGRepresentation(self.dataSetView.imageView.image) isEqualToData:UIImagePNGRepresentation([self image])])) {
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

- (void)setDataSetSource:(id<DZNScrollViewDataSetSource>)source
{
    self.dataSetEnabled = source ? YES : NO;
    objc_setAssociatedObject(self, kDataSetSource, source, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setDataSetDelegate:(id<DZNScrollViewDataSetDelegate>)delegate
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
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kDZNDataSetViewDidTapButtonNotification object:nil];
            [self invalidateContent];
        }
        @catch(id anException) {
            // Do nothing. An exception might araise due to removing an none existent observer.
        }
    }
    else if (enable) {
        @try {
            [self addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:DZNContentSizeCtx];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapDataSetButton:) name:kDZNDataSetViewDidTapButtonNotification object:nil];
        }
        @catch(id anException) {
            // Do nothing. An exception might araise due to removing an none existent observer.
        }
    }
}


#pragma mark - UITableView+DataSet Methods

- (void)didTapContentView:(id)sender
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(scrollViewDataSetDidTapView:)]) {
        [self.dataSetDelegate scrollViewDataSetDidTapView:self];
    }
}

- (void)didTapDataSetButton:(id)sender
{
    if (self.dataSetDelegate && [self.dataSetDelegate respondsToSelector:@selector(scrollViewDataSetDidTapButton:)]) {
        [self.dataSetDelegate scrollViewDataSetDidTapButton:self];
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
    if ([self itemsCount] == 0)
    {
        [self.dataSetView updateConstraintsIfNeeded];
        
        if (![self customView] && [self needsReloadSets]) {
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
        }
        
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
                         completion:^(BOOL finished) {
                             NSLog(@"self.dataSetView : %@", self.dataSetView);
                         }];
    }
    else if (self.isDataSetVisible) {
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
    [self.dataSetView invalidateContent];
    [self.dataSetView removeFromSuperview];
    
    objc_setAssociatedObject(self, kDataSetView, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
