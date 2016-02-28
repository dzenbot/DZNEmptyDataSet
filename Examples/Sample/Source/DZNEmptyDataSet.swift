//
//  DZNEmptyDataSet.swift
//  Sample
//
//  Created by Ignacio Romero on 12/18/15.
//  Copyright © 2015 DZN Labs. All rights reserved.
//

import UIKit

// TODO: Add documentation once completed
@objc public protocol DZNEmptyDataSetSource : NSObjectProtocol {
    
    optional func sectionsToIgnore(scrollView: UIScrollView) -> NSIndexSet?
    
    optional func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString?
    
    optional func scriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString?
    
    optional func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage?
    
    optional func imageTintColorForEmptyDataSet(scrollView: UIScrollView) -> UIImage?
    
    optional func buttonTitleForEmptyDataSet(scrollView: UIScrollView, state: UIControlState) -> NSAttributedString?
    
    optional func buttonImageForEmptyDataSet(scrollView: UIScrollView, state: UIControlState) -> UIImage?
    
    optional func buttonBackgroundImageForEmptyDataSet(scrollView: UIScrollView, state: UIControlState) -> UIImage?
    
    optional func backgroundColorForEmptyDataSet(scrollView: UIScrollView) -> UIColor?
    
    optional func customViewForEmptyDataSet(scrollView: UIScrollView) -> UIImage?
    
    optional func verticalOffsetForEmptyDataSet(scrollView: UIScrollView) -> CGFloat
    
    optional func spaceHeightForEmptyDataSet(scrollView: UIScrollView) -> CGFloat
}

// TODO: Add documentation once completed
@objc public protocol DZNEmptyDataSetDelegate : NSObjectProtocol {
    
    optional func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool
    
    optional func emptyDataSetShouldAllowTouch(scrollView: UIScrollView) -> Bool
    
    optional func emptyDataSetShouldAllowScroll(scrollView: UIScrollView) -> Bool
    
    optional func emptyDataSetShouldFadeIn(scrollView: UIScrollView) -> Bool
    
    optional func emptyDataSetShouldAnimateImageView(scrollView: UIScrollView) -> Bool
    
    optional func emptyDataSet(scrollView: UIScrollView, didTapView: UIView)
    
    optional func emptyDataSet(scrollView: UIScrollView, didTapButton: UIButton)
    
    optional func emptyDataSetWillAppear(scrollView: UIScrollView)
    
    optional func emptyDataSetDidAppear(scrollView: UIScrollView)
    
    optional func emptyDataSetWillDisappear(scrollView: UIScrollView)
    
    optional func emptyDataSetDidDisappear(scrollView: UIScrollView)
}

// MARK: - UIScrollView extension
extension UIScrollView {
    
    // MARK: - Public Properties
    
    private struct AssociatedKeys {
        static var datasource = "emptyDataSetSource"
        static var delegate = "emptyDataSetDelegate"
        static var view = "emptyDataSetView"
        static var didSwizzle = "didSwizzle"
    }
    
