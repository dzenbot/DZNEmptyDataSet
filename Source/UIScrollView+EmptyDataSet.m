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
#import <objc/runtime.h>

#pragma mark - DZNEmptyDataSetView

#define kDZNEmptyDataSetDidTapButtonNotification @"com.dzn.notifications.emptyDataSet.didTapButton"

@interface DZNEmptyDataSetView : UIView
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, assign) CGFloat verticalSpace;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic) BOOL didConfigureConstraints;

- (void)invalidateContent;

@end

@implementation DZNEmptyDataSetView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

- (instancetype)init
{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.frame = self.superview.bounds;
    
    [UIView animateWithDuration:0.25
                     animations:^{_contentView.alpha = 1.0;}
                     completion:NULL];
}


#pragma mark - Getter Methods

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.alpha = 0;
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
        
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        
        [_contentView addSubview:_titleLabel];
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
        _detailLabel.numberOfLines = 0;
        
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.adjustsImageWhenHighlighted = YES;
        _button.userInteractionEnabled = YES;
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_button];
    }
    return _button;
}


#pragma mark - Setter Methods

- (void)setCustomView:(UIView *)view
{
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
        return;
    }
    
    if (!view) {
        return;
    }
    
    [self invalidateContent];
    
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = !CGRectIsEmpty(view.frame);
    
    [_contentView addSubview:_customView];
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDZNEmptyDataSetDidTapButtonNotification object:nil];
}

- (void)invalidateContent
{
    [_titleLabel removeFromSuperview];
    [_detailLabel removeFromSuperview];
    [_imageView removeFromSuperview];
    [_button removeFromSuperview];
    [_customView removeFromSuperview];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
}


#pragma mark - UIView Constraints & Layout Methods

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (_contentView.constraints.count > 0) {
        [_contentView removeConstraints:_contentView.constraints];
    }
    
    NSMutableDictionary *views = [NSMutableDictionary dictionaryWithDictionary:NSDictionaryOfVariableBindings(self,_contentView)];
    
    if (!self.didConfigureConstraints) {
        self.didConfigureConstraints = YES;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-(<=0)-[_contentView]"
                                                                     options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-(<=0)-[_contentView]"
                                                                     options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    }
    
    if (!CGPointEqualToPoint(self.offset, CGPointZero)) {
        
        NSLayoutConstraint *hConstraint = self.constraints[3];
        hConstraint.constant = self.offset.x*-1;
        
        NSLayoutConstraint *vConstraint = self.constraints[1];
        vConstraint.constant = self.offset.y*-1;
    }
    
    if (_customView) {
        if (_customView) [views setObject:_customView forKey:@"_customView"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_customView]|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_customView]|" options:0 metrics:nil views:views]];
        return;
    }
    
    CGFloat width = (self.frame.size.width > 0) ? self.frame.size.width : [UIScreen mainScreen].bounds.size.width;
    
    NSInteger multiplier = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 16 : 4;
    NSNumber *padding = @(roundf(width/multiplier));
    NSNumber *imgWidth = @(roundf(_imageView.image.size.width));
    NSNumber *imgHeight = @(roundf(_imageView.image.size.height));
    NSNumber *trailing = @(roundf((width-[imgWidth floatValue])/2.0));
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding,trailing,imgWidth,imgHeight);
    
    if (_titleLabel.superview) {
        [views setObject:_titleLabel forKey:@"_titleLabel"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_titleLabel]-padding-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    if (_detailLabel.superview) {
        [views setObject:_detailLabel forKey:@"_detailLabel"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_detailLabel]-padding-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    if (_imageView) {
        [views setObject:_imageView forKey:@"_imageView"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-trailing-[_imageView(imgWidth)]-trailing-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    if (_button) {
        [views setObject:_button forKey:@"_button"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_button]-padding-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    NSMutableString *format = [NSMutableString new];
    NSMutableArray *subviews = [NSMutableArray new];
    
    if (_imageView.image) [subviews addObject:@"[_imageView(imgHeight)]"];
    if (_titleLabel.attributedText.string.length > 0) [subviews addObject:@"[_titleLabel]"];
    if (_detailLabel.attributedText.string.length > 0) [subviews addObject:@"[_detailLabel]"];
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0) [subviews addObject:@"[_button]"];
    
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [format appendString:obj];
        if (idx < subviews.count-1) {
            if (_verticalSpace > 0) [format appendFormat:@"-%.f-", _verticalSpace];
            else [format appendString:@"-11-"];
        }
    }];
    
    if (format.length > 0) {
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", format]
                                                                             options:0 metrics:metrics views:views]];
    }
}

