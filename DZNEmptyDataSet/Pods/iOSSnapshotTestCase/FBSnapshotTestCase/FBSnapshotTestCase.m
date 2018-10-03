/*
 *  Copyright (c) 2017-2018, Uber Technologies, Inc.
 *  Copyright (c) 2015-2018, Facebook, Inc.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <FBSnapshotTestCase/FBSnapshotTestController.h>

@implementation FBSnapshotTestCase {
    FBSnapshotTestController *_snapshotController;
}

#pragma mark - Overrides

- (void)setUp
{
    [super setUp];
    _snapshotController = [[FBSnapshotTestController alloc] initWithTestClass:[self class]];
}

- (void)tearDown
{
    _snapshotController = nil;
    [super tearDown];
}

- (BOOL)recordMode
{
    return _snapshotController.recordMode;
}

- (void)setRecordMode:(BOOL)recordMode
{
    NSAssert1(_snapshotController, @"%s cannot be called before [super setUp]", __FUNCTION__);
    _snapshotController.recordMode = recordMode;
}

- (BOOL)isDeviceAgnostic
{
    return _snapshotController.deviceAgnostic;
}

- (void)setDeviceAgnostic:(BOOL)deviceAgnostic
{
    NSAssert1(_snapshotController, @"%s cannot be called before [super setUp]", __FUNCTION__);
    _snapshotController.deviceAgnostic = deviceAgnostic;
}

- (FBSnapshotTestCaseAgnosticOption)agnosticOptions
{
    return _snapshotController.agnosticOptions;
}

- (void)setAgnosticOptions:(FBSnapshotTestCaseAgnosticOption)agnosticOptions
{
    NSAssert1(_snapshotController, @"%s cannot be called before [super setUp]", __FUNCTION__);
    _snapshotController.agnosticOptions = agnosticOptions;
}

- (BOOL)usesDrawViewHierarchyInRect
{
    return _snapshotController.usesDrawViewHierarchyInRect;
}

- (void)setUsesDrawViewHierarchyInRect:(BOOL)usesDrawViewHierarchyInRect
{
    NSAssert1(_snapshotController, @"%s cannot be called before [super setUp]", __FUNCTION__);
    _snapshotController.usesDrawViewHierarchyInRect = usesDrawViewHierarchyInRect;
}

- (NSString *)folderName
{
    return _snapshotController.folderName;
}

- (void)setFolderName:(NSString *)folderName
{
    _snapshotController.folderName = folderName;
}

#pragma mark - Public API

- (NSString *)snapshotVerifyViewOrLayer:(id)viewOrLayer
                             identifier:(NSString *)identifier
                               suffixes:(NSOrderedSet *)suffixes
                              tolerance:(CGFloat)tolerance
              defaultReferenceDirectory:(NSString *)defaultReferenceDirectory
              defaultImageDiffDirectory:(NSString *)defaultImageDiffDirectory
{
    if (nil == viewOrLayer) {
        return @"Object to be snapshotted must not be nil";
    }

    NSString *referenceImageDirectory = [self getReferenceImageDirectoryWithDefault:defaultReferenceDirectory];
    if (referenceImageDirectory == nil) {
        return @"Missing value for referenceImagesDirectory - Set FB_REFERENCE_IMAGE_DIR as an Environment variable in your scheme.";
    }

    NSString *imageDiffDirectory = [self getImageDiffDirectoryWithDefault:defaultImageDiffDirectory];
    if (imageDiffDirectory == nil) {
        return @"Missing value for imageDiffDirectory - Set IMAGE_DIFF_DIR as an Environment variable in your scheme.";
    }

    if (suffixes.count == 0) {
        return [NSString stringWithFormat:@"Suffixes set cannot be empty %@", suffixes];
    }

    BOOL testSuccess = NO;
    NSError *error = nil;
    NSMutableArray *errors = [NSMutableArray array];

    if (self.recordMode) {
        NSString *referenceImagesDirectory = [NSString stringWithFormat:@"%@%@", referenceImageDirectory, suffixes.firstObject];
        BOOL referenceImageSaved = [self _compareSnapshotOfViewOrLayer:viewOrLayer referenceImagesDirectory:referenceImagesDirectory imageDiffDirectory:imageDiffDirectory identifier:(identifier) tolerance:tolerance error:&error];
        if (!referenceImageSaved) {
            [errors addObject:error];
        }
    } else {
        for (NSString *suffix in suffixes) {
            NSString *referenceImagesDirectory = [NSString stringWithFormat:@"%@%@", referenceImageDirectory, suffix];
            BOOL referenceImageAvailable = [self referenceImageRecordedInDirectory:referenceImagesDirectory identifier:(identifier) error:&error];

            if (referenceImageAvailable) {
                BOOL comparisonSuccess = [self _compareSnapshotOfViewOrLayer:viewOrLayer referenceImagesDirectory:referenceImagesDirectory imageDiffDirectory:imageDiffDirectory identifier:identifier tolerance:tolerance error:&error];
                [errors removeAllObjects];
                if (comparisonSuccess) {
                    testSuccess = YES;
                    break;
                } else {
                    [errors addObject:error];
                }
            } else {
                [errors addObject:error];
            }
        }
    }

    if (!testSuccess) {
        return [NSString stringWithFormat:@"Snapshot comparison failed: %@", errors.firstObject];
    }
    if (self.recordMode) {
        return @"Test ran in record mode. Reference image is now saved. Disable record mode to perform an actual snapshot comparison!";
    }

    return nil;
}

- (BOOL)compareSnapshotOfLayer:(CALayer *)layer
      referenceImagesDirectory:(NSString *)referenceImagesDirectory
            imageDiffDirectory:(NSString *)imageDiffDirectory
                    identifier:(NSString *)identifier
                     tolerance:(CGFloat)tolerance
                         error:(NSError **)errorPtr
{
    return [self _compareSnapshotOfViewOrLayer:layer
                      referenceImagesDirectory:referenceImagesDirectory
                            imageDiffDirectory:imageDiffDirectory
                                    identifier:identifier
                                     tolerance:tolerance
                                         error:errorPtr];
}

- (BOOL)compareSnapshotOfView:(UIView *)view
     referenceImagesDirectory:(NSString *)referenceImagesDirectory
           imageDiffDirectory:(NSString *)imageDiffDirectory
                   identifier:(NSString *)identifier
                    tolerance:(CGFloat)tolerance
                        error:(NSError **)errorPtr
{
    return [self _compareSnapshotOfViewOrLayer:view
                      referenceImagesDirectory:referenceImagesDirectory
                            imageDiffDirectory:imageDiffDirectory
                                    identifier:identifier
                                     tolerance:tolerance
                                         error:errorPtr];
}

- (BOOL)referenceImageRecordedInDirectory:(NSString *)referenceImagesDirectory
                               identifier:(NSString *)identifier
                                    error:(NSError **)errorPtr
{
    NSAssert1(_snapshotController, @"%s cannot be called before [super setUp]", __FUNCTION__);
    _snapshotController.referenceImagesDirectory = referenceImagesDirectory;
    UIImage *referenceImage = [_snapshotController referenceImageForSelector:self.invocation.selector
                                                                  identifier:identifier
                                                                       error:errorPtr];

    return (referenceImage != nil);
}

- (NSString *)getReferenceImageDirectoryWithDefault:(NSString *)dir
{
    NSString *envReferenceImageDirectory = [NSProcessInfo processInfo].environment[@"FB_REFERENCE_IMAGE_DIR"];
    if (envReferenceImageDirectory) {
        return envReferenceImageDirectory;
    }
    if (dir && dir.length > 0) {
        return dir;
    }
    return [[NSBundle bundleForClass:self.class].resourcePath stringByAppendingPathComponent:@"ReferenceImages"];
}

- (NSString *)getImageDiffDirectoryWithDefault:(NSString *)dir
{
    NSString *envImageDiffDirectory = [NSProcessInfo processInfo].environment[@"IMAGE_DIFF_DIR"];
    if (envImageDiffDirectory) {
        return envImageDiffDirectory;
    }
    if (dir && dir.length > 0) {
        return dir;
    }
    return NSTemporaryDirectory();
}

#pragma mark - Private API

- (BOOL)_compareSnapshotOfViewOrLayer:(id)viewOrLayer
             referenceImagesDirectory:(NSString *)referenceImagesDirectory
                   imageDiffDirectory:(NSString *)imageDiffDirectory
                           identifier:(NSString *)identifier
                            tolerance:(CGFloat)tolerance
                                error:(NSError **)errorPtr
{
    _snapshotController.referenceImagesDirectory = referenceImagesDirectory;
    _snapshotController.imageDiffDirectory = imageDiffDirectory;
    return [_snapshotController compareSnapshotOfViewOrLayer:viewOrLayer
                                                    selector:self.invocation.selector
                                                  identifier:identifier
                                                   tolerance:tolerance
                                                       error:errorPtr];
}

@end
