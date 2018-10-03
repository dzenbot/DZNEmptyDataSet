/*
 *  Copyright (c) 2017-2018, Uber Technologies, Inc.
 *  Copyright (c) 2015-2018, Facebook, Inc.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

#import <FBSnapshotTestCase/FBSnapshotTestCasePlatform.h>
#import <FBSnapshotTestCase/FBSnapshotTestController.h>

#import <QuartzCore/QuartzCore.h>

#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>

/*
 There are three ways of setting reference image directories.

 1. Set the preprocessor macro FB_REFERENCE_IMAGE_DIR to a double quoted
    c-string with the path.
 2. Set an environment variable named FB_REFERENCE_IMAGE_DIR with the path. This
    takes precedence over the preprocessor macro to allow for run-time override.
 3. Keep everything unset, which will cause the reference images to be looked up
    inside the bundle holding the current test, in the
    Resources/ReferenceImages_* directories.
 */
#ifndef FB_REFERENCE_IMAGE_DIR
#define FB_REFERENCE_IMAGE_DIR ""
#endif

/*
 There are three ways of setting failed image diff directories.

 1. Set the preprocessor macro IMAGE_DIFF_DIR to a double quoted
 c-string with the path.
 2. Set an environment variable named IMAGE_DIFF_DIR with the path. This
 takes precedence over the preprocessor macro to allow for run-time override.
 3. Keep everything unset, which will cause the failed image diff images to be saved
 inside a temporary directory.
 */
#ifndef IMAGE_DIFF_DIR
#define IMAGE_DIFF_DIR ""
#endif

/**
 Similar to our much-loved XCTAssert() macros. Use this to perform your test. No need to write an explanation, though.
 @param view The view to snapshot
 @param identifier An optional identifier, used if there are multiple snapshot tests in a given -test method.
 @param suffixes An NSOrderedSet of strings for the different suffixes
 @param tolerance The percentage of pixels that can differ and still count as an 'identical' view
 */
#define FBSnapshotVerifyViewWithOptions(view__, identifier__, suffixes__, tolerance__) \
    FBSnapshotVerifyViewOrLayerWithOptions(View, view__, identifier__, suffixes__, tolerance__)

#define FBSnapshotVerifyView(view__, identifier__) \
    FBSnapshotVerifyViewWithOptions(view__, identifier__, FBSnapshotTestCaseDefaultSuffixes(), 0)


/**
 Similar to our much-loved XCTAssert() macros. Use this to perform your test. No need to write an explanation, though.
 @param layer The layer to snapshot
 @param identifier An optional identifier, used if there are multiple snapshot tests in a given -test method.
 @param suffixes An NSOrderedSet of strings for the different suffixes
 @param tolerance The percentage of pixels that can differ and still count as an 'identical' layer
 */
#define FBSnapshotVerifyLayerWithOptions(layer__, identifier__, suffixes__, tolerance__) \
    FBSnapshotVerifyViewOrLayerWithOptions(Layer, layer__, identifier__, suffixes__, tolerance__)

#define FBSnapshotVerifyLayer(layer__, identifier__) \
    FBSnapshotVerifyLayerWithOptions(layer__, identifier__, FBSnapshotTestCaseDefaultSuffixes(), 0)


#define FBSnapshotVerifyViewOrLayerWithOptions(what__, viewOrLayer__, identifier__, suffixes__, tolerance__)                                                                                                                                           \
    {                                                                                                                                                                                                                                                  \
        NSString *errorDescription = [self snapshotVerifyViewOrLayer:viewOrLayer__ identifier:identifier__ suffixes:suffixes__ tolerance:tolerance__ defaultReferenceDirectory:(@FB_REFERENCE_IMAGE_DIR) defaultImageDiffDirectory:(@IMAGE_DIFF_DIR)]; \
        BOOL noErrors = (errorDescription == nil);                                                                                                                                                                                                     \
        XCTAssertTrue(noErrors, @"%@", errorDescription);                                                                                                                                                                                              \
    }

NS_ASSUME_NONNULL_BEGIN

/**
 The base class of view snapshotting tests. If you have small UI component, it's often easier to configure it in a test
 and compare an image of the view to a reference image that write lots of complex layout-code tests.

 In order to flip the tests in your subclass to record the reference images set @c recordMode to @c YES.

 @attention When recording, the reference image directory should be explicitly
            set, otherwise the images may be written to somewhere inside the
            simulator directory.

 For example:
 @code
 - (void)setUp
 {
    [super setUp];
    self.recordMode = YES;
 }
 @endcode
 */
@interface FBSnapshotTestCase : XCTestCase

/**
 When YES, the test macros will save reference images, rather than performing an actual test.
 */
@property (readwrite, nonatomic, assign) BOOL recordMode;

/**
 When @c YES appends the name of the device model and OS to the snapshot file name.
 The default value is @c NO.
 */
@property (readwrite, nonatomic, assign, getter=isDeviceAgnostic) BOOL deviceAgnostic DEPRECATED_MSG_ATTRIBUTE("Use agnosticOptions instead. deviceAgnostic will be removed in a future version of iOS Snapshot Test Case.");

