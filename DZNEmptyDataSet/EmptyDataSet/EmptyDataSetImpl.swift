//
//  EmptyDataSetImpl.swift
//  EmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 2019-12-31.
//  Copyright © 2019 DZN. All rights reserved.
//

import UIKit

protocol EmptyDataSetProtocol {
    func doSwizzle() -> Bool
    func isEmpty() -> Bool
    func reloadDataEmptyDataSet()
}

extension UIScrollView  {

    var emptyDataSetView: EmptyDataSetView? {
        return nil
    }

    // MARK: - Swizzling

    var didSwizzle: Bool {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.didSwizzle) as? NSNumber
            return value?.boolValue ?? false // Returns false if the boolValue is nil.
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.didSwizzle, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func swizzleIfNeeded() {
        guard !didSwizzle else { return }

        if let proxy = self as? EmptyDataSetProtocol {
            didSwizzle = proxy.doSwizzle()
        } else {
            print("\(type(of: self)) should conform to protocol EmptyDataset")
        }
    }

    fileprivate func swizzle(originalSelector: Selector, swizzledSelector: Selector) -> Bool {
        guard self.responds(to: originalSelector) else { return false }

        guard let originalMethod = class_getInstanceMethod(type(of: self), originalSelector),
            let swizzledMethod = class_getInstanceMethod(type(of: self), swizzledSelector) else { return false }

        let targetedMethod = class_addMethod(type(of: self), originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if targetedMethod {
            class_replaceMethod(type(of: self), swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            return true
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
            return true
        }
    }
}

extension UITableView: EmptyDataSetProtocol {

    func doSwizzle() -> Bool {
        var didSwizzle = false

        let newReloadDataSelector = #selector(reloadDataEmptyDataSet)
        let originalReloadDataSelector = #selector(UITableView.reloadData)
        didSwizzle = swizzle(originalSelector: originalReloadDataSelector, swizzledSelector: newReloadDataSelector)

        let newEndUpdatesSelector = #selector(endUpdatesEmptyDataSet)
        let originalEndUpdatesSelector = #selector(UITableView.endUpdates)
        didSwizzle = didSwizzle &&
            swizzle(originalSelector: originalEndUpdatesSelector, swizzledSelector: newEndUpdatesSelector)

        return didSwizzle
    }

    func isEmpty() -> Bool {
        var items: Int = 0
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            guard let item: Int = dataSource?.tableView(self, numberOfRowsInSection: i) else { continue }
            items += item
        }
        return items == 0
    }

    @objc func reloadDataEmptyDataSet() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        self.reloadDataEmptyDataSet()
        reloadEmptyDataSet()
    }

    @objc func endUpdatesEmptyDataSet() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        self.endUpdatesEmptyDataSet()
        reloadEmptyDataSet()
    }
}

extension UICollectionView: EmptyDataSetProtocol {

    func doSwizzle() -> Bool {
        var didSwizzle = false

        let newReloadDataSelector = #selector(reloadDataEmptyDataSet)
        let originalReloadDataSelector = #selector(UICollectionView.reloadData)
        didSwizzle = swizzle(originalSelector: originalReloadDataSelector, swizzledSelector: newReloadDataSelector)

        let newEndUpdatesSelector = #selector(performBatchUpdatesEmptyDataSet)
        let originalEndUpdatesSelector = #selector(UICollectionView.performBatchUpdates(_:completion:))
        didSwizzle = didSwizzle &&
            swizzle(originalSelector: originalEndUpdatesSelector, swizzledSelector: newEndUpdatesSelector)

        return didSwizzle
    }

    func isEmpty() -> Bool {
        var items: Int = 0
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            guard let item: Int = dataSource?.collectionView(self, numberOfItemsInSection: i) else { continue }
            items += item
        }
        return items == 0
    }

    @objc func reloadDataEmptyDataSet() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        self.reloadDataEmptyDataSet()
        reloadEmptyDataSet()
    }

    @objc func performBatchUpdatesEmptyDataSet() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        self.performBatchUpdatesEmptyDataSet()
        reloadEmptyDataSet()
    }
}

struct AssociatedKeys {
    static var datasource = "emptyDataSetSource"
    static var delegate = "emptyDataSetDelegate"
    static var contentView = "emptyDataSetView"
    static var didSwizzle = "didSwizzle"
}
