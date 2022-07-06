//
//  UIScrollView+DZNEmptyExt.h
//  JLEmptyExt
//
//  Created by Jialun Zeng on 2017/4/21.
//  Copyright © 2017年 com.jl.emptyext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"
@class DZNEmptyMaker;
@class DZNEmpty;

NS_ASSUME_NONNULL_BEGIN

@protocol DZNEmptyCustomSource;
@protocol DZNEmptyDelegate;
@protocol DZNEmptyDataSource;

typedef NSString * DZNDisplayScene;

// Normal display page (no empty view)
static DZNDisplayScene hideEmptyDataSet = @"DZNDisplaySceneHideEmptyDataSet";

typedef NS_ENUM(NSInteger, DZNTapType) {
    // Tells the delegate that the action button was tapped.
    DZNTapOfButton,
    // Tells the delegate that the empty dataset view was tapped. Use this method either to resignFirstResponder of a textfield or searchBar.
    DZNTapOfView,
};

typedef NS_ENUM(NSInteger, DZNEmptyViewLifeCycle) {
    DZNEmptyViewWillAppear, // Tells the delegate that the empty data set will appear.
    DZNEmptyViewDidAppear, // Tells the delegate that the empty data set did appear.
    DZNEmptyViewWillDisappear, // Tells the delegate that the empty data set will disappear.
    DZNEmptyViewDidDisappear, // Tells the delegate that the empty data set did disappear.
};


typedef void (^DZNEmptyMakerBlock)(DZNEmptyMaker * make);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNDefaultStrBlock)(NSString * title, UIFont * font, UIColor * color);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNButtonStrBlock)(NSString * title, UIFont * font, UIColor * color, UIControlState state);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNAttrButtonStrBlock)(NSAttributedString * title, UIControlState state);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNAttrStrBlock)(NSAttributedString * title);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNButtonImageBlock)(UIImage * img, UIControlState state);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNImageBlock)(UIImage * img);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNShowAnimateBlock)(BOOL allow);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNAnimationBlock)(CAAnimation * animation);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNFloatBlock)(CGFloat spaceHeight);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate> * _Nonnull (^DZNColorBlock)(UIColor * color);
typedef DZNEmpty<DZNEmptyDelegate> * _Nonnull (^DZNBoolBlock)(BOOL allow);
typedef DZNEmpty<DZNEmptyDelegate> * _Nonnull (^DZNOffsetBlock)(CGFloat offset);
typedef DZNEmpty<DZNEmptyDelegate> * _Nonnull (^DZNCustomBlock)(UIView * view);


//_____________________________________________________________________________

#pragma mark public Delegate
@protocol DZNEmptyDelegate <NSObject>

/**
 Asks the delegate for scroll permission. Default is NO.
 */
@property (nonatomic ,copy) DZNBoolBlock allowScroll;

/**
 Asks the delegate for touch permission. Default is YES.
 */
@property (nonatomic ,copy) DZNBoolBlock allowTouch;

/**
 Asks the delegate to know if the empty dataset should fade in when displayed. Default is YES.
 */
@property (nonatomic ,copy) DZNBoolBlock shouldFadeIn;

/**
 Asks the delegate to know if the empty dataset should still be displayed when the amount of items is more than 0. Default is NO
 */
@property (nonatomic ,copy) DZNBoolBlock shouldBeForcedToDisplay;

/**
 Asks the delegate to know if the empty dataset should be rendered and displayed. Default is YES.
 */
@property (nonatomic ,copy) DZNBoolBlock shouldDisplay;

/**
 Asks the delegate for image view animation permission. Default is NO.
 */
@property (nonatomic, copy) DZNShowAnimateBlock allowImageAnimate;

/**
 Used to eliminate swift warning instead of @discardableResult
 */
- (void)end;

@end

//_____________________________________________________________________________

#pragma mark Custom layout Delegate

@protocol DZNEmptyCustomSource <NSObject>

/**
 Asks the data source for a custom view to be displayed instead of the default views such as labels, imageview and button. Default is nil.
 Use this method to show an activity view indicator for loading feedback, or for complete custom empty data set.
 Returning a custom view will ignore -offsetForEmptyDataSet and -spaceHeightForEmptyDataSet configurations.
 */
@property (nonatomic ,copy) DZNCustomBlock customView;

@end

//_____________________________________________________________________________


#pragma mark default layout Delegate

@protocol DZNEmptyDataSource <NSObject>

/**
 Asks the data source for the title of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 */
@property (nonatomic ,copy) DZNDefaultStrBlock title;

/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 */
@property (nonatomic ,copy) DZNDefaultStrBlock describe;

/**
 Asks the data source for the title to be used for the normal button state.
  The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 */
@property (nonatomic ,copy) DZNButtonStrBlock buttonTitle;
@property (nonatomic, copy) DZNAttrButtonStrBlock attrButtonTitle;

/**
 Asks the data source for the image to be used for the specified  button state. present the image only without any text
 */
@property (nonatomic, copy) DZNButtonImageBlock buttonImage;

