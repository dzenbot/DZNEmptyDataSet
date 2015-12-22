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
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.datasource, value ,objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            
            swizzleIfNeeded()
        }
    }
    
    weak public var emptyDataSetDelegate: DZNEmptyDataSetDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.delegate) as? DZNEmptyDataSetDelegate
        }
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.delegate, value ,objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            
            swizzleIfNeeded()
        }
    }
    
    // TODO: Not implemented yet
    var isEmptyDataSetVisible: Bool {
        get {
            return false
        }
    }
    
    
    // MARK: - Private Properties
    
    private var didSwizzle: Bool {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.didSwizzle) as? NSNumber
            
            if value != nil {
                return (value?.boolValue)!
            }
            return false
        }
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.didSwizzle, NSNumber(bool: value) ,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    weak private var emptyDataSetView: DZNEmptyDataSetView? {
        get {
            var view = objc_getAssociatedObject(self, &AssociatedKeys.view) as? DZNEmptyDataSetView
            
            if view == nil {
                view = DZNEmptyDataSetView(frame: self.bounds)
                view?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
                view?.hidden = false
                
                // TODO: Add tap gesture recognizer
                
                self.emptyDataSetView = view;
            }
            
            return view
        }
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.view, value ,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    // MARK: - Public Methods
    
    func reloadEmptyDataSet() {
        self.reloadEmptyDataSet()
        
        print("reloadEmptyDataSet")
        
        if (!canDisplay() || !shouldDisplay()) {
            invalidateLayout()
            return;
        }
        
        let view = self.emptyDataSetView
        view?.backgroundColor = backgroundColor()
        
        if view != nil && view?.superview == nil {
            self.addSubview(view!)
        }
    }
    
    private func sectionsToIgnore() -> NSIndexSet {
        if emptyDataSetSource?.respondsToSelector(Selector("sectionsToIgnore")) == true {
            if let indexSet = (emptyDataSetSource?.sectionsToIgnore!(self)) {
                return indexSet
            }
        }
        return NSIndexSet(index: -1) // Fallback to invalid index
    }
    
    private func itemsCount() -> Int {
        var items = 0
        
        if !self.respondsToSelector(Selector("dataSource")) {
            return items
        }
        
        let sectionsToIgnore = self.sectionsToIgnore()
        
        if self is UITableView {
            
            let tableView = self as! UITableView
            let sections = (tableView.dataSource?.numberOfSectionsInTableView!(tableView))!
            
            for i in 0..<sections {
                if sectionsToIgnore.containsIndex(i) == false {
                    items += (tableView.dataSource?.tableView(tableView, numberOfRowsInSection: i))!
                }
            }
        }
        else if self is UICollectionView {
            
            let collectionView = self as! UICollectionView
            let sections = (collectionView.dataSource?.numberOfSectionsInCollectionView!(collectionView))!
            
            for i in 0..<sections {
                if sectionsToIgnore.containsIndex(i) == false {
                    items += (collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: i))!
                }
            }
        }
        
        return items
    }
    
    private func canDisplay() -> Bool {
        return itemsCount() == 0 ? true : false
    }
    
    private func shouldDisplay() -> Bool {
        if emptyDataSetDelegate?.respondsToSelector("emptyDataSetShouldDisplay:") == true {
            return (emptyDataSetDelegate?.emptyDataSetShouldDisplay!(self))!
        }
        return true
    }
    
    private func backgroundColor() -> UIColor {
        if let color = (emptyDataSetSource?.backgroundColorForEmptyDataSet!(self)) {
            return color
        }
        return UIColor.clearColor()
    }
    
    private func invalidateLayout() {
        
        if let view = self.emptyDataSetView {
            view.prepareForReuse()
            view.removeFromSuperview()
        }
    }
    
    
    // MARK: - Swizzling
    
    private func swizzleIfNeeded() {
        
        if didSwizzle == false {
            let newSelector = Selector("reloadEmptyDataSet")
            
            didSwizzle = swizzle(Selector("reloadData"), swizzledSelector: newSelector)
            didSwizzle = swizzle(Selector("endUpdates"), swizzledSelector: newSelector)
        }
    }
    
    // TODO: Swizzling works, for it doesn't call the original implementation anymore! Need to fix this.
    private func swizzle(originalSelector: Selector, swizzledSelector: Selector) -> Bool {
        
        if self.respondsToSelector(originalSelector) == false {
            return false
        }
        
        let thisClass: AnyClass = self.classForCoder
        
        let originalMethod = class_getInstanceMethod(thisClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(thisClass, swizzledSelector)
        
        let targetedMethod = class_addMethod(thisClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if originalMethod != nil && swizzledMethod != nil {
            if targetedMethod {
                class_replaceMethod(thisClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
                return true
            }
            else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
                return true
            }
        }
        
        return false
    }
}

class DZNEmptyDataSetView: UIView {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clearColor()
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
    
    var fadeInOnDisplay: Bool = false
    
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
