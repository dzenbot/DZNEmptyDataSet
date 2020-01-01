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

// MARK: - UITableView + EmptyDataSetProtocol

extension UITableView: EmptyDataSetProtocol {

    func doSwizzle() -> Bool {
        var didSwizzle = false

        let newReloadDataSelector = #selector(reloadData_swizzled)
        let originalReloadDataSelector = #selector(UITableView.reloadData)
        didSwizzle = swizzle(originalSelector: originalReloadDataSelector, swizzledSelector: newReloadDataSelector)

        let newEndUpdatesSelector = #selector(endUpdates_swizzled)
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

    @objc func reloadData_swizzled() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc func endUpdates_swizzled() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        endUpdates_swizzled()
        reloadEmptyDataSet()
    }
}

// MARK: - UICollectionView + EmptyDataSetProtocol

extension UICollectionView: EmptyDataSetProtocol {

    func doSwizzle() -> Bool {
        var didSwizzle = false

        let newReloadDataSelector = #selector(reloadData_swizzled)
        let originalReloadDataSelector = #selector(UICollectionView.reloadData)
        didSwizzle = swizzle(originalSelector: originalReloadDataSelector, swizzledSelector: newReloadDataSelector)

        let newEndUpdatesSelector = #selector(performBatchUpdates_swizzled)
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

    @objc func reloadData_swizzled() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc func performBatchUpdates_swizzled() {
        print("\(type(of: self)).\(#function)")

        // Calls the original implementation
        performBatchUpdates_swizzled()
        reloadEmptyDataSet()
    }
}

// MARK: - Swizzling Associated Keys

struct AssociatedKeys {
    static var datasource = "emptyDataSetSource"
    static var delegate = "emptyDataSetDelegate"
    static var view = "emptyDataSetView"
    static var didSwizzle = "didSwizzle"
}
