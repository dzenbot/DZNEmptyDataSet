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

@interface DZNEmptyDataSetView : UIView
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, weak) UIScrollView *hostView;

@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) CGFloat verticalSpace;
@property (nonatomic, getter = didCenterToSuperview) BOOL centerToSuperview;

- (void)removeSubviews;

@end

@implementation DZNEmptyDataSetView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;


#pragma mark - Initialization Methods

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


#pragma mark - Getters

- (UIView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    _contentView = [UIView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.userInteractionEnabled = YES;
    _contentView.alpha = 0;
    return _contentView;
}

- (UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    
    _imageView = [UIImageView new];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = NO;
    
    [_contentView addSubview:_imageView];
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [UILabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    _titleLabel.font = [UIFont systemFontOfSize:27.0];
    _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 2;
    
    [_contentView addSubview:_titleLabel];
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel) {
        return _detailLabel;
    }
    
    _detailLabel = [UILabel new];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailLabel.backgroundColor = [UIColor clearColor];
    
    _detailLabel.font = [UIFont systemFontOfSize:17.0];
    _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _detailLabel.numberOfLines = 0;
    
    [_contentView addSubview:_detailLabel];
    return _detailLabel;
}

- (UIButton *)button
{
    if (_button) {
        return _button;
    }
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.backgroundColor = [UIColor clearColor];
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_button];
    return _button;
}

- (BOOL)canShowImage {
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle {
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail {
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton {
    return ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 && _button.superview);
}


#pragma mark - Setters

- (void)setCustomView:(UIView *)view
{
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    if (!view) {
        return;
    }
        
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = !CGRectIsEmpty(view.frame);
    
    [_contentView addSubview:_customView];
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    SEL selector = NSSelectorFromString(@"dzn_didTapDataButton:");
    [self.hostView performSelector:selector withObject:sender afterDelay:0.0f];
}

- (void)removeSubviews
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
    
    if (!self.didCenterToSuperview) {
        self.centerToSuperview = YES;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-(<=0)-[_contentView]"
                                                                     options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-(<=0)-[_contentView]"
                                                                     options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
        
        if (!CGPointEqualToPoint(self.offset, CGPointZero) && self.constraints.count == 4) {
            
            NSLayoutConstraint *hConstraint = self.constraints[3];
            hConstraint.constant = self.offset.x*-1;
            
            NSLayoutConstraint *vConstraint = self.constraints[1];
            vConstraint.constant = self.offset.y*-1;
        }
    }
    
    if (_customView) {
        if (_customView) [views setObject:_customView forKey:@"customView"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:views]];
        return;
    }
    
    CGFloat width = (self.frame.size.width > 0) ? self.frame.size.width : [UIScreen mainScreen].bounds.size.width;
    
    NSInteger multiplier = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 16 : 4;
    NSNumber *padding = @(roundf(width/multiplier));
    NSNumber *imgWidth = @(roundf(_imageView.image.size.width));
    NSNumber *imgHeight = @(roundf(_imageView.image.size.height));
    NSNumber *trailing = @(roundf((width-[imgWidth floatValue])/2.0));
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding,trailing,imgWidth,imgHeight);
    
    // Assign the image view's horizontal constraints to the content view
    if (_imageView.superview) {
        [views setObject:_imageView forKey:@"imageView"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-trailing-[imageView(imgWidth)]-trailing-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    // Assign the title label's horizontal constraints to the content view
    if (_titleLabel.superview) {
        [views setObject:_titleLabel forKey:@"titleLabel"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabel]-padding-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    // Assign the detail label's horizontal constraints to the content view
    if (_detailLabel.superview) {
        [views setObject:_detailLabel forKey:@"detailLabel"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[detailLabel]-padding-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    // Assign the button's horizontal constraints to the content view
    if (_button.superview) {
        [views setObject:_button forKey:@"button"];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button]-padding-|"
                                                                             options:0 metrics:metrics views:views]];
    }
    
    // Since any element could be missing from displaying, we need to create a dynamic string format
    NSMutableString *format = [NSMutableString new];
    NSMutableArray *subviews = [NSMutableArray new];
    
    // Add any valid element
    if ([self canShowImage]) [subviews addObject:@"[imageView(imgHeight)]"];
    if ([self canShowTitle]) [subviews addObject:@"[titleLabel]"];
    if ([self canShowDetail]) [subviews addObject:@"[detailLabel]"];
    if ([self canShowButton]) [subviews addObject:@"[button]"];
    else {
        // Button force its bounds because of intrinsicContentSize, so even if there is no content on it, it shows up
        // We need to remove and invalidate it
        [_button removeFromSuperview];
        _button = nil;
    }
    
    // Build the string format for the vertical constraints, adding a gap between each element
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [format appendString:obj];
        if (idx < subviews.count-1) {
            if (_verticalSpace > 0) [format appendFormat:@"-%.f-", _verticalSpace];
            else [format appendString:@"-11-"];
        }
    }];
    
    // Assign the vertical constraints to the content view
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

