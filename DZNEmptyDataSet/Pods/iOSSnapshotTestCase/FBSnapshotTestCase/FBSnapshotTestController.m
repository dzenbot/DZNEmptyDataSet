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
#import <FBSnapshotTestCase/UIImage+Compare.h>
#import <FBSnapshotTestCase/UIImage+Diff.h>
#import <FBSnapshotTestCase/UIImage+Snapshot.h>

#import <UIKit/UIKit.h>

NSString *const FBSnapshotTestControllerErrorDomain = @"FBSnapshotTestControllerErrorDomain";
NSString *const FBReferenceImageFilePathKey = @"FBReferenceImageFilePathKey";
NSString *const FBReferenceImageKey = @"FBReferenceImageKey";
NSString *const FBCapturedImageKey = @"FBCapturedImageKey";
NSString *const FBDiffedImageKey = @"FBDiffedImageKey";

typedef NS_ENUM(NSUInteger, FBTestSnapshotFileNameType) {
    FBTestSnapshotFileNameTypeReference,
    FBTestSnapshotFileNameTypeFailedReference,
    FBTestSnapshotFileNameTypeFailedTest,
    FBTestSnapshotFileNameTypeFailedTestDiff,
};

@implementation FBSnapshotTestController {
    NSFileManager *_fileManager;
}

#pragma mark - Initializers

- (instancetype)initWithTestClass:(Class)testClass;
{
    if (self = [super init]) {
        _folderName = NSStringFromClass(testClass);
        _deviceAgnostic = NO;
        _agnosticOptions = FBSnapshotTestCaseAgnosticOptionNone;

        _fileManager = [[NSFileManager alloc] init];
    }
    return self;
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], _referenceImagesDirectory];
}

#pragma mark - Public API

- (BOOL)compareSnapshotOfLayer:(CALayer *)layer
                      selector:(SEL)selector
                    identifier:(NSString *)identifier
                         error:(NSError **)errorPtr
{
    return [self compareSnapshotOfViewOrLayer:layer
                                     selector:selector
                                   identifier:identifier
                                    tolerance:0
                                        error:errorPtr];
}

- (BOOL)compareSnapshotOfView:(UIView *)view
                     selector:(SEL)selector
                   identifier:(NSString *)identifier
                        error:(NSError **)errorPtr
{
    return [self compareSnapshotOfViewOrLayer:view
                                     selector:selector
                                   identifier:identifier
                                    tolerance:0
                                        error:errorPtr];
}

- (BOOL)compareSnapshotOfViewOrLayer:(id)viewOrLayer
                            selector:(SEL)selector
                          identifier:(NSString *)identifier
                           tolerance:(CGFloat)tolerance
                               error:(NSError **)errorPtr
{
    if (self.recordMode) {
        return [self _recordSnapshotOfViewOrLayer:viewOrLayer selector:selector identifier:identifier error:errorPtr];
    } else {
        return [self _performPixelComparisonWithViewOrLayer:viewOrLayer selector:selector identifier:identifier tolerance:tolerance error:errorPtr];
    }
}

- (UIImage *)referenceImageForSelector:(SEL)selector
                            identifier:(NSString *)identifier
                                 error:(NSError **)errorPtr
{
    NSString *filePath = [self _referenceFilePathForSelector:selector identifier:identifier];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (nil == image && NULL != errorPtr) {
        BOOL exists = [_fileManager fileExistsAtPath:filePath];
        if (!exists) {
            *errorPtr = [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain
                                            code:FBSnapshotTestControllerErrorCodeNeedsRecord
                                        userInfo:@{
                                            FBReferenceImageFilePathKey : filePath,
                                            NSLocalizedDescriptionKey : @"Unable to load reference image.",
                                            NSLocalizedFailureReasonErrorKey : @"Reference image not found. You need to run the test in record mode",
                                        }];
        } else {
            *errorPtr = [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain
                                            code:FBSnapshotTestControllerErrorCodeUnknown
                                        userInfo:nil];
        }
    }
    return image;
}

