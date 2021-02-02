//
//  EmptyDataSetDelegate.swift
//  EmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 2020-01-01.
//  Copyright © 2020 DZN. All rights reserved.
//

import UIKit

/// The object that acts as the delegate of the empty datasets. Use this delegate for receiving action callbacks.
/// The delegate can adopt the EmptyDataSetDelegate protocol. The delegate is not retained. All delegate methods are optional.
public protocol EmptyDataSetDelegate: class {

    /// Default is true.
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool

    /// Default is false.
    func emptyDataSetShouldForceToDisplay(_ scrollView: UIScrollView) -> Bool

    /// Default is true.
    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool

    /// Default is true.
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool

    /// Default is true.
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool

    ///
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView)

    ///
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton)
}

/// EmptyDataSetDelegate default implementation so all methods are optional
public extension EmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldForceToDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }

    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        // do nothing
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        // do nothing
    }
}
