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

    ///
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    ///
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    ///
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?

    ///
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    ///
    func imagetintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    ///
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> UIColor?

    ///
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?
}

/// EmptyDataSetSource default implementation so most methods are optional

public extension EmptyDataSetSource {

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return nil
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func imagetintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

