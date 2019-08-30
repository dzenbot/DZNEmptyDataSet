iOSSnapshotTestCase (previously named FBSnapshotTestCase)
======================

[![Build Status](https://travis-ci.org/uber/ios-snapshot-test-case.svg)](https://travis-ci.org/uber/ios-snapshot-test-case)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/iOSSnapshotTestCase.svg)](https://img.shields.io/cocoapods/v/iOSSnapshotTestCase.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

What it does
------------

A "snapshot test case" takes a configured `UIView` or `CALayer` and uses the
`renderInContext:` method to get an image snapshot of its contents. It
compares this snapshot to a "reference image" stored in your source code
repository and fails the test if the two images don't match.

Why?
----

We write a lot of UI code. There are a lot of edge
cases that we want to handle correctly when you are creating `UIView` instances:

- What if there is more text than can fit in the space available?
- What if an image doesn't match the size of an image view?
- What should the highlighted state look like?

It's straightforward to test logic code, but less obvious how you should test
views. You can do a lot of rectangle asserts, but these are hard to understand
or visualize. Looking at an image diff shows you exactly what changed and how
it will look to users.

`iOSSnapshotTestCase` was developed to make snapshot tests easy.

Installation with CocoaPods
---------------------------

1. Add the following lines to your Podfile:

     ```ruby
     target "Tests" do
       use_frameworks!
       pod 'iOSSnapshotTestCase'
     end
     ```

   If your test target is Objective-C only use `iOSSnapshotTestCase/Core` instead, which doesn't contain Swift support.

   Replace "Tests" with the name of your test project.

2. There are [three ways](https://github.com/uber/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/FBSnapshotTestCase.h#L19-L29) of setting reference image directories, the recommended one is to define `FB_REFERENCE_IMAGE_DIR` in your scheme. This should point to the directory where you want reference images to be stored. We normally use this:

|Name|Value|
|:---|:----|
|`FB_REFERENCE_IMAGE_DIR`|`$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/ReferenceImages`|
|`IMAGE_DIFF_DIR`|`$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/FailureDiffs`|

Define the `IMAGE_DIFF_DIR` to the directory where you want to store diffs of failed snapshots. There are also [three ways](https://github.com/uber/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/FBSnapshotTestCase.h#L34-L43) to set failed image diff directories.

![](FBSnapshotTestCaseDemo/Scheme_FB_REFERENCE_IMAGE_DIR.png)

Creating a snapshot test
------------------------

1. Subclass `FBSnapshotTestCase` instead of `XCTestCase`.
2. From within your test, use `FBSnapshotVerifyView`.
3. Run the test once with `self.recordMode = YES;` in the test's `-setUp`
   method. (This creates the reference images on disk.)
4. Remove the line enabling record mode and run the test.

Features
--------

- Automatically names reference images on disk according to test class and
  selector.
- Prints a descriptive error message to the console on failure. (Bonus:
  failure message includes a one-line command to see an image diff if
  you have [Kaleidoscope](http://www.kaleidoscopeapp.com) installed.)
- Supply an optional "identifier" if you want to perform multiple snapshots
  in a single test method.
- Support for `CALayer` via `FBSnapshotVerifyLayer`.
- `usesDrawViewHierarchyInRect` to handle cases like `UIVisualEffect`, `UIAppearance` and Size Classes.
- `fileNameOptions` to control appending the device model (`iPhone`, `iPad`, `iPod Touch`, etc), OS version, screen size and screen scale to the images (allowing to have multiple tests for the same «snapshot» for different `OS`s and devices).

Notes
-----

Your unit tests _should_ be inside an "application" bundle, not a "logic/library" test bundle. (That is, it
should be run within the Simulator so that it has access to UIKit.)

In Xcode 5
and later new projects only offer application tests, but older projects will
have separate targets for the two types.

*However*, if you are writing snapshot tests inside a library/framework, you might want to keep your test bundle as a library test bundle without a Test Host.

Read more on this [here](docs/LibraryVsApplicationTestBundles.md).

Authors
-------

`iOSSnapshotTestCase` was written at Facebook by
[Jonathan Dann](https://facebook.com/j.p.dann) with significant contributions by
[Todd Krabach](https://facebook.com/toddkrabach).

Today it is maintained by [Uber](https://github.com/uber).

License
-------

`iOSSnapshotTestCase` is MIT–licensed. See `LICENSE`.
