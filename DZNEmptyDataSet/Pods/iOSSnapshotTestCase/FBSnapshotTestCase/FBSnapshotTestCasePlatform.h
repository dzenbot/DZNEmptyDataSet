/*
 *  Copyright (c) 2017-2018, Uber Technologies, Inc.
 *  Copyright (c) 2015-2018, Facebook, Inc.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 An option mask that allows you to cherry pick which parts you want to 'be agnostic' in the snapshot file name.

 - FBSnapshotTestCaseAgnosticOptionNone: Don't make the file name agnostic at all.
 - FBSnapshotTestCaseAgnosticOptionDevice: The file name should be agnostic on the device name, as returned by UIDevice.currentDevice.model.
 - FBSnapshotTestCaseAgnosticOptionOS: The file name should be agnostic on the OS version, as returned by UIDevice.currentDevice.systemVersion.
 - FBSnapshotTestCaseAgnosticOptionScreenSize: The file name should be agnostic on the screen size of the current keyWindow, as returned by UIApplication.sharedApplication.keyWindow.bounds.size.
 */
typedef NS_OPTIONS(NSUInteger, FBSnapshotTestCaseAgnosticOption) {
    FBSnapshotTestCaseAgnosticOptionNone = 1 << 0,
    FBSnapshotTestCaseAgnosticOptionDevice = 1 << 1,
    FBSnapshotTestCaseAgnosticOptionOS = 1 << 2,
    FBSnapshotTestCaseAgnosticOptionScreenSize = 1 << 3
};

/**
 Returns a Boolean value that indicates whether the snapshot test is running in 64Bit.
 This method is a convenience for creating the suffixes set based on the architecture
 that the test is running.
 
 @returns @c YES if the test is running in 64bit, otherwise @c NO.
 */
BOOL FBSnapshotTestCaseIs64Bit(void);

/**
 Returns a default set of strings that is used to append a suffix based on the architectures.
 @warning Do not modify this function, you can create your own and use it with @c FBSnapshotVerifyViewWithOptions()
 
 @returns An @c NSOrderedSet object containing strings that are appended to the reference images directory.
 */
NSOrderedSet *FBSnapshotTestCaseDefaultSuffixes(void);

/**
 Returns a fully «normalized» file name.
 Strips punctuation and spaces and replaces them with @c _. Also appends the device model, running OS and screen size to the file name.
 
 @returns An @c NSString object containing the passed @c fileName with the device model, OS and screen size appended at the end.
 */
NSString *FBDeviceAgnosticNormalizedFileName(NSString *fileName);

/**
 Returns a fully normalized file name as per the provided option mask. Strips punctuation and spaces and replaces them with @c _.

 @param fileName The file name to normalize.
 @param option Agnostic options to use before normalization.
 @return An @c NSString object containing the passed @c fileName and optionally, with the device model and/or OS and/or screen size appended at the end.
 */
NSString *FBDeviceAgnosticNormalizedFileNameFromOption(NSString *fileName, FBSnapshotTestCaseAgnosticOption option);

NS_ASSUME_NONNULL_END

#ifdef __cplusplus
}
#endif