/**
 Asks the data source for a background image to be used for the specified button status
 There is no default style for this call.
 */
@property (nonatomic, copy) DZNButtonImageBlock buttonBackImage;

/**
 Asks the data source for the title of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 */

@property (nonatomic, copy) DZNAttrStrBlock attrTitle;

/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 */
@property (nonatomic, copy) DZNAttrStrBlock attrDescribe;

/**
 Asks the data source for the image of the dataset.
 */
@property (nonatomic, copy) DZNImageBlock image;

/**
 Asks the data source for a vertical space between elements. Default is 11 pts.
 */
@property (nonatomic, copy) DZNFloatBlock spaceHeight;

/**
 Asks the data source for the image animation of the dataset.
 */
@property (nonatomic, copy) DZNAnimationBlock imageAnimation;

/**
 Asks the data source for a offset for vertical and horizontal alignment of the content. Default is CGPointZero.
 */
@property (nonatomic ,copy) DZNOffsetBlock offset;

/**
 Asks the data source for the background color of the dataset. Default is clear color.
 */
@property (nonatomic ,copy) DZNColorBlock backgroundColor;

/**
 Asks the data source for a tint color of the image dataset. Default is nil.
 */
@property (nonatomic ,copy) DZNColorBlock imageTintColor;

@end


//_______________________________________________________________________________________________________________


@interface UIScrollView (DZNEmptyExt)<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

// get current display scene
- (DZNDisplayScene)displayScene;

/**
 reload and Toggle display scene
 
 @param scene Desired display scene
 You can directly use strings to represent scene
 eg:  [scrollview reloadData: @"no order"];
 */
- (void)reloadData:(DZNDisplayScene)scene;

/**
 Get "make" in the specified state
 
 @param displayScene  input DZNdisplayScene(NSString)
 */
- (DZNEmpty <DZNEmptyDataSource, DZNEmptyDelegate, DZNEmptyCustomSource>*)getEmptyMake:(DZNDisplayScene)displayScene;

/**
 Initialize or reset empty page content
 
 @param block block
 @return DZNEmptyMaker object
 */
-(DZNEmptyMaker *)makeEmptyPage:(DZNEmptyMakerBlock)block;

/**
 add Empty Page content(Existing ones will be overwritten）

@param block block
@return DZNEmptyMaker object
*/
-(DZNEmptyMaker *)addEmptyPage:(DZNEmptyMakerBlock)block;

/**
 update Empty Page content（Only configured states can be modified）

@param block block
@return DZNEmptyMaker object
*/
-(DZNEmptyMaker *)updateEmptyPage:(DZNEmptyMakerBlock)block;

@end


//_______________________________________________________________________________________________________________

typedef NS_ENUM(NSInteger, DZNEmptyEditType) {
    DZNEmptyEditTypeMake,
    DZNEmptyEditTypeUpdate,
    DZNEmptyEditTypeAdd,
};

typedef void (^DZNSceneChangeBlock)(DZNDisplayScene type);
typedef void (^DZNEmptyViewLifeCycleBlock)(DZNEmptyViewLifeCycle status);
typedef void (^DZNTapBlock)(DZNTapType tapType, UIScrollView * scrollView, UIView * view);
typedef DZNEmpty<DZNEmptyDataSource, DZNEmptyDelegate, DZNEmptyCustomSource> * _Nonnull (^DZNdisplaySceneBlock)(DZNDisplayScene type);


@interface DZNEmptyMaker : NSObject

@property (nonatomic ,strong) NSMutableDictionary      * dataSource;
@property (nonatomic ,copy)   DZNTapBlock                tapBlock;
@property (nonatomic ,copy)   DZNEmptyViewLifeCycleBlock lifeCycleBlock;
@property (nonatomic ,copy)   DZNSceneChangeBlock       sceneBlock;
@property (nonatomic ,assign) DZNEmptyEditType           editType;

/**
 You can directly use strings to represent states
 eg:
    //   Bind display to scene
    [tableView makeEmptyPage:^(DZNEmptyMaker *make) {
    make.displayScene(@"no order")
    ........; // The specific content corresponding to the scene, such as title, picture, button, etc
        
    make.displayScene(displaySceneNetworkFailure)
    ........; // The specific content corresponding to the scene, such as title, picture, button, etc
    }];
    //  reloadData with scene
    [tableView reloadData: @"no order"]; or  [tableView reloadData: displaySceneNetworkFailure];
 */
@property (nonatomic ,copy) DZNdisplaySceneBlock displayScene;

/**
 Callback when changing the current display state
 */
-(DZNEmptyMaker *)emptySceneChange:(DZNSceneChangeBlock)block;


/**
 Callback when the empty page lifecycle method changes
 */
-(DZNEmptyMaker *)emptyViewLifeCycle:(DZNEmptyViewLifeCycleBlock)block;


/**
 Callback when tap button or view
 
 @param block block
 */
-(DZNEmptyMaker *)emptyDisplayClick:(DZNTapBlock)block;


@end


//_______________________________________________________________________________________________________________

@interface DZNEmpty : NSObject

@end

NS_ASSUME_NONNULL_END