@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) DZNEmptyDataSetView *emptyDataSetView;
@end

@implementation UIScrollView (DZNEmptyDataSet)

#pragma mark - Getters

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
        view = [DZNEmptyDataSetView new];
        view.hostView = self;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        view.userInteractionEnabled = YES;
        view.hidden = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dzn_didTapContentView:)];
        gesture.delegate = self;
        [view addGestureRecognizer:gesture];
        
        [self setEmptyDataSetView:view];
    }
    return view;
}

- (BOOL)isEmptyDataSetVisible
{
    UIView *view = objc_getAssociatedObject(self, kEmptyDataSetView);
    return view ? !view.hidden : NO;
}

- (BOOL)dzn_canDisplay
{
    if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]])
    {
        id source = self.emptyDataSetSource;
        
        if (source && [source conformsToProtocol:@protocol(DZNEmptyDataSetSource)]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}

- (BOOL)dzn_shouldDisplay
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldDisplay:)]) {
        return [self.emptyDataSetDelegate emptyDataSetShouldDisplay:self];
    }
    return YES;
}

- (BOOL)dzn_isTouchAllowed
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAllowTouch:)]) {
        return [self.emptyDataSetDelegate emptyDataSetShouldAllowTouch:self];
    }
    return YES;
}

- (BOOL)dzn_isScrollAllowed
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAllowScroll:)]) {
        return [self.emptyDataSetDelegate emptyDataSetShouldAllowScroll:self];
    }
    return NO;
}

- (UIColor *)dzn_dataSetBackgroundColor
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(backgroundColorForEmptyDataSet:)]) {
        return [self.emptyDataSetSource backgroundColorForEmptyDataSet:self];
    }
    return [UIColor clearColor];
}

- (NSAttributedString *)dzn_titleLabelText
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(titleForEmptyDataSet:)]) {
        return [self.emptyDataSetSource titleForEmptyDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)dzn_detailLabelText
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(descriptionForEmptyDataSet:)]) {
        return [self.emptyDataSetSource descriptionForEmptyDataSet:self];
    }
    return nil;
}

- (NSAttributedString *)dzn_buttonTitleForState:(UIControlState)state
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(buttonTitleForEmptyDataSet:forState:)]) {
        return [self.emptyDataSetSource buttonTitleForEmptyDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)dzn_buttonBackgroundImageForState:(UIControlState)state
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(buttonBackgroundImageForEmptyDataSet:forState:)]) {
        return [self.emptyDataSetSource buttonBackgroundImageForEmptyDataSet:self forState:state];
    }
    return nil;
}

- (UIImage *)dzn_image
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(imageForEmptyDataSet:)]) {
        return [self.emptyDataSetSource imageForEmptyDataSet:self];
    }
    return nil;
}

- (CGPoint)dzn_offset
{
    CGPoint offset = CGPointZero;
    
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(offsetForEmptyDataSet:)]) {
        offset = [self.emptyDataSetSource offsetForEmptyDataSet:self];
    }
    
    if ([self respondsToSelector:@selector(tableHeaderView)] && [self respondsToSelector:@selector(tableFooterView)]) {
        UIView *headerView = [self performSelector:@selector(tableHeaderView)];
        UIView *footerView = [self performSelector:@selector(tableFooterView)];
        
        offset.y += (headerView.frame.size.height-footerView.frame.size.height)/2;
    }
    
    return offset;
}