@end

#pragma mark - UIScrollView+EmptyDataSet

static char const * const kEmptyDataSetSource =     "emptyDataSetSource";
static char const * const kEmptyDataSetDelegate =   "emptyDataSetDelegate";
static char const * const kEmptyDataSetView =       "emptyDataSetView";
static char const * const kEmptyDataSetEnabled =    "emptyDataSetEnabled";
static NSString * const kContentSize =              @"contentSize";
static void *DZNContentSizeCtx =                    &DZNContentSizeCtx;

@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) DZNEmptyDataSetView *emptyDataSetView;
@property (nonatomic, getter = isEmptyDataSetEnabled) BOOL emptyDataSetEnabled;
@property (nonatomic, getter = isStoryboardEnabled) BOOL storyboardEnabled;
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
        view = [[DZNEmptyDataSetView alloc] init];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = nil;
        view.hidden = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        gesture.delegate = self;
        [view addGestureRecognizer:gesture];
        
        [self setEmptyDataSetView:view];
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

- (BOOL)isStoryboardEnabled
{
    NSString *filename = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIMainStoryboardFile"];
    return filename.length > 0;
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

- (CGPoint)offset
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(offsetForEmptyDataSet:)]) {
        return [self.emptyDataSetSource offsetForEmptyDataSet:self];
    }
    return CGPointZero;
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
    if (self.emptyDataSetView.customView) {
        return NO;
    }
    
    return NO;
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

- (void)setEmptyDataSetView:(DZNEmptyDataSetView *)view
{
    objc_setAssociatedObject(self, kEmptyDataSetView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
            
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld;
            
            // For storyboard enabled applications, we requiere another notification for prior the contenSize value changes.
            if (self.isStoryboardEnabled) options = options|NSKeyValueObservingOptionPrior;
            
            [self addObserver:self forKeyPath:kContentSize options:options context:DZNContentSizeCtx];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTapDataSetButton:) name:kDZNEmptyDataSetDidTapButtonNotification object:nil];
        }
        @catch(id anException) {
            // Do nothing. An exception might araise due to removing an none existent observer.
        }
    }
}


#pragma mark - Action Methods

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
    if ([self itemsCount] == 0 && [self needsReloadSets])
    {
        DZNEmptyDataSetView *view = self.emptyDataSetView;
        UIView *customView = [self customView];
        
        if (!view.superview) {
            [self insertSubview:view atIndex:0];
        }
        
        [view updateConstraintsIfNeeded];
        
        // If a non-nil custom view is available, let's configure it instead
        if (customView) {
            view.customView = customView;
        }
        else {
            view.customView = nil;
            
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
            
            // Configure offset and spacing
            view.offset = [self offset];
            view.verticalSpace = [self verticalSpace];
        }
        
        // Configure the empty dataset view
        view.backgroundColor = [self dataSetBackgroundColor];
        view.hidden = NO;
        
        [view updateConstraints];
        [view layoutIfNeeded];
        
        // Configure scroll permission
        self.scrollEnabled = [self isScrollAllowed];
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
    
    [self setEmptyDataSetView:nil];
    
    self.scrollEnabled = YES;
}


#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // We check for the KVO context notifications
    if (context == DZNContentSizeCtx)
    {
        NSValue *new = [change objectForKey:@"new"];
        NSValue *old = [change objectForKey:@"old"];
        
        // The contenSize property behave differently when using storyboard, so we have 2 case scenarios to detect real changes
        if ((self.isStoryboardEnabled && !new && old) || (new && old && ![new isEqualToValue:old])) {
            
            // We then assume that -reloadData was called, by adding or removing cells to the table
            [self didReloadData];
        }
    }
    else {
        // We must call super in case the object is expecting more KVO notifications
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:kContentSize]) {
        return YES;
    }
    
    return [super automaticallyNotifiesObserversForKey:key];
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
