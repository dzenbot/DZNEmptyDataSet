//
//  DZNEmptyDataSet.swift
//  Sample
//
//  Created by Ignacio Romero on 12/18/15.
//  Copyright © 2015 DZN Labs. All rights reserved.
//

import UIKit

// TODO: Add documentation once completed
/**
 The object that acts as the data source of the empty datasets.
 
 The data source must adopt the DZNEmptyDataSetSource protocol. The data source is not retained. All data source methods are optional.
 */
@objc public protocol DZNEmptyDataSetSource : NSObjectProtocol {
    
    ///
    optional func sectionsToIgnore(scrollView: UIScrollView) -> NSIndexSet?
    
    /**
     Asks the data source for the title of the dataset.
     The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
     
     - Parameter scrollView: A scrollView subclass informing the data source.
     - Returns: An attributed string for the dataset title, combining font, text color, text pararaph style, etc.
     */
    optional func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString?
    
    /**
     Asks the data source for the description of the dataset.
     The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
     
     - Parameter scrollView: A scrollView subclass informing the data source.
     - Returns: An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
     */
    optional func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString?
    
    /**
     Asks the data source for the image of the dataset.
     
     - Parameter scrollView: A scrollView subclass informing the data source.
     - Returns: An image for the dataset.
     */
    optional func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage?
    
    /**
     Asks the data source for a tint color of the image dataset. Default is nil.
     
     - Parameter scrollView: A scrollView subclass object informing the data source.
     - Returns: A color to tint the image of the dataset.
     */
    optional func imageTintColorForEmptyDataSet(scrollView: UIScrollView) -> UIImage?
    
    /**
     *  Asks the data source for the image animation of the dataset.
     *
     *  - Parameter scrollView: A scrollView subclass object informing the delegate.
     *
     *  - Returns: image animation
     */
    optional func imageAnimationForEmptyDataSet(scrollView: UIScrollView) -> CAAnimation
    
    /**
     Asks the data source for the title to be used for the specified button state.
     The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
     
     - Parameter scrollView: A scrollView subclass object informing the data source.
     - Parameter state: The state that uses the specified title. The possible values are described in UIControlState.
     - Returns: An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
     */
    optional func buttonTitleForEmptyDataSet(scrollView: UIScrollView, state: UIControlState) -> NSAttributedString?
    
    /**
     Asks the data source for the image to be used for the specified button state.
     This method will override buttonTitleForEmptyDataSet:forState: and present the image only without any text.
     
     - Parameter scrollView: A scrollView subclass object informing the data source.
     - Parameter state: The state that uses the specified title. The possible values are described in UIControlState.
     - Returns: An image for the dataset button imageview.
     */
    optional func buttonImageForEmptyDataSet(scrollView: UIScrollView, state: UIControlState) -> UIImage?
    
    /**
     Asks the data source for a background image to be used for the specified button state.
     There is no default style for this call.
     
     - Parameter scrollView: A scrollView subclass informing the data source.
     - Parameter state: The state that uses the specified image. The values are described in UIControlState.
     - Returns: An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
     */
    optional func buttonBackgroundImageForEmptyDataSet(scrollView: UIScrollView, state: UIControlState) -> UIImage?
    
    /**
     Asks the data source for the background color of the dataset. Default is clear color.
     
     - Parameter scrollView: A scrollView subclass object informing the data source.
     - Returns: A color to be applied to the dataset background view.
     */
    optional func backgroundColorForEmptyDataSet(scrollView: UIScrollView) -> UIColor?
    
    /**
     Asks the data source for a custom view to be displayed instead of the default views such as labels, imageview and button. Default is nil.
     Use this method to show an activity view indicator for loading feedback, or for complete custom empty data set.
     Returning a custom view will ignore -offsetForEmptyDataSet and -spaceHeightForEmptyDataSet configurations.
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: The custom view.
     */
    optional func customViewForEmptyDataSet(scrollView: UIScrollView) -> UIImage?
    
    /**
     Asks the data source for a offset for vertical and horizontal alignment of the content. Default is CGPointZero.
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: The offset for vertical and horizontal alignment.
     */
    optional func verticalOffsetForEmptyDataSet(scrollView: UIScrollView) -> CGFloat
    
    /**
     Asks the data source for a vertical space between elements. Default is 11 pts.
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: The space height between elements.
     */
    optional func spaceHeightForEmptyDataSet(scrollView: UIScrollView) -> CGFloat
}

