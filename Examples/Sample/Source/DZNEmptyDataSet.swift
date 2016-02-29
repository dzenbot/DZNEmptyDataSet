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
    
    optional func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString?
    
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
    
    private var emptyDataSetView: DZNEmptyDataSetView? {
        get {
            var view = objc_getAssociatedObject(self, &AssociatedKeys.view) as? DZNEmptyDataSetView
            
            if view == nil {
                view = DZNEmptyDataSetView(frame: self.bounds)
                view?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                view?.hidden = false
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: Selector("didTapView:"))
                view?.addGestureRecognizer(tapGesture)
                
                self.emptyDataSetView = view
            }
            
            return view
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.view, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    // MARK: - Public Methods
    
    private struct AssociatedKeys {
        static var datasource = "emptyDataSetSource"
        static var delegate = "emptyDataSetDelegate"
        static var view = "emptyDataSetView"
        static var didSwizzle = "didSwizzle"
    }
    
    public func reloadEmptyDataSet() {
        
        // Calls the original implementation
        self.reloadEmptyDataSet()
        self.invalidateLayout()
        
        guard self.canDisplay && self.shouldDisplay else { return }
        guard let view = self.emptyDataSetView else { return }
        
        print("reloadEmptyDataSet")
        
        self.addSubview(view)
        
        // Configure title label
        if let attributedText = self.attributedTitle, let label = view.titleLabel {
            label.attributedText = attributedText;
            view.contentView.addSubview(label)
        }
        
        // Configure detail label
        if let attributedText = self.attributedDescription, let label = view.detailLabel {
            label.attributedText = attributedText;
            view.contentView.addSubview(label)
        }
        
        // Configure the empty dataset view
        view.backgroundColor = .blueColor()
        view.contentView.backgroundColor = self.backgroundColor()
        view.hidden = false
        view.clipsToBounds = true
        
        self.scrollEnabled = self.shouldScroll
        
        view.setupConstraints();
        view.layoutIfNeeded();
    }
    
    // TODO: Add tests
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
    
    // TODO: Add tests
    private var sectionsToIgnore: NSIndexSet {
        guard let emptyDataSetSource = emptyDataSetSource where emptyDataSetSource.respondsToSelector(Selector("sectionsToIgnore")) else { return NSIndexSet(index: -1) }
        guard let indexSet = emptyDataSetSource.sectionsToIgnore?(self) else { return NSIndexSet(index: -1) }
        
        return indexSet
    }
    
    private var attributedTitle: NSAttributedString? {
        if let datasource = emptyDataSetSource, callback = datasource.titleForEmptyDataSet where datasource.respondsToSelector(Selector("titleForEmptyDataSet:")) {
            return callback(self)
        }
        return nil
    }
    
    private var attributedDescription: NSAttributedString? {
        if let datasource = emptyDataSetSource, callback = datasource.descriptionForEmptyDataSet where datasource.respondsToSelector(Selector("descriptionForEmptyDataSet:")) {
            return callback(self)
        }
        return nil
    }
    
    private func backgroundColor() -> UIColor {
        if let color = (emptyDataSetSource?.backgroundColorForEmptyDataSet?(self)) {
            return color
        }
        return .clearColor()
    }
    
    private var canDisplay: Bool {
        return self.itemsCount > 0 ? false : true
    }
    
    private var shouldDisplay: Bool {
        if let delegate = emptyDataSetDelegate, callback = delegate.emptyDataSetShouldDisplay where delegate.respondsToSelector(Selector("emptyDataSetShouldDisplay:")) {
            return callback(self)
        }
        return false
    }
    
    private var shouldScroll: Bool {
        if let delegate = emptyDataSetDelegate, callback = delegate.emptyDataSetShouldAllowScroll where delegate.respondsToSelector(Selector("emptyDataSetShouldAllowScroll:")) {
            return callback(self)
        }
        return false
    }
    
    func didTapView(sender: UIView) {
        if let delegate = emptyDataSetDelegate where delegate.respondsToSelector(Selector("emptyDataSet:didTapView:")) {
            delegate.emptyDataSet?(self, didTapView: sender)
        }
    }
    
    private func invalidateLayout() {
        
        // Cleans up the empty data set view
        self.emptyDataSetView?.removeFromSuperview()
        self.emptyDataSetView = nil
        
        self.scrollEnabled = true
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
private class DZNEmptyDataSetView: UIView, UIGestureRecognizerDelegate {
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clearColor()
        view.userInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clearColor()
        label.font = UIFont.systemFontOfSize(27)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.accessibilityLabel = "empty set title"
        return label
    }()
    
    lazy var detailLabel: UILabel? = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clearColor()
        label.font = UIFont.systemFontOfSize(17)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.accessibilityLabel = "empty set detail label"
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var customView: UIView? {
        get {
            return nil
        }
        set {
            if let view = self.customView {
                view.removeFromSuperview()
            }
            
            
        }
    }
    
    var tapGesture: UITapGestureRecognizer?
    
    var verticalOffset: CGFloat = 0
    var verticalSpace: CGFloat = 0
    
    var fadeInOnDisplay = false
    
    var canShowTitle: Bool {
        guard let label = self.titleLabel where label.superview != nil else { return false }
        return label.attributedText?.string.characters.count > 0
    }
    
    var canShowDetail: Bool {
        guard let label = self.detailLabel where label.superview != nil else { return false }
        return label.attributedText?.string.characters.count > 0
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.addSubview(self.contentView)
    }
    
    override func didMoveToSuperview() {
        
        guard let superview = self.superview else { return }
        self.frame = superview.bounds;
        
        if self.fadeInOnDisplay {
            
        }
        else {
            self.contentView.alpha = 1
        }
    }
    
    func setupConstraints() {
        
        let width = self.frame.width
        let padding = Double(width/16.0)
        let space = self.verticalSpace > 0 ? self.verticalSpace : 11 // Default is 11 pts
        let metrics:[String: Double] = ["padding": padding]

        var views:[String: UIView] = [:]
        
        [self.addEquallyRelatedConstraint(contentView, attribute: .CenterY)]
        [self.addEquallyRelatedConstraint(contentView, attribute: .CenterY)]

        self.addConstraintsWithVisualFormat("|[contentView]|", metrics: nil, views: ["contentView": contentView])

        // Assign the title label's horizontal constraints
        if self.canShowTitle, let label = self.titleLabel {
            
            views.updateValue(label, forKey: "titleLabel")
            contentView.addConstraintsWithVisualFormat("|-(padding@750)-[titleLabel]-(padding@750)-|", metrics: metrics, views: views)
        }
        
        // Assign the detail label's horizontal constraints
        if self.canShowDetail, let label = self.detailLabel {
            
            views.updateValue(label, forKey: "detailLabel")
            contentView.addConstraintsWithVisualFormat("|-(padding@750)-[detailLabel]-(padding@750)-|", metrics: metrics, views: views)
        }
        
        var verticalFormat = ""
        
        for i in 0..<views.count {
            let name = Array(views.keys)[i]
            
            verticalFormat += "[\(name)]"
            
            if (i < views.count-1) {
                verticalFormat += "-(\(space)@750)-"
            }
        }
        
        // Assign the vertical constraints to the content view
        if (verticalFormat.characters.count > 0) {
            contentView.addConstraintsWithVisualFormat("V:|\(verticalFormat)|", metrics: metrics, views: views)
        }
    }
    
    func prepareForReuse() {
        
        guard contentView.subviews.count > 0 else { return }
        
        titleLabel?.text = nil
        titleLabel?.frame = CGRectZero
        
        detailLabel?.text = nil
        detailLabel?.frame = CGRectZero

        // Removes all subviews
        contentView.subviews.forEach({$0.removeFromSuperview()})
        
        // Removes all layout constraints
        contentView.removeConstraints(contentView.constraints)
        self.removeConstraints(self.constraints)
    }
}

// MARK: - UIView extension
private extension UIView {
    
    func addConstraintsWithVisualFormat(format: String, metrics: [String : AnyObject]?, views: [String : AnyObject]) {
        
        let noLayoutOptions = NSLayoutFormatOptions(rawValue: 0)
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: noLayoutOptions, metrics: metrics, views: views)
        
        self.addConstraints(constraints)
    }
    
    func addEquallyRelatedConstraint(view: UIView, attribute: NSLayoutAttribute) {
        
        let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
    }
}
