//
//  EmptyDataSetSource.swift
//  EmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 2020-01-01.
//  Copyright © 2020 DZN. All rights reserved.
//

import UIKit

/// The object that acts as the data source of the empty datasets.
/// The data source must adopt the EmptyDataSetSource protocol. The data source is not retained. All data source methods are optional.
public protocol EmptyDataSetSource: class {

    /// Default is nil.
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    /// Default is nil.
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    /// Default is nil.
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?

    /// Default is nil.
    func imagetintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    /// Default is nil.
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    /// Default is nil.
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString?

    /// Default is nil.
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    /// Default is nil.
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    /// Default is nil.
    func button(forEmptyDataSet scrollView: UIScrollView) -> UIButton?

    /// Default is EmptyDataSetDefaultSpacing.
    func spacing(forEmptyDataSet scrollView: UIScrollView, after emptyDataSetElement: EmptyDataSetElement) -> CGFloat?

    /// Default is nil.
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?
}

/// EmptyDataSetSource default implementation so all methods are optional
public extension EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return nil
    }

    func imagetintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return nil
    }

    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func button(forEmptyDataSet scrollView: UIScrollView) -> UIButton? {
        return nil
    }

    func spacing(forEmptyDataSet scrollView: UIScrollView, after emptyDataSetElement: EmptyDataSetElement) -> CGFloat? {
        return EmptyDataSetDefaultSpacing
    }

    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