- (CGFloat)dzn_verticalSpace
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(spaceHeightForEmptyDataSet:)]) {
        return [self.emptyDataSetSource spaceHeightForEmptyDataSet:self];
    }
    return 0.0;
}

- (UIView *)dzn_customView
{
    if (self.emptyDataSetSource && [self.emptyDataSetSource respondsToSelector:@selector(customViewForEmptyDataSet:)]) {
        return [self.emptyDataSetSource customViewForEmptyDataSet:self];
    }
    return nil;
}

- (NSInteger)dzn_itemsCount
{
    NSInteger items = 0;
    
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    if ([self isKindOfClass:[UITableView class]]) {
        
        id <UITableViewDataSource> dataSource = [self performSelector:@selector(dataSource)];
        UITableView *tableView = (UITableView *)self;
        
        NSInteger sections = 1;
        if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        for (NSInteger i = 0; i < sections; i++) {
            items += [dataSource tableView:tableView numberOfRowsInSection:i];
        }
    }
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        id <UICollectionViewDataSource> dataSource = [self performSelector:@selector(dataSource)];
        UICollectionView *collectionView = (UICollectionView *)self;
        
        NSInteger sections = 1;
        if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        for (NSInteger i = 0; i < sections; i++) {
            items += [dataSource collectionView:collectionView numberOfItemsInSection:i];
        }
    }
    
    return items;
}


#pragma mark - Setters

- (void)setEmptyDataSetSource:(id<DZNEmptyDataSetSource>)source
{
    objc_setAssociatedObject(self, kEmptyDataSetSource, source, OBJC_ASSOCIATION_ASSIGN);
    
    if (![self dzn_canDisplay]) {
        return;
    }
    
    // We add method sizzling for injecting -dzn_reloadData implementation to the native -reloadData implementation
    [self swizzle:@selector(reloadData)];
    
    // If UITableView, we also inject -dzn_reloadData to -endUpdates
    if ([self isKindOfClass:[UITableView class]]) {
        [self swizzle:@selector(endUpdates)];
    }
}

- (void)setEmptyDataSetDelegate:(id<DZNEmptyDataSetDelegate>)delegate
{
    objc_setAssociatedObject(self, kEmptyDataSetDelegate, delegate, OBJC_ASSOCIATION_ASSIGN);
    
    if (!delegate) {
        [self dzn_invalidate];
    }
}

- (void)setEmptyDataSetView:(DZNEmptyDataSetView *)view
{
    objc_setAssociatedObject(self, kEmptyDataSetView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Events

- (void)dzn_willWillAppear
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetWillAppear:)]) {
        [self.emptyDataSetDelegate emptyDataSetWillAppear:self];
    }
}

- (void)dzn_willDisappear
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetWillDisappear:)]) {
        [self.emptyDataSetDelegate emptyDataSetWillDisappear:self];
    }
}

- (void)dzn_didTapContentView:(id)sender
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapView:)]) {
        [self.emptyDataSetDelegate emptyDataSetDidTapView:self];
    }
}

- (void)dzn_didTapDataButton:(id)sender
{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapButton:)]) {
        [self.emptyDataSetDelegate emptyDataSetDidTapButton:self];
    }
}


#pragma mark - Public Methods

- (void)reloadEmptyDataSet
{
    [self dzn_reloadEmptyDataSet];
}


#pragma mark - Private Methods

