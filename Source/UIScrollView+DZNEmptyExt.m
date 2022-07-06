//
//  UIScrollView+DZNEmptyExt.m
//  JLEmptyExt
//
//  Created by Jialun Zeng on 2017/4/21.
//  Copyright © 2017年 com.jl.emptyext. All rights reserved.
//

#import "UIScrollView+DZNEmptyExt.h"
#import <objc/runtime.h>

@implementation UIScrollView (DZNEmptyExt)

static const char typeKey;
static const char emptyMakerKey;


#pragma mark - reload

-(void)reloadData:(DZNDisplayScene)scene{
    
    [self setScrollViewType: scene];
    
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    
    if ([self isKindOfClass: [UITableView class]]) {
        UITableView * tableView = (UITableView *)self;
        [tableView reloadData];
    }else if ([self isKindOfClass: [UICollectionView class]]){
        UICollectionView * collectionView = (UICollectionView *)self;
        [collectionView reloadData];
    }else{
        [self reloadEmptyDataSet];
    }
    
    DZNEmptyMaker * maker = [self getEmptyMaker];
    
    if (maker.sceneBlock) {
        maker.sceneBlock(scene);
    }
}

-(DZNEmptyMaker *)makeEmptyPage:(DZNEmptyMakerBlock)block{
    
    DZNEmptyMaker * maker = [[DZNEmptyMaker alloc] init];
    
    maker.editType = DZNEmptyEditTypeMake;
    
    [self setEmptyMaker: maker];
    
    if (block) {
        block(maker);
    }
    
    return maker;
}

-(DZNEmptyMaker *)addEmptyPage:(DZNEmptyMakerBlock)block{
    
    DZNEmptyMaker * maker = [self getEmptyMaker];
    
    maker.editType = DZNEmptyEditTypeAdd;
    
    if (block) {
        block(maker);
    }
    
    return maker;
}

-(DZNEmptyMaker *)updateEmptyPage:(DZNEmptyMakerBlock)block{
    
    DZNEmptyMaker * maker = [self getEmptyMaker];
    
    maker.editType = DZNEmptyEditTypeUpdate;
    
    if (block) {
        block(maker);
    }
    
    return maker;
}


-(DZNDisplayScene)displayScene{
    return [self getScrollViewType];
}


#pragma mark - save data


- (void)setEmptyMaker:(DZNEmptyMaker *)emptyMaker{
    objc_setAssociatedObject(self, &emptyMakerKey, emptyMaker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DZNEmptyMaker *) getEmptyMaker{
    return objc_getAssociatedObject(self, &emptyMakerKey);
}

- (void)setScrollViewType:(DZNDisplayScene)scrollViewType{
    objc_setAssociatedObject(self, &typeKey, scrollViewType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DZNDisplayScene)getScrollViewType{
    return objc_getAssociatedObject(self, &typeKey);
}

//Get the "DZNEmpty" object in the current state
- (DZNEmpty *)getEmpty{
    NSMutableDictionary * dataSource = [self getEmptyMaker].dataSource;
    return [dataSource objectForKey: [NSString stringWithFormat: @"%ld", (long)[self getScrollViewType]]];
}

- (DZNEmpty <DZNEmptyDataSource, DZNEmptyDelegate, DZNEmptyCustomSource>*)getEmptyMake:(DZNDisplayScene)displayScene{
    NSMutableDictionary * dataSource = [self getEmptyMaker].dataSource;
    return [dataSource objectForKey: [NSString stringWithFormat: @"%ld", (long)displayScene]];
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[self getEmpty] valueForKey: @"Image"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[self getEmpty] valueForKey: @"Title"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[self getEmpty] valueForKey: @"Describe"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    DZNEmpty * empty = [self getEmpty];
    
    NSString * key = [NSString stringWithFormat:@"%lu", (unsigned long)state];
    return [[empty valueForKey:@"ButtonTitles"] valueForKey: key];
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    DZNEmpty * empty = [self getEmpty];
    
    NSString * key = [NSString stringWithFormat:@"%lu", (unsigned long)state];
    return [[empty valueForKey:@"ButtonImages"] valueForKey: key];
}

- (nullable UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    DZNEmpty * empty = [self getEmpty];
    
    NSString * key = [NSString stringWithFormat:@"%lu", (unsigned long)state];
    return [[empty valueForKey:@"ButtonBackImages"] valueForKey: key];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[self getEmpty] valueForKey: @"ImageAnimation"];
}

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[self getEmpty] valueForKey: @"CustomView"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[self getEmpty] valueForKey: @"BackgroundColor"];
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[[self getEmpty] valueForKey: @"Offset"] floatValue];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[[self getEmpty] valueForKey: @"SpaceHeight"] floatValue];
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[self getEmpty] valueForKey: @"ImageTintColor"];
}