- (BOOL)compareReferenceImage:(UIImage *)referenceImage
                      toImage:(UIImage *)image
                    tolerance:(CGFloat)tolerance
                        error:(NSError **)errorPtr
{
    BOOL sameImageDimensions = CGSizeEqualToSize(referenceImage.size, image.size);
    if (sameImageDimensions && [referenceImage fb_compareWithImage:image tolerance:tolerance]) {
        return YES;
    }

    if (NULL != errorPtr) {
        NSString *errorDescription = sameImageDimensions ? @"Images different" : @"Images different sizes";
        NSString *errorReason = sameImageDimensions ? [NSString stringWithFormat:@"image pixels differed by more than %.2f%% from the reference image", tolerance * 100] : [NSString stringWithFormat:@"referenceImage:%@, image:%@", NSStringFromCGSize(referenceImage.size), NSStringFromCGSize(image.size)];
        FBSnapshotTestControllerErrorCode errorCode = sameImageDimensions ? FBSnapshotTestControllerErrorCodeImagesDifferent : FBSnapshotTestControllerErrorCodeImagesDifferentSizes;

        *errorPtr = [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain
                                        code:errorCode
                                    userInfo:@{
                                        NSLocalizedDescriptionKey : errorDescription,
                                        NSLocalizedFailureReasonErrorKey : errorReason,
                                        FBReferenceImageKey : referenceImage,
                                        FBCapturedImageKey : image,
                                        FBDiffedImageKey : [referenceImage fb_diffWithImage:image],
                                    }];
    }
    return NO;
}

- (BOOL)saveFailedReferenceImage:(UIImage *)referenceImage
                       testImage:(UIImage *)testImage
                        selector:(SEL)selector
                      identifier:(NSString *)identifier
                           error:(NSError **)errorPtr
{
    NSData *referencePNGData = UIImagePNGRepresentation(referenceImage);
    NSData *testPNGData = UIImagePNGRepresentation(testImage);

    NSString *referencePath = [self _failedFilePathForSelector:selector
                                                    identifier:identifier
                                                  fileNameType:FBTestSnapshotFileNameTypeFailedReference];

    NSError *creationError = nil;
    BOOL didCreateDir = [_fileManager createDirectoryAtPath:[referencePath stringByDeletingLastPathComponent]
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:&creationError];
    if (!didCreateDir) {
        if (NULL != errorPtr) {
            *errorPtr = creationError;
        }
        return NO;
    }

    if (![referencePNGData writeToFile:referencePath options:NSDataWritingAtomic error:errorPtr]) {
        return NO;
    }

    NSString *testPath = [self _failedFilePathForSelector:selector
                                               identifier:identifier
                                             fileNameType:FBTestSnapshotFileNameTypeFailedTest];

    if (![testPNGData writeToFile:testPath options:NSDataWritingAtomic error:errorPtr]) {
        return NO;
    }

    NSString *diffPath = [self _failedFilePathForSelector:selector
                                               identifier:identifier
                                             fileNameType:FBTestSnapshotFileNameTypeFailedTestDiff];

    UIImage *diffImage = [referenceImage fb_diffWithImage:testImage];
    NSData *diffImageData = UIImagePNGRepresentation(diffImage);

    if (![diffImageData writeToFile:diffPath options:NSDataWritingAtomic error:errorPtr]) {
        return NO;
    }

    NSLog(@"If you have Kaleidoscope installed you can run this command to see an image diff:\n"
          @"ksdiff \"%@\" \"%@\"",
          referencePath, testPath);

    return YES;
}

#pragma mark - Private API

- (NSString *)_fileNameForSelector:(SEL)selector
                        identifier:(NSString *)identifier
                      fileNameType:(FBTestSnapshotFileNameType)fileNameType
{
    NSString *fileName = nil;
    switch (fileNameType) {
        case FBTestSnapshotFileNameTypeFailedReference:
            fileName = @"reference_";
            break;
        case FBTestSnapshotFileNameTypeFailedTest:
            fileName = @"failed_";
            break;
        case FBTestSnapshotFileNameTypeFailedTestDiff:
            fileName = @"diff_";
            break;
        default:
            fileName = @"";
            break;
    }
    fileName = [fileName stringByAppendingString:NSStringFromSelector(selector)];
    if (0 < identifier.length) {
        fileName = [fileName stringByAppendingFormat:@"_%@", identifier];
    }

    BOOL noAgnosticOption = (self.agnosticOptions & FBSnapshotTestCaseAgnosticOptionNone) == FBSnapshotTestCaseAgnosticOptionNone;
    if (self.isDeviceAgnostic) {
        fileName = FBDeviceAgnosticNormalizedFileName(fileName);
    } else if (!noAgnosticOption) {
        fileName = FBDeviceAgnosticNormalizedFileNameFromOption(fileName, self.agnosticOptions);
    }

    if ([[UIScreen mainScreen] scale] > 1) {
        fileName = [fileName stringByAppendingFormat:@"@%.fx", [[UIScreen mainScreen] scale]];
    }
    fileName = [fileName stringByAppendingPathExtension:@"png"];
    return fileName;
}