/**
 When set, allows fine-grained control over how agnostic you want the file names to be.

 Allows you to combine which agnostic options you want in your snapshot file names.

 The default value is FBSnapshotTestCaseAgnosticOptionNone.

 @attention If deviceAgnostic is YES, this bitmask is ignored. deviceAgnostic will be deprecated in a future version of FBSnapshotTestCase.
 */
@property (readwrite, nonatomic, assign) FBSnapshotTestCaseAgnosticOption agnosticOptions;

/**
 Overrides the folder name in which the snapshot is going to be saved.

 @attention This property *must* be called *AFTER* [super setUp].
 */
@property (readwrite, nonatomic, copy, nullable) NSString *folderName;

/**
 When YES, renders a snapshot of the complete view hierarchy as visible onscreen.
 There are several things that do not work if renderInContext: is used.
 - UIVisualEffect #70
 - UIAppearance #91
 - Size Classes #92

 @attention If the view does't belong to a UIWindow, it will create one and add the view as a subview.
 */
@property (readwrite, nonatomic, assign) BOOL usesDrawViewHierarchyInRect;

- (void)setUp NS_REQUIRES_SUPER;
- (void)tearDown NS_REQUIRES_SUPER;

/**
 Performs the comparison or records a snapshot of the layer if recordMode is YES.
 @param viewOrLayer The UIView or CALayer to snapshot
 @param identifier An optional identifier, used if there are multiple snapshot tests in a given -test method.
 @param suffixes An NSOrderedSet of strings for the different suffixes
 @param tolerance The percentage difference to still count as identical - 0 mean pixel perfect, 1 means I don't care
 @param defaultReferenceDirectory The directory to default to for reference images.
 @param defaultImageDiffDirectory The directory to default to for failed image diffs.
 @returns nil if the comparison (or saving of the reference image) succeeded. Otherwise it contains an error description.
 */
- (nullable NSString *)snapshotVerifyViewOrLayer:(id)viewOrLayer
                                      identifier:(nullable NSString *)identifier
                                        suffixes:(NSOrderedSet *)suffixes
                                       tolerance:(CGFloat)tolerance
                       defaultReferenceDirectory:(nullable NSString *)defaultReferenceDirectory
                       defaultImageDiffDirectory:(nullable NSString *)defaultImageDiffDirectory;

/**
 Performs the comparison or records a snapshot of the layer if recordMode is YES.
 @param layer The Layer to snapshot
 @param referenceImagesDirectory The directory in which reference images are stored.
 @param imageDiffDirectory The directory in which failed image diffs are stored.
 @param identifier An optional identifier, used if there are multiple snapshot tests in a given -test method.
 @param tolerance The percentage difference to still count as identical - 0 mean pixel perfect, 1 means I don't care
 @param errorPtr An error to log in an XCTAssert() macro if the method fails (missing reference image, images differ, etc).
 @returns YES if the comparison (or saving of the reference image) succeeded.
 */
- (BOOL)compareSnapshotOfLayer:(CALayer *)layer
      referenceImagesDirectory:(NSString *)referenceImagesDirectory
            imageDiffDirectory:(NSString *)imageDiffDirectory
                    identifier:(nullable NSString *)identifier
                     tolerance:(CGFloat)tolerance
                         error:(NSError **)errorPtr;

/**
 Performs the comparison or records a snapshot of the view if recordMode is YES.
 @param view The view to snapshot
 @param referenceImagesDirectory The directory in which reference images are stored.
 @param imageDiffDirectory The directory in which failed image diffs are stored.
 @param identifier An optional identifier, used if there are multiple snapshot tests in a given -test method.
 @param tolerance The percentage difference to still count as identical - 0 mean pixel perfect, 1 means I don't care
 @param errorPtr An error to log in an XCTAssert() macro if the method fails (missing reference image, images differ, etc).
 @returns YES if the comparison (or saving of the reference image) succeeded.
 */
- (BOOL)compareSnapshotOfView:(UIView *)view
     referenceImagesDirectory:(NSString *)referenceImagesDirectory
           imageDiffDirectory:(NSString *)imageDiffDirectory
                   identifier:(nullable NSString *)identifier
                    tolerance:(CGFloat)tolerance
                        error:(NSError **)errorPtr;

/**
 Checks if reference image with identifier based name exists in the reference images directory.
 @param referenceImagesDirectory The directory in which reference images are stored.
 @param identifier An optional identifier, used if there are multiple snapshot tests in a given -test method.
 @param errorPtr An error to log in an XCTAssert() macro if the method fails (missing reference image, images differ, etc).
 @returns YES if reference image exists.
 */
- (BOOL)referenceImageRecordedInDirectory:(NSString *)referenceImagesDirectory
                               identifier:(nullable NSString *)identifier
                                    error:(NSError **)errorPtr;

/**
 Returns the reference image directory.

 Helper function used to implement the assert macros.

 @param dir Directory to use if environment variable not specified. Ignored if null or empty.
 */
- (NSString *)getReferenceImageDirectoryWithDefault:(nullable NSString *)dir;

/**
 Returns the failed image diff directory.

 Helper function used to implement the assert macros.

 @param dir Directory to use if environment variable not specified. Ignored if null or empty.
 */
- (NSString *)getImageDiffDirectoryWithDefault:(nullable NSString *)dir;

@end

NS_ASSUME_NONNULL_END