#pragma mark DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if ([[self getScrollViewType] isEqualToString: hideEmptyDataSet]) return NO;
    return [[[self getEmpty] valueForKey: @"ShouldDisplay"] boolValue];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return [[[self getEmpty] valueForKey: @"AllowTouch"] boolValue];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return [[[self getEmpty] valueForKey: @"AllowScroll"] boolValue];
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return [[[self getEmpty] valueForKey: @"AllowImageAnimate"] boolValue];
}

- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView
{
    return [[[self getEmpty] valueForKey: @"ShouldFadeIn"] boolValue];
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView
{
    return [[[self getEmpty] valueForKey: @"ShouldBeForcedToDisplay"] boolValue];
}



- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView{
    DZNEmptyMaker * maker = [self getEmptyMaker];
    if (maker.lifeCycleBlock) {
        maker.lifeCycleBlock(DZNEmptyViewWillAppear);
    }
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView{
    DZNEmptyMaker * maker = [self getEmptyMaker];
    if (maker.lifeCycleBlock) {
        maker.lifeCycleBlock(DZNEmptyViewDidAppear);
    }
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView{
    DZNEmptyMaker * maker = [self getEmptyMaker];
    if (maker.lifeCycleBlock) {
        maker.lifeCycleBlock(DZNEmptyViewWillDisappear);
    }
}

- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView{
    DZNEmptyMaker * maker = [self getEmptyMaker];
    if (maker.lifeCycleBlock) {
        maker.lifeCycleBlock(DZNEmptyViewDidDisappear);
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    DZNEmptyMaker * maker = [self getEmptyMaker];
    if (maker.tapBlock) {
        maker.tapBlock(DZNTapOfView, self, view);
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    DZNEmptyMaker * maker = [self getEmptyMaker];
    if (maker.tapBlock) {
        maker.tapBlock(DZNTapOfButton, self, button);
    }
}


@end


//_______________________________________________________________________________________________________________

@implementation DZNEmptyMaker

-(NSMutableDictionary *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableDictionary alloc] init];
    }
    return _dataSource;
}


-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate, DZNEmptyCustomSource> * (^)(DZNDisplayScene type))displayScene{
    
    return ^DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate, DZNEmptyCustomSource> *(DZNDisplayScene type){
        
        DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate, DZNEmptyCustomSource> * empty;
        
        if (self.editType == DZNEmptyEditTypeUpdate) {
            empty = [self.dataSource objectForKey: [NSString stringWithFormat: @"%ld", (long)type]];
        }else{
            empty = [[DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate, DZNEmptyCustomSource> alloc] init];
            [self.dataSource setObject: empty forKey: [NSString stringWithFormat: @"%ld", (long)type]];
        }
        
        return empty;
    };
}

-(DZNEmptyMaker *)emptySceneChange:(DZNSceneChangeBlock)block{
    self.sceneBlock = block;
    return self;
}

-(DZNEmptyMaker *)emptyViewLifeCycle:(DZNEmptyViewLifeCycleBlock)block{
    self.lifeCycleBlock = block;
    return self;
}


-(DZNEmptyMaker *)emptyDisplayClick:(DZNTapBlock)block{
    self.tapBlock = block;
    return self;
}


@end

//_______________________________________________________________________________________________________________

@interface DZNEmpty ()<DZNEmptyCustomSource,DZNEmptyDelegate,DZNEmptyDataSource>

@property (nonatomic ,strong) UIImage             * Image;
@property (nonatomic ,strong) NSMutableDictionary * ButtonImages;
@property (nonatomic ,strong) NSMutableDictionary * ButtonBackImages;
@property (nonatomic ,strong) NSNumber            * AllowImageAnimate;
@property (nonatomic ,strong) NSNumber            * SpaceHeight;
@property (nonatomic ,strong) CAAnimation         * ImageAnimation;
@property (nonatomic ,strong) NSAttributedString  * Title;
@property (nonatomic ,strong) NSAttributedString  * Describe;
@property (nonatomic ,strong) NSMutableDictionary * ButtonTitles;
@property (nonatomic ,strong) NSAttributedString  * ButtonTitle;
@property (nonatomic ,strong) NSAttributedString  * ButtonTitleHighlighted;
@property (nonatomic ,strong) NSNumber            * Offset;
@property (nonatomic ,strong) NSNumber            * AllowScroll;
@property (nonatomic ,strong) NSNumber            * AllowTouch;
@property (nonatomic ,strong) NSNumber            * ShouldDisplay;
@property (nonatomic ,strong) NSNumber            * ShouldFadeIn;
@property (nonatomic ,strong) NSNumber            * ShouldBeForcedToDisplay;
@property (nonatomic ,strong) UIColor             * BackgroundColor;
@property (nonatomic ,strong) UIColor             * ImageTintColor;
@property (nonatomic ,strong) UIView              * CustomView;

@end

@implementation DZNEmpty

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.Offset                  = [NSNumber numberWithFloat: 0.0];
        self.AllowTouch              = [NSNumber numberWithBool: YES];
        self.AllowScroll             = [NSNumber numberWithBool: NO];
        self.ShouldFadeIn            = [NSNumber numberWithBool: YES];
        self.ShouldDisplay           = [NSNumber numberWithBool: YES];
        self.AllowImageAnimate       = [NSNumber numberWithBool: NO];
        self.ShouldBeForcedToDisplay = [NSNumber numberWithBool: NO];
        self.ButtonBackImages        = [[NSMutableDictionary alloc]init];
        self.ButtonImages            = [[NSMutableDictionary alloc]init];
        self.ButtonTitles            = [[NSMutableDictionary alloc]init];
    }
    return self;
}


