//
//  DZNEmptyDataSet.swift
//  Sample
//
//  Created by Ignacio Romero on 12/18/15.
//  Copyright © 2015 DZN Labs. All rights reserved.
//

import UIKit

@objc public protocol DZNEmptyDataSetSource : NSObjectProtocol {
    
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
                
//                let gesture = UITapGestureRecognizer.init(target: self, action: Selector("didTapContentView:"))
//                gesture.delegate = self
//                
//                
//                view?.tapGesture =
//                view?.tapGesture?.delegate = self
//                view?.addGestureRecognizer((view?.tapGesture?)!)
                
//                view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dzn_didTapContentView:)];
//                view.tapGesture.delegate = self;
//                [view addGestureRecognizer:view.tapGesture];
                
                self.emptyDataSetView = view;
            }
            
            return view
        }
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.view, value ,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var itemsCount: Int {
        get {
            var items = 0
            
            if !self.respondsToSelector(Selector("dataSource")) {
                return items
            }
            
            if self is UITableView {
                
                let tableView = self as! UITableView
                let sections = (tableView.dataSource?.numberOfSectionsInTableView!(tableView))!
                
                for i in 0..<sections {
                    items += (tableView.dataSource?.tableView(tableView, numberOfRowsInSection: i))!
                }
            }
            else if self is UICollectionView {
                
                let collectionView = self as! UICollectionView
                let sections = (collectionView.dataSource?.numberOfSectionsInCollectionView!(collectionView))!
                
                for i in 0..<sections {
                    items += (collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: i))!
                }
            }
            
            return items
        }
    }
    
    
    // MARK: - Public Methods

    func reloadEmptyDataSet() {
        self.reloadEmptyDataSet()
        
        print("reloadEmptyDataSet")
        
        if (!canDisplay()) {
            self.invalidateLayout()
            return;
        }
        

        let view = self.emptyDataSetView
        view?.backgroundColor = backgroundColor()
        
        
        if view != nil && view?.superview == nil {
            self.addSubview(view!)
        }
    }
    
    private func canDisplay() -> Bool {
        return self.itemsCount == 0 ? true : false
    }
    
    private func shouldDisplay() -> Bool {
        return (self.emptyDataSetDelegate?.emptyDataSetShouldDisplay!(self))!
    }
    
    private func backgroundColor() -> UIColor {
        if let color = (self.emptyDataSetSource?.backgroundColorForEmptyDataSet!(self)) {
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
    
    private func swizzle(originalSelector: Selector, swizzledSelector: Selector) -> Bool {
        
        if self.respondsToSelector(originalSelector) == false {
            return false
        }
        
        let originalMethod = class_getInstanceMethod(self.classForCoder, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self.classForCoder, swizzledSelector)
        
        let targetedMethod = class_addMethod(self.classForCoder, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if originalMethod != nil && swizzledMethod != nil {
            if targetedMethod {
                class_replaceMethod(self.classForCoder, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
                return true
            }
            else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
                return true
            }
        }
        
        return false
    }
    
    private func swizzleIfNeeded() {
        
        if didSwizzle == false {
            let newSelector = Selector("reloadEmptyDataSet")
            
            didSwizzle = swizzle(Selector("reloadData"), swizzledSelector: newSelector)
            didSwizzle = swizzle(Selector("endUpdates"), swizzledSelector: newSelector)
        }
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
    
    func setupConstraints() {
        
    }
    
    func prepareForReuse() {
        
    }
}