// TODO: Add documentation once completed
/**
 The object that acts as the delegate of the empty datasets.
 The delegate can adopt the DZNEmptyDataSetDelegate protocol. The delegate is not retained. All delegate methods are optional.
 
 All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@objc public protocol DZNEmptyDataSetDelegate : NSObjectProtocol {
    
    /**
     Asks the delegate to know if the empty dataset should be rendered and displayed. Default is true.
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: true if the empty dataset should show.
     */
    optional func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool
    
    /**
     Asks the delegate for touch permission. Default is true.
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: true if the empty dataset receives touch gestures.
     */
    optional func emptyDataSetShouldAllowTouch(scrollView: UIScrollView) -> Bool
    
    /**
     Asks the delegate for scroll permission. Default is false.
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: true if the empty dataset is allowed to be scrollable.
     */
    optional func emptyDataSetShouldAllowScroll(scrollView: UIScrollView) -> Bool
    
    /**
     Asks the delegate to know if the empty dataset should fade in when displayed. Default is true.
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: true if the empty dataset should fade in.
     */
    optional func emptyDataSetShouldFadeIn(scrollView: UIScrollView) -> Bool
    
    /**
     Asks the delegate for image view animation permission. Default is false.
     Make sure to return a valid CAAnimation object from imageAnimationForEmptyDataSet:
     
     - Parameter scrollView: A scrollView subclass object informing the delegate.
     - Returns: true if the empty dataset is allowed to animate
     */
    optional func emptyDataSetShouldAnimateImageView(scrollView: UIScrollView) -> Bool
    
    /**
     Tells the delegate that the empty dataset view was tapped.
     Use this method either to resignFirstResponder of a textfield or searchBar.
     
     - Parameter scrollView: A scrollView subclass informing the delegate.
     - Parameter view: the view tapped by the user
     */
    optional func emptyDataSet(scrollView: UIScrollView, didTapView: UIView)
    
    /**
     Tells the delegate that the action button was tapped.
     
     - Parameter scrollView: A scrollView subclass informing the delegate.
     - Parameter button: the button tapped by the user
     */
    optional func emptyDataSet(scrollView: UIScrollView, didTapButton: UIButton)
    
    /**
     Tells the delegate that the empty data set will appear.
     
     - Parameter scrollView: A scrollView subclass informing the delegate.
     */
    optional func emptyDataSetWillAppear(scrollView: UIScrollView)
    
    /**
     Tells the delegate that the empty data set did appear.
     
     - Parameter scrollView: A scrollView subclass informing the delegate.
     */
    optional func emptyDataSetDidAppear(scrollView: UIScrollView)
    
    /**
     Tells the delegate that the empty data set will disappear.
     
     - Parameter scrollView: A scrollView subclass informing the delegate.
     */
    optional func emptyDataSetWillDisappear(scrollView: UIScrollView)
    
    /**
     Tells the delegate that the empty data set did disappear.
     
     - Parameter scrollView: A scrollView subclass informing the delegate.
     */
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
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapView(_:)))
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
        
        self.invalidateLayout()
        
        guard self.canDisplay && self.shouldDisplay else { return }
        guard let view = self.emptyDataSetView else { return }
        
        print("reloadEmptyDataSet")
        
        var counter = 0
        
        // Configure Image
        if let image = self.topImage, let imageView = view.imageView {
            imageView.image = image;
            view.contentView.addSubview(imageView)
            
            counter += 1
        }
        
        // Configure title label
        if let attributedText = self.attributedTitle, let label = view.titleLabel {
            label.attributedText = attributedText;
            view.contentView.addSubview(label)
            
            counter += 1
        }
        
        // Configure detail label
        if let attributedText = self.attributedDescription, let label = view.detailLabel {
            label.attributedText = attributedText;
            view.contentView.addSubview(label)
            
            counter += 1
        }
        
        // Configure button
        if let attributedText = self.attributedButtonTitle(.Normal), let button = view.button {
            button.setAttributedTitle(attributedText, forState: .Normal)
            view.contentView.addSubview(button)
            
            button.addTarget(self, action: #selector(didTapView(_:)), forControlEvents: .TouchUpInside)
            
            counter += 1
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
            let sections = tableView.dataSource?.numberOfSectionsInTableView?(tableView) ?? 1
            
            for i in 0..<sections where !self.sectionsToIgnore.containsIndex(i) {
                guard let item = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: i) else { continue }
                items += item
            }
        }
        else if let collectionView = self as? UICollectionView {
            let sections = collectionView.dataSource?.numberOfSectionsInCollectionView?(collectionView) ?? 1
            
            for i in 0..<sections where !self.sectionsToIgnore.containsIndex(i) {
                guard let item = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: i) else { continue }
                items += item
            }
        }
        
        return items
    }
    
    // TODO: Add tests
    private var sectionsToIgnore: NSIndexSet {
        guard let indexSet = emptyDataSetSource?.sectionsToIgnore?(self) else { return NSIndexSet(index: -1) }
        
        return indexSet
    }
    
    private var attributedTitle: NSAttributedString? {
        return emptyDataSetSource?.titleForEmptyDataSet?(self)
    }
    
    private var attributedDescription: NSAttributedString? {
        return emptyDataSetSource?.descriptionForEmptyDataSet?(self)
    }
    
    private var topImage: UIImage? {
        return emptyDataSetSource?.imageForEmptyDataSet?(self)
    }
    
    private func attributedButtonTitle(state: UIControlState) -> NSAttributedString? {
        return emptyDataSetSource?.buttonTitleForEmptyDataSet?(self, state: state)
    }
    
    private var verticalOffset: CGFloat {
        return emptyDataSetSource?.verticalOffsetForEmptyDataSet?(self) ?? 0
    }
    
    private func backgroundColor() -> UIColor {
        return emptyDataSetSource?.backgroundColorForEmptyDataSet?(self) ?? .clearColor()
    }
    
    private var canDisplay: Bool {
        return self.itemsCount > 0 ? false : true
    }
    
    private var shouldDisplay: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldDisplay?(self) ?? true
    }
    
    private var shouldFadeIn: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldFadeIn?(self) ?? true
    }
    
    private var shouldScroll: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAllowScroll?(self) ?? true
    }
    
    private var shouldTouch: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAllowTouch?(self) ?? true
    }
    
    func didTapView(sender: AnyObject?) {
        if let view = sender where sender is UIView {
            emptyDataSetDelegate?.emptyDataSet?(self, didTapView: view as! UIView)
        }
        else if let view = sender?.view where sender is UIGestureRecognizer {
            emptyDataSetDelegate?.emptyDataSet?(self, didTapView: view)
        }
    }
    
    func willAppear() {
        emptyDataSetDelegate?.emptyDataSetWillAppear?(self)
    }
    
    func didAppear() {
        emptyDataSetDelegate?.emptyDataSetDidAppear?(self)
    }
    
    func willDisappear() {
        emptyDataSetDelegate?.emptyDataSetWillDisappear?(self)
    }
    
    func didDisappear() {
        emptyDataSetDelegate?.emptyDataSetDidDisappear?(self)
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
    
    public func reloadDataEmptyDataSet()
    {
        
        print("\(self.dynamicType).\(#function)")

        // Calls the original implementation
        self.reloadDataEmptyDataSet()
        
        reloadEmptyDataSet()
    }
    
    public func endUpdatesEmptyDataSet()
    {
        
        print("\(self.dynamicType).\(#function)")

        // Calls the original implementation
        self.endUpdatesEmptyDataSet()
        
        reloadEmptyDataSet()
    }
    
    public func performBatchUpdatesEmptyDataSet(updates: (() -> Void)?, completion: ((Bool) -> Void)?)
    {
        print("\(self.dynamicType).\(#function)")

        // Calls the original implementation
        self.performBatchUpdatesEmptyDataSet(updates, completion: completion)
        
        reloadEmptyDataSet()
    }
    
    private func swizzleIfNeeded() {
        
        if !didSwizzle {
            
            if let _ = self as? UITableView {
                
                let newReloadDataSelector = #selector(reloadDataEmptyDataSet)
                let originalReloadDataSelector = #selector(UITableView.reloadData)
                didSwizzle = swizzle(originalReloadDataSelector, swizzledSelector: newReloadDataSelector)
                
                let newEndUpdatesSelector = #selector(endUpdatesEmptyDataSet)
                let originalEndUpdatesSelector = #selector(UITableView.endUpdates)
                didSwizzle = swizzle(originalEndUpdatesSelector, swizzledSelector: newEndUpdatesSelector)
               
            } else if let _ = self as? UICollectionView {

                let newReloadDataSelector = #selector(reloadDataEmptyDataSet)
                let originalReloadDataSelector = #selector(UICollectionView.reloadData)
                didSwizzle = swizzle(originalReloadDataSelector, swizzledSelector: newReloadDataSelector)
                
                let newEndUpdatesSelector = #selector(endUpdatesEmptyDataSet)
                let originalEndUpdatesSelector = #selector(UICollectionView.performBatchUpdates(_:completion:))
                didSwizzle = swizzle(originalEndUpdatesSelector, swizzledSelector: newEndUpdatesSelector)
                
            }
            
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
