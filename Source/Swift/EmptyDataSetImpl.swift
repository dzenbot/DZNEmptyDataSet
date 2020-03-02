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

    // MARK: - Setter / Getter

    func getEmptyDataSetSource() -> EmptyDataSetSource? {
        let reference = objc_getAssociatedObject(self, &AssociatedKeys.datasource) as? WeakReference
        return reference?.object as? EmptyDataSetSource
    }

    func setEmptyDataSetSource(_ datasource: EmptyDataSetSource?) {
        if datasource == nil {
            objc_setAssociatedObject(self, &AssociatedKeys.datasource, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            invalidate()
        } else {
            objc_setAssociatedObject(self, &AssociatedKeys.datasource, WeakReference(with: datasource), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            swizzleIfNeeded()
        }
    }

    func getEmptyDataSetDelegate() -> EmptyDataSetDelegate? {
        let reference = objc_getAssociatedObject(self, &AssociatedKeys.delegate) as? WeakReference
        return reference?.object as? EmptyDataSetDelegate
    }

    func setEmptyDataSetDelegate(_ delegate: Any?) {
        if delegate == nil {
            objc_setAssociatedObject(self, &AssociatedKeys.delegate, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            objc_setAssociatedObject(self, &AssociatedKeys.delegate, WeakReference(with: delegate), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

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

        addSubview(view)
        view.setupLayout()
    }

    weak var emptyDataSetView: EmptyDataSetView? {
        get {
            if let reference = objc_getAssociatedObject(self, &AssociatedKeys.view) as? WeakReference {
                return reference.object as? EmptyDataSetView
            } else {
                let view = EmptyDataSetView()

                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapContentView(_:)))
                view.addGestureRecognizer(tapGesture)

                objc_setAssociatedObject(self, &AssociatedKeys.view, WeakReference(with: view), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return view
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.view, WeakReference(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }

    // MARK: - Swizzling

    var didSwizzle: Bool? {
        get {
            let reference = objc_getAssociatedObject(self, &AssociatedKeys.didSwizzle) as? WeakReference
            let number = reference?.object as? NSNumber
            return number?.boolValue ?? false // Returns false if the boolValue is nil.
        }
        set {
            if let bool = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.didSwizzle, WeakReference(with: NSNumber(value: bool)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &AssociatedKeys.didSwizzle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    func swizzleIfNeeded() {
        guard let bool = didSwizzle, !bool else { return }

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

    // MARK: - Invalidation

    func invalidate() {
        if let view = emptyDataSetView {
            view.prepareForReuse()
            view.isHidden = true
            emptyDataSetView = nil
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
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            if let items = dataSource?.tableView(self, numberOfRowsInSection: i), items > 0 {
                return false
            }
        }
        
        return true
    }

    @objc func reloadData_swizzled() {
        print("reloadData_swizzled")

        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc func endUpdates_swizzled() {
        print("endUpdates_swizzled")

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
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            if let items = dataSource?.collectionView(self, numberOfItemsInSection: i), items > 0 {
                return false
            }
        }
        
        return true
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

class WeakReference: NSObject {
    weak var object: AnyObject?

    init(with object: Any?) {
        super.init()
        self.object = object as AnyObject?
    }

    deinit {
        print("WeakReference -deinit")
        self.object = nil
    }
}