#pragma mark - Custom Empty

-(DZNEmpty<DZNEmptyDelegate> * (^)(UIView * view))customView{
    return ^id(UIView * view){
        self.CustomView = view;
        return self;
    };
}


#pragma mark - 默认的缺省页设置

-(DZNDefaultStrBlock)title{
    return ^(NSString * title, UIFont * font, UIColor * color){
        if (title) {
            if (!font) font = [UIFont systemFontOfSize: 17];
            if (!color) color = [UIColor lightGrayColor];
            
            NSDictionary *attributes = @{NSFontAttributeName: font,
                                         NSForegroundColorAttributeName: color};
            
            self.Title = [[NSAttributedString alloc] initWithString: title attributes: attributes];
        }
        
        return self;
    };
}

-(DZNDefaultStrBlock)describe{
    return ^(NSString * title, UIFont * font, UIColor * color){
        if (title) {
            if (!font) font = [UIFont systemFontOfSize: 17];
            if (!color) color = [UIColor lightGrayColor];
            
            NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            paragraph.alignment = NSTextAlignmentCenter;
            NSDictionary *attributes = @{NSFontAttributeName: font,
                                         NSForegroundColorAttributeName: color,
                                         NSParagraphStyleAttributeName: paragraph};
            
            self.Describe = [[NSAttributedString alloc] initWithString: title attributes: attributes];
        }
        
        return self;
    };
}

