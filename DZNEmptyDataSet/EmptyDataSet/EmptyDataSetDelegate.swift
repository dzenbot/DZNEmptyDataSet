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

    ///
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool

    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool

    ///
    func emptyDataSetDidUpdateState(_ scrollView: UIScrollView, state: EmptyDataSetState)
}

/// EmptyDataSetDelegate default implementation so all methods are optional
public extension EmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetDidUpdateState(_ scrollView: UIScrollView, state: EmptyDataSetState) {
        
    }
}
