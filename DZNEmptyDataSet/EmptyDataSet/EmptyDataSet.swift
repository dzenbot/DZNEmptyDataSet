//
//  EmptyDataSet.swift
//  DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 2019-12-31.
//  Copyright © 2019 DZN. All rights reserved.
//

import UIKit

public protocol EmptyDataSetInterface {

    /// The empty datasets delegate
    var emptyDataSetSource: EmptyDataSetSource? { get set }

    /// The empty datasets data source
    var emptyDataSetDelegate: EmptyDataSetDelegate? { get set }

    /// Returns true if the Empty Data Set View is visible
    var isEmptyDataSetVisible: Bool { get }

    /// Reloads the empty dataset content receiver.
    /// Call this method to force all the data to refresh. Calling reloadData() is similar, but this method only refreshes the empty dataset,
    /// instead of all the delegate/datasource callbs from your table view or collection view.
    func reloadEmptyDataSet()
}

public protocol EmptyDataSetSource {

    ///
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString?

    ///
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString?

    ///
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage?

    ///
    func tintColorForEmptyDataSet(scrollView: UIScrollView) -> UIColor?

    ///
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView) -> UIColor?
}

public protocol EmptyDataSetDelegate {

    ///
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool

    ///
    func emptyDataSetDidUpdateState(_ scrollView: UIScrollView, state: EmptyDataSetState)
}

public enum EmptyDataSetState {
    case willAppear, didAppear, willDisappear, DidDisappear
}

extension UIScrollView: EmptyDataSetInterface {

    public var emptyDataSetSource: EmptyDataSetSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.datasource) as? EmptyDataSetSource
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.datasource, newValue, .OBJC_ASSOCIATION_ASSIGN)
            swizzleIfNeeded()
        }
    }

    public var emptyDataSetDelegate: EmptyDataSetDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.delegate) as? EmptyDataSetDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.delegate, newValue, .OBJC_ASSOCIATION_ASSIGN)
            swizzleIfNeeded()
        }
    }

    public var isEmptyDataSetVisible: Bool {
        guard let view = emptyDataSetView else { return false }
        return !view.isHidden
    }

    public func reloadEmptyDataSet() {

    }
}