-(DZNButtonStrBlock)buttonTitle{
    return ^(NSString *title, UIFont * font, UIColor * color, UIControlState state){
        if (title) {
            if (!font) font = [UIFont systemFontOfSize: 17];
            if (!color) color = [UIColor lightGrayColor];
            
            NSDictionary *attributes = @{NSFontAttributeName: font,
                                         NSForegroundColorAttributeName: color};
            
            NSString * key = [NSString stringWithFormat:@"%lu", (unsigned long)state];
            NSAttributedString * str = [[NSAttributedString alloc] initWithString: title attributes: attributes];
            
            self.ButtonTitles[key] = str;
        }
        
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate, DZNEmptyDataSource> * (^)(NSAttributedString * title, UIControlState state))attrButtonTitle{
    return ^id (NSAttributedString * title, UIControlState state){
        NSString * key = [NSString stringWithFormat:@"%lu", (unsigned long)state];
        self.ButtonTitles[key] = title;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate, DZNEmptyDataSource> * (^)(NSAttributedString * title))attrTitle{
    return ^id (NSAttributedString * title){
        self.Title = title;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate, DZNEmptyDataSource> * (^)(NSAttributedString * title))attrDescribe{
    return ^id (NSAttributedString * title){
        self.Describe = title;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(UIImage * img))image{
    return ^id(UIImage * img){
        self.Image = img;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(UIImage * img, UIControlState state))buttonImage{
    return ^id(UIImage * img, UIControlState state){
        NSString * key = [NSString stringWithFormat:@"%lu", (unsigned long)state];
        self.ButtonImages[key] = img;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(UIImage * img, UIControlState state))buttonBackImage{
    return ^id(UIImage * img, UIControlState state){
        NSString * key = [NSString stringWithFormat:@"%lu", (unsigned long)state];
        self.ButtonBackImages[key] = img;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(CAAnimation * animation))imageAnimation{
    return ^id(CAAnimation * animation){
        self.ImageAnimation = animation;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(CGFloat spaceHeight))spaceHeight{
    return ^id(CGFloat spaceHeight){
        self.SpaceHeight = [NSNumber numberWithFloat: spaceHeight];
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate> * (^)(CGFloat offset))offset{
    return ^id(CGFloat offset){
        self.Offset = [NSNumber numberWithFloat: offset];
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(UIColor * color))backgroundColor{
    return ^id (UIColor * color){
        self.BackgroundColor = color;
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(UIColor * color))imageTintColor{
    return ^id (UIColor * color){
        self.ImageTintColor = color;
        return self;
    };
}


#pragma mark - delegate

-(DZNEmpty<DZNEmptyDelegate> * (^)(BOOL allow))allowScroll{
    return ^id(BOOL allow){
        self.AllowScroll = [NSNumber numberWithBool: allow];
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate> * (^)(BOOL allow))allowTouch{
    return ^id(BOOL allow){
        self.AllowTouch = [NSNumber numberWithBool: allow];
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate> * (^)(BOOL should))shouldDisplay{
    return ^id(BOOL should){
        self.ShouldDisplay = [NSNumber numberWithBool: should];
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate> * (^)(BOOL should))shouldFadeIn{
    return ^id(BOOL should){
        self.ShouldFadeIn = [NSNumber numberWithBool: should];
        return self;
    };
}

-(DZNEmpty<DZNEmptyDelegate> * (^)(BOOL should))shouldBeForcedToDisplay{
    return ^id(BOOL should){
        self.ShouldBeForcedToDisplay = [NSNumber numberWithBool: should];
        return self;
    };
}

-(DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * (^)(BOOL allow))allowImageAnimate{
    return ^id(BOOL allow){
        self.AllowImageAnimate = [NSNumber numberWithBool: allow];
        return self;
    };
}

- (void)end {}

@end


