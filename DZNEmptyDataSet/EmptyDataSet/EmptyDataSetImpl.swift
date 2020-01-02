//
//  EmptyDataSetImpl.swift
//  EmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 2019-12-31.
//  Copyright © 2019 DZN. All rights reserved.
//

import UIKit

protocol EmptyDataSetProtocol {
    func swizzle() -> Bool
    func isEmpty() -> Bool
}

internal extension UIScrollView  {

    // MARK: - Layout

    func layoutEmptyDataSetIfNeeded() {
        guard let view = self.emptyDataSetView else { return }

        if let source = emptyDataSetSource {
            view.titleLabel.attributedText = source.title(forEmptyDataSet: self)
            view.descriptionLabel.attributedText = source.description(forEmptyDataSet: self)
            view.imageView.image = source.image(forEmptyDataSet: self)
            view.backgroundColor = source.backgroundColor(forEmptyDataSet: self)

            view.verticalSpacing = [EmptyDataSetElement: CGFloat]()
            EmptyDataSetElement.allCases.forEach {
                view.verticalSpacing?[$0] = source.spacing(forEmptyDataSet: self, after: $0)
            }
        }

        if let delegate = emptyDataSetDelegate {
            view.fadeInOnDisplay = delegate.emptyDataSetShouldFadeIn(self)
            view.isUserInteractionEnabled = delegate.emptyDataSetShouldAllowTouch(self)

            // TODO: Cache previous scroll state
            isScrollEnabled = delegate.emptyDataSetShouldAllowScroll(self)
        }

        view.setupLayout()
        
        addSubview(view)
    }

    var emptyDataSetView: EmptyDataSetView? {
        var view = objc_getAssociatedObject(self, &AssociatedKeys.view) as? EmptyDataSetView

        if view == nil {
            view = EmptyDataSetView()

            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapContentView(_:)))
            view?.addGestureRecognizer(tapGesture)

            objc_setAssociatedObject(self, &AssociatedKeys.view, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        return view
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
            didSwizzle = proxy.swizzle()
        } else {
            print("\(type(of: self)) should conform to protocol EmptyDataset")
        }
    }

    fileprivate func swizzle(originalSelector: Selector, swizzledSelector: Selector) -> Bool {
        guard responds(to: originalSelector) else { return false }

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

    // MARK: - Gestures

    @objc private func didTapContentView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        emptyDataSetDelegate?.emptyDataSet(self, didTapView: view)
    }
}

// MARK: - UITableView + EmptyDataSetProtocol

extension UITableView: EmptyDataSetProtocol {

    func swizzle() -> Bool {
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
        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc func endUpdates_swizzled() {
        // Calls the original implementation
        endUpdates_swizzled()
        reloadEmptyDataSet()
    }
}

// MARK: - UICollectionView + EmptyDataSetProtocol

extension UICollectionView: EmptyDataSetProtocol {

    func swizzle() -> Bool {
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
        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc func performBatchUpdates_swizzled() {
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