- (NSString *)_referenceFilePathForSelector:(SEL)selector
                                 identifier:(NSString *)identifier
{
    NSString *fileName = [self _fileNameForSelector:selector
                                         identifier:identifier
                                       fileNameType:FBTestSnapshotFileNameTypeReference];
    NSString *filePath = [_referenceImagesDirectory stringByAppendingPathComponent:self.folderName];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

- (NSString *)_failedFilePathForSelector:(SEL)selector
                              identifier:(NSString *)identifier
                            fileNameType:(FBTestSnapshotFileNameType)fileNameType
{
    NSString *fileName = [self _fileNameForSelector:selector
                                         identifier:identifier
                                       fileNameType:fileNameType];

    NSString *filePath = [_imageDiffDirectory stringByAppendingPathComponent:self.folderName];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

- (BOOL)_performPixelComparisonWithViewOrLayer:(id)viewOrLayer
                                      selector:(SEL)selector
                                    identifier:(NSString *)identifier
                                     tolerance:(CGFloat)tolerance
                                         error:(NSError **)errorPtr
{
    UIImage *referenceImage = [self referenceImageForSelector:selector identifier:identifier error:errorPtr];
    if (nil != referenceImage) {
        UIImage *snapshot = [self _imageForViewOrLayer:viewOrLayer];
        BOOL imagesSame = [self compareReferenceImage:referenceImage toImage:snapshot tolerance:tolerance error:errorPtr];
        if (!imagesSame) {
            NSError *saveError = nil;
            if ([self saveFailedReferenceImage:referenceImage testImage:snapshot selector:selector identifier:identifier error:&saveError] == NO) {
                NSLog(@"Error saving test images: %@", saveError);
            }
        }
        return imagesSame;
    }
    return NO;
}

- (BOOL)_recordSnapshotOfViewOrLayer:(id)viewOrLayer
                            selector:(SEL)selector
                          identifier:(NSString *)identifier
                               error:(NSError **)errorPtr
{
    UIImage *snapshot = [self _imageForViewOrLayer:viewOrLayer];
    return [self _saveReferenceImage:snapshot selector:selector identifier:identifier error:errorPtr];
}

- (BOOL)_saveReferenceImage:(UIImage *)image
                   selector:(SEL)selector
                 identifier:(NSString *)identifier
                      error:(NSError **)errorPtr
{
    BOOL didWrite = NO;
    if (nil != image) {
        NSString *filePath = [self _referenceFilePathForSelector:selector identifier:identifier];
        NSData *pngData = UIImagePNGRepresentation(image);
        if (nil != pngData) {
            NSError *creationError = nil;
            BOOL didCreateDir = [_fileManager createDirectoryAtPath:[filePath stringByDeletingLastPathComponent]
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:&creationError];
            if (!didCreateDir) {
                if (NULL != errorPtr) {
                    *errorPtr = creationError;
                }
                return NO;
            }
            didWrite = [pngData writeToFile:filePath options:NSDataWritingAtomic error:errorPtr];
            if (didWrite) {
                NSLog(@"Reference image save at: %@", filePath);
            }
        } else {
            if (nil != errorPtr) {
                *errorPtr = [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain
                                                code:FBSnapshotTestControllerErrorCodePNGCreationFailed
                                            userInfo:@{
                                                FBReferenceImageFilePathKey : filePath,
                                            }];
            }
        }
    }
    return didWrite;
}

- (UIImage *)_imageForViewOrLayer:(id)viewOrLayer
{
    if ([viewOrLayer isKindOfClass:[UIView class]]) {
        if (_usesDrawViewHierarchyInRect) {
            return [UIImage fb_imageForView:viewOrLayer];
        } else {
            return [UIImage fb_imageForViewLayer:viewOrLayer];
        }
    } else if ([viewOrLayer isKindOfClass:[CALayer class]]) {
        return [UIImage fb_imageForLayer:viewOrLayer];
    } else {
        [NSException raise:@"Only UIView and CALayer classes can be snapshotted" format:@"%@", viewOrLayer];
    }
    return nil;
}

@end
