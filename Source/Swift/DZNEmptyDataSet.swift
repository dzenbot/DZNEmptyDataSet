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
    
    ///
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
                view?.backgroundColor = .clearColor()
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
        
        var counter = 0
        
        // Configure Image
        if let image = self.topImage, let imageView = view.imageView {
            imageView.image = image;
            view.contentView.addSubview(imageView)
            
            counter++
        }
        
        // Configure title label
        if let attributedText = self.attributedTitle, let label = view.titleLabel {
            label.attributedText = attributedText;
            view.contentView.addSubview(label)
            
            counter++
        }
        
        // Configure detail label
        if let attributedText = self.attributedDescription, let label = view.detailLabel {
            label.attributedText = attributedText;
            view.contentView.addSubview(label)
            
            counter++
        }
        
        // Configure button
        if let attributedText = self.attributedButtonTitle(.Normal), let button = view.button {
            button.setAttributedTitle(attributedText, forState: .Normal)
            view.contentView.addSubview(button)
            
            button.addTarget(self, action: Selector("didTapView:"), forControlEvents: .TouchUpInside)
            
            counter++
        }
        
        guard counter > 0 else { return }
        
        willAppear()
        
        // Configure the contnet view
        view.hidden = false
        view.clipsToBounds = true
        view.fadeInOnDisplay = self.shouldFadeIn
        view.verticalOffset = self.verticalOffset

        // Adds subview
        self.addSubview(view)
        
        // Configure the empty dataset view
        self.scrollEnabled = self.shouldScroll
        self.userInteractionEnabled = self.shouldTouch
        self.backgroundColor = self.backgroundColor()
        
        view.setupViewConstraints();
        view.layoutIfNeeded();
        
        didAppear()
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
    
    private var topImage: UIImage? {
        if let datasource = emptyDataSetSource, callback = datasource.imageForEmptyDataSet where datasource.respondsToSelector(Selector("imageForEmptyDataSet:")) {
            return callback(self)
        }
        return nil
    }
    
    private func attributedButtonTitle(state: UIControlState) -> NSAttributedString? {
        if let datasource = emptyDataSetSource, callback = datasource.buttonTitleForEmptyDataSet:state: where datasource.respondsToSelector(Selector("buttonTitleForEmptyDataSet:state:")) {
            return callback(self, state: state)
        }
        return nil
    }
    
    private var verticalOffset: CGFloat {
        if let datasource = emptyDataSetSource, callback = datasource.verticalOffsetForEmptyDataSet where datasource.respondsToSelector(Selector("verticalOffsetForEmptyDataSet:")) {
            return callback(self)
        }
        return 0
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
        return true
    }
    
    private var shouldFadeIn: Bool {
        if let delegate = emptyDataSetDelegate, callback = delegate.emptyDataSetShouldFadeIn where delegate.respondsToSelector(Selector("emptyDataSetShouldFadeIn:")) {
            return callback(self)
        }
        return true
    }
    
    private var shouldScroll: Bool {
        if let delegate = emptyDataSetDelegate, callback = delegate.emptyDataSetShouldAllowScroll where delegate.respondsToSelector(Selector("emptyDataSetShouldAllowScroll:")) {
            return callback(self)
        }
        return true
    }
    
    private var shouldTouch: Bool {
        if let delegate = emptyDataSetDelegate, callback = delegate.emptyDataSetShouldAllowTouch where delegate.respondsToSelector(Selector("emptyDataSetShouldAllowTouch:")) {
            return callback(self)
        }
        return true
    }
    
    func didTapView(sender: AnyObject?) {
        if let delegate = emptyDataSetDelegate where delegate.respondsToSelector(Selector("emptyDataSet:didTapView:")) {
            
            if let view = sender where sender is UIView {
                delegate.emptyDataSet?(self, didTapView: view as! UIView)
            }
            else if let view = sender?.view where sender is UIGestureRecognizer {
                delegate.emptyDataSet?(self, didTapView: view!)
            }
        }
    }
    
    func willAppear() {
        if let delegate = emptyDataSetDelegate where delegate.respondsToSelector(Selector("emptyDataSetWillAppear:")) {
            delegate.emptyDataSetWillAppear?(self)
        }
    }
    
    func didAppear() {
        if let delegate = emptyDataSetDelegate where delegate.respondsToSelector(Selector("emptyDataSetDidAppear:")) {
            delegate.emptyDataSetDidAppear?(self)
        }
    }
    
    func willDisappear() {
        if let delegate = emptyDataSetDelegate where delegate.respondsToSelector(Selector("emptyDataSetWillDisappear:")) {
            delegate.emptyDataSetWillDisappear?(self)
        }
    }
    
    func didDisappear() {
        if let delegate = emptyDataSetDelegate where delegate.respondsToSelector(Selector("emptyDataSetDidDisappear:")) {
            delegate.emptyDataSetDidDisappear?(self)
        }
    }
    
    private func invalidateLayout() {
        
        guard let view = self.emptyDataSetView where self.subviews.contains(view) else { return }
        
        willDisappear()
        
        // Cleans up the empty data set view
        self.emptyDataSetView?.removeFromSuperview()
        self.emptyDataSetView = nil
        
        self.scrollEnabled = true
        
        didDisappear()
    }
    
    
    // MARK: - Swizzling
    
    private func swizzleIfNeeded() {
        
        if !didSwizzle {
            let newSelector = Selector("reloadEmptyDataSet")
            
            didSwizzle = swizzle(Selector("reloadData"), swizzledSelector: newSelector)
            
            // TODO: Swizzling works, but whenever we swizzle this other method, it breaks.
            //didSwizzle = swizzle(Selector("endUpdates"), swizzledSelector: newSelector)
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
    
    lazy var imageView: UIImageView? = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clearColor()
        view.contentMode = .ScaleAspectFit
        view.userInteractionEnabled = false
        view.accessibilityLabel = "empty set background image"
        return view
    }()
    
    lazy var button: UIButton? = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clearColor()
        button.contentHorizontalAlignment = .Center
        button.contentVerticalAlignment = .Center
        button.accessibilityLabel = "empty set button"
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
    
    var verticalOffset: CGFloat?
    var verticalSpace: CGFloat = 0
    
    var fadeInOnDisplay = false
    
    var canShowImage: Bool {
        guard let imageView = self.imageView where imageView.superview != nil else { return false }
        return imageView.image != nil
    }
    
    var canShowTitle: Bool {
        guard let label = self.titleLabel where label.superview != nil else { return false }
        return label.attributedText?.string.characters.count > 0
    }
    
    var canShowDetail: Bool {
        guard let label = self.detailLabel where label.superview != nil else { return false }
        return label.attributedText?.string.characters.count > 0
    }
    
    var canShowButton: Bool {
        guard let button = self.button where button.superview != nil else { return false }
        return button.attributedTitleForState(.Normal)?.string.characters.count > 0
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
        self.addSubview(contentView)
    }
    
    private func didTapView(sender: UIView) {
        print("didTapView: \(sender)")
    }
    
    private func didTapView() {
        print("didTapView: \(self)")
    }
    
    override func didMoveToSuperview() {
        
        guard let superview = self.superview else { return }
        self.frame = superview.bounds;
        
        if self.fadeInOnDisplay {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.contentView.alpha = 1
            })
        }
        else {
            self.contentView.alpha = 1
        }
    }
    
    func setupViewConstraints() {
        
        let width = self.frame.width
        let padding = Double(width/16.0)
        let space = self.verticalSpace > 0 ? self.verticalSpace : 11 // Default is 11 pts
        let metrics:[String: Double] = ["padding": padding]

        var views:[String: UIView] = [:]
        var names:[String] = []

        self.addEquallyRelatedConstraint(contentView, attribute: .CenterX)
        let centerY = self.addEquallyRelatedConstraint(contentView, attribute: .CenterY)
        
        self.addConstraintsWithVisualFormat("|[contentView]|", metrics: nil, views: ["contentView": contentView])

        // When a custom offset is available, we adjust the vertical constraints' constants
        if let offset = self.verticalOffset where offset != 0 {
            centerY.constant = offset
        }
        
        // Assign the image view's horizontal constraints
        if self.canShowImage, let imageView = self.imageView {
            
            let name = "imageView"

            names.append(name)
            views.updateValue(imageView, forKey: name)
            
            contentView.addEquallyRelatedConstraint(imageView, attribute: .CenterX)
        }
        
        // Assign the title label's horizontal constraints
        if self.canShowTitle, let label = self.titleLabel {
            
            let name = "titleLabel"

            names.append(name)
            views.updateValue(label, forKey: name)
            
            contentView.addConstraintsWithVisualFormat("|-(padding@750)-[\(name)]-(padding@750)-|", metrics: metrics, views: views)
        }
        
        // Assign the detail label's horizontal constraints
        if self.canShowDetail, let label = self.detailLabel {
            
            let name = "detailLabel"
            
            names.append(name)
            views.updateValue(label, forKey: name)
            
            contentView.addConstraintsWithVisualFormat("|-(padding@750)-[\(name)]-(padding@750)-|", metrics: metrics, views: views)
        }
        
        // Assign the button's horizontal constraints
        if self.canShowButton, let button = self.button {
            
            let name = "button"
            
            names.append(name)
            views.updateValue(button, forKey: name)
            
            contentView.addConstraintsWithVisualFormat("|-(padding@750)-[\(name)]-(padding@750)-|", metrics: metrics, views: views)
        }
        
        var verticalFormat = ""

        for i in 0..<names.count {
            let name = names[i]
            
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
    
//    func prepareForReuse() {
//        
//        guard contentView.subviews.count > 0 else { return }
//        
//        titleLabel?.text = nil
//        titleLabel?.frame = CGRectZero
//        
//        detailLabel?.text = nil
//        detailLabel?.frame = CGRectZero
//
//        // Removes all subviews
//        contentView.subviews.forEach({$0.removeFromSuperview()})
//        
//        // Removes all layout constraints
//        contentView.removeConstraints(contentView.constraints)
//        self.removeConstraints(self.constraints)
//    }
}

// MARK: - UIView extension
private extension UIView {
    
    func addConstraintsWithVisualFormat(format: String, metrics: [String : AnyObject]?, views: [String : AnyObject]) {
        
        let noLayoutOptions = NSLayoutFormatOptions(rawValue: 0)
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: noLayoutOptions, metrics: metrics, views: views)
        
        self.addConstraints(constraints)
    }
    
    func addEquallyRelatedConstraint(view: UIView, attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
        
        return constraint
    }
}