    weak public var emptyDataSetSource: DZNEmptyDataSetSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.datasource) as? DZNEmptyDataSetSource
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.datasource, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            swizzleIfNeeded()
        }
    }
    
    weak public var emptyDataSetDelegate: DZNEmptyDataSetDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.delegate) as? DZNEmptyDataSetDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.delegate, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            swizzleIfNeeded()
        }
    }
    
    // TODO: Not implemented yet
    var isEmptyDataSetVisible: Bool {
        return false
    }
    
    
    // MARK: - Private Properties
    
    private var didSwizzle: Bool {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.didSwizzle) as? NSNumber
            
            return value?.boolValue ?? false // Returns false if the boolValue is nil.
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.didSwizzle, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    weak private var emptyDataSetView: DZNEmptyDataSetView? {
        get {
            var view = objc_getAssociatedObject(self, &AssociatedKeys.view) as? DZNEmptyDataSetView
            
            if view == nil {
                view = DZNEmptyDataSetView(frame: self.bounds)
                view?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                view?.hidden = false
                
                // TODO: Add tap gesture recognizer
                
                self.emptyDataSetView = view
            }
            
            return view
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.view, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    // MARK: - Public Methods
    
    public func reloadEmptyDataSet() {
        
        // Calls the original implementation
        self.reloadEmptyDataSet()

        guard self.canDisplay && self.shouldDisplay else { return self.invalidateLayout() }
        
        print("reloadEmptyDataSet")

        let view = self.emptyDataSetView
        view?.backgroundColor = self.backgroundColor()
        
        if let view = view where view.superview == nil {
            self.addSubview(view)
        }
    }
    
    private var sectionsToIgnore: NSIndexSet {
        guard let emptyDataSetSource = emptyDataSetSource where emptyDataSetSource.respondsToSelector(Selector("sectionsToIgnore")) else { return NSIndexSet(index: -1) }
        guard let indexSet = emptyDataSetSource.sectionsToIgnore?(self) else { return NSIndexSet(index: -1) }
        
        return indexSet
    }
    
    private var itemsCount: Int {
        
        var items = 0
        
        guard self.respondsToSelector(Selector("dataSource")) else { return items }
        
        if let tableView = self as? UITableView {
            guard let sections = tableView.dataSource?.numberOfSectionsInTableView?(tableView) else { return items }
            
            for i in 0..<sections where !self.sectionsToIgnore.containsIndex(i) {
                guard let item = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: i) else { continue }
                items += item
            }
        }
        else if let collectionView = self as? UICollectionView {
            guard let sections = collectionView.dataSource?.numberOfSectionsInCollectionView?(collectionView) else { return items }
            
            for i in 0..<sections where !self.sectionsToIgnore.containsIndex(i) {
                guard let item = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: i) else { continue }
                items += item
            }
        }
        
        return items
    }
    
    private var canDisplay: Bool {
        return self.itemsCount > 0 ? false : true
    }
    
    private var shouldDisplay: Bool {
        if let
            emptyDataSetDelegate = emptyDataSetDelegate,
            emptyDataSetShouldDisplay = emptyDataSetDelegate.emptyDataSetShouldDisplay where emptyDataSetDelegate.respondsToSelector(Selector("emptyDataSetShouldDisplay")) {
                return emptyDataSetShouldDisplay(self)
        }
        
        return true
    }
    
    private func backgroundColor() -> UIColor {
        if let color = (emptyDataSetSource?.backgroundColorForEmptyDataSet?(self)) {
            return color
        }
        
        return UIColor.clearColor()
    }
    
    private func invalidateLayout() {
        guard let view = self.emptyDataSetView else { return }
        view.prepareForReuse()
        view.removeFromSuperview()
    }
    
    
    // MARK: - Swizzling
    
    private func swizzleIfNeeded() {
        
        if !didSwizzle {
            let newSelector = Selector("reloadEmptyDataSet")
            
            didSwizzle = swizzle(Selector("reloadData"), swizzledSelector: newSelector)
            
            // TODO: Swizzling works, but whenever we swizzle this other method, it breaks.
//             didSwizzle = swizzle(Selector("endUpdates"), swizzledSelector: newSelector)
        }
    }
    
    private func swizzle(originalSelector: Selector, swizzledSelector: Selector) -> Bool {
        guard self.respondsToSelector(originalSelector) else { return false }
        
        let originalMethod = class_getInstanceMethod(self.dynamicType, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self.dynamicType, swizzledSelector)
        
        guard originalMethod != nil && swizzledMethod != nil else { return false }
        
        let targetedMethod = class_addMethod(self.dynamicType, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if targetedMethod {
            class_replaceMethod(self.dynamicType, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            return true
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
            return true
        }
    }
}


// MARK: - DZNEmptyDataSetView
class DZNEmptyDataSetView: UIView {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clearColor()
        view.userInteractionEnabled = true
        view.alpha = 0.0
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var customView: UIView = {
        let view = UIView()
        return view
    }()
    
    var tapGesture: UITapGestureRecognizer?
    
    var verticalOffset: CGFloat = 0.0
    var verticalSpace: CGFloat = 0.0
    
    var fadeInOnDisplay = false
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // TODO: Not implemented yet
    func setupConstraints() {
        
    }
    
    // TODO: Not implemented yet
    func prepareForReuse() {
        
    }
}
