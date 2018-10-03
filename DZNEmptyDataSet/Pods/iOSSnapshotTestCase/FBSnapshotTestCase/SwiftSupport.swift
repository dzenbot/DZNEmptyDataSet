/*
 *  Copyright (c) 2017-2018, Uber Technologies, Inc.
 *  Copyright (c) 2015-2018, Facebook, Inc.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

public extension FBSnapshotTestCase {
  public func FBSnapshotVerifyView(_ view: UIView, identifier: String = "", suffixes: NSOrderedSet = FBSnapshotTestCaseDefaultSuffixes(), tolerance: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
    FBSnapshotVerifyViewOrLayer(view, identifier: identifier, suffixes: suffixes, tolerance: tolerance, file: file, line: line)
  }

  public func FBSnapshotVerifyLayer(_ layer: CALayer, identifier: String = "", suffixes: NSOrderedSet = FBSnapshotTestCaseDefaultSuffixes(), tolerance: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
    FBSnapshotVerifyViewOrLayer(layer, identifier: identifier, suffixes: suffixes, tolerance: tolerance, file: file, line: line)
  }

  private func FBSnapshotVerifyViewOrLayer(_ viewOrLayer: AnyObject, identifier: String = "", suffixes: NSOrderedSet = FBSnapshotTestCaseDefaultSuffixes(), tolerance: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
    let envReferenceImageDirectory = self.getReferenceImageDirectory(withDefault: FB_REFERENCE_IMAGE_DIR)
    let envImageDiffDirectory = self.getImageDiffDirectory(withDefault: IMAGE_DIFF_DIR)
    var error: NSError?
    var comparisonSuccess = false

    for suffix in suffixes {
      let referenceImagesDirectory = "\(envReferenceImageDirectory)\(suffix)"
      let imageDiffDirectory = envImageDiffDirectory
      if viewOrLayer.isKind(of: UIView.self) {
        do {
          try compareSnapshot(of: viewOrLayer as! UIView, referenceImagesDirectory: referenceImagesDirectory, imageDiffDirectory: imageDiffDirectory, identifier: identifier, tolerance: tolerance)
          comparisonSuccess = true
        } catch let error1 as NSError {
          error = error1
          comparisonSuccess = false
        }
      } else if viewOrLayer.isKind(of: CALayer.self) {
        do {
          try compareSnapshot(of: viewOrLayer as! CALayer, referenceImagesDirectory: referenceImagesDirectory, imageDiffDirectory: imageDiffDirectory, identifier: identifier, tolerance: tolerance)
          comparisonSuccess = true
        } catch let error1 as NSError {
          error = error1
          comparisonSuccess = false
        }
      } else {
        assertionFailure("Only UIView and CALayer classes can be snapshotted")
      }

      assert(recordMode == false, message: "Test ran in record mode. Reference image is now saved. Disable record mode to perform an actual snapshot comparison!", file: file, line: line)

      if comparisonSuccess || recordMode {
        break
      }

      assert(comparisonSuccess, message: "Snapshot comparison failed: \(String(describing: error))", file: file, line: line)
    }
  }

  func assert(_ assertion: Bool, message: String, file: StaticString, line: UInt) {
    if !assertion {
      XCTFail(message, file: file, line: line)
    }
  }
}