- (void)dzn_reloadEmptyDataSet
{
    if (![self dzn_canDisplay]) {
        return;
    }
    
    if ([self dzn_shouldDisplay] && [self dzn_itemsCount] == 0)
    {
        // Notifies that the empty dataset view will appear
        [self dzn_willWillAppear];
        
        DZNEmptyDataSetView *view = self.emptyDataSetView;
        UIView *customView = [self dzn_customView];
        
        if (!view.superview) {

            // Send the view to back, in case a header and/or footer is present
            if (self.subviews.count > 1) {
                [self insertSubview:view atIndex:1];
            }
            else {
                [self addSubview:view];
            }
        }
        
        // Moves all its subviews
        [view removeSubviews];
        
        // If a non-nil custom view is available, let's configure it instead
        if (customView) {
            view.customView = customView;
        }
        else {
            // Configure labels
            view.detailLabel.attributedText = [self dzn_detailLabelText];
            view.titleLabel.attributedText = [self dzn_titleLabelText];
            
            // Configure imageview
            view.imageView.image = [self dzn_image];
            
            // Configure button
            [view.button setAttributedTitle:[self dzn_buttonTitleForState:0] forState:0];
            [view.button setAttributedTitle:[self dzn_buttonTitleForState:1] forState:1];
            [view.button setBackgroundImage:[self dzn_buttonBackgroundImageForState:0] forState:0];
            [view.button setBackgroundImage:[self dzn_buttonBackgroundImageForState:1] forState:1];
            [view.button setUserInteractionEnabled:[self dzn_isTouchAllowed]];

            // Configure spacing
            view.verticalSpace = [self dzn_verticalSpace];
        }
        
        // Configure Offset
        view.offset = [self dzn_offset];
        
        // Configure the empty dataset view
        view.backgroundColor = [self dzn_dataSetBackgroundColor];
        view.hidden = NO;
        
        [view updateConstraints];
        [view layoutIfNeeded];
        
        // Configure scroll permission
        self.scrollEnabled = [self dzn_isScrollAllowed];
    }
    else if (self.isEmptyDataSetVisible) {
        [self dzn_invalidate];
    }
}

- (void)dzn_invalidate
{
    // Notifies that the empty dataset view will disappear
    [self dzn_willDisappear];

    if (self.emptyDataSetView) {
        [self.emptyDataSetView removeSubviews];
        [self.emptyDataSetView removeFromSuperview];
        
        [self setEmptyDataSetView:nil];
    }
    
    self.scrollEnabled = YES;
}


#pragma mark - Method Swizzling

static NSMutableDictionary *_impLookupTable;
static NSString *const DZNSwizzleInfoPointerKey = @"pointer";
static NSString *const DZNSwizzleInfoOwnerKey = @"owner";
static NSString *const DZNSwizzleInfoSelectorKey = @"selector";

// Based on Bryce Buchanan's swizzling technique http://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
// And Juzzin's ideas https://github.com/juzzin/JUSEmptyViewController

void dzn_original_implementation(id self, SEL _cmd)
{
    // Fetch original implementation from lookup table
    NSString *key = dzn_implementationKey(self, _cmd);
    
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:DZNSwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // We then inject the additional implementation for reloading the empty dataset
    // Doing it before calling the original implementation does update the 'isEmptyDataSetVisible' flag on time.
    [self dzn_reloadEmptyDataSet];

    // If found, call original implementation
    if (impPointer) {
        ((void(*)(id,SEL))impPointer)(self,_cmd);
    }
}

NSString *dzn_implementationKey(id target, SEL selector)
{
    if (!target || !selector) {
        return nil;
    }
    
    Class baseClass;
    if ([target isKindOfClass:[UITableView class]]) baseClass = [UITableView class];
    else if ([target isKindOfClass:[UICollectionView class]]) baseClass = [UICollectionView class];
    else return nil;
    
    NSString *className = NSStringFromClass([baseClass class]);
    
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}


- (void)swizzle:(SEL)selector
{
    // Check if the target responds to selector
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    // Create the lookup table
    if (!_impLookupTable) {
        _impLookupTable = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    
    // We make sure that setImplementation is called once per class kind, UITableView or UICollectionView.
    for (NSDictionary *info in [_impLookupTable allValues]) {
        Class class = [info objectForKey:DZNSwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:DZNSwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    NSString *key = dzn_implementationKey(self, selector);
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:DZNSwizzleInfoPointerKey];
    
    // If the implementation for this class already exist, skip!!
    if (impValue) {
        return;
    }
    
    // Swizzle by injecting additional implementation
    Method method = class_getInstanceMethod([self class], selector);
    IMP dzn_newImplementation = method_setImplementation(method, (IMP)dzn_original_implementation);
    
    // Store the new implementation in the lookup table
    NSDictionary *swizzledInfo = @{DZNSwizzleInfoOwnerKey: [self class],
                                   DZNSwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   DZNSwizzleInfoPointerKey: [NSValue valueWithPointer:dzn_newImplementation]};
    
    [_impLookupTable setObject:swizzledInfo forKey:key];
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self.emptyDataSetView]) {
        return [self dzn_isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
