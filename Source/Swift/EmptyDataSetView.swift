//
//  EmptyDataSetView.swift
//  EmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 2019-12-31.
//  Copyright © 2019 DZN. All rights reserved.
//

import UIKit
import SnapKit

internal class EmptyDataSetView: UIView {

    // MARK: - Internal

    var fadeInOnDisplay = false
    var verticalSpacing: [EmptyDataSetElement: CGFloat]?

    lazy var contentView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .regular)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()

    // MARK: - Private

    fileprivate var canShowImage: Bool {
        return imageView.image != nil
    }

    fileprivate var canShowTitle: Bool {
        guard let attributedString = titleLabel.attributedText else { return false }
        return !attributedString.string.isEmpty
    }

    fileprivate var canShowDescription: Bool {
        guard let attributedString = descriptionLabel.attributedText else { return false }
        return !attributedString.string.isEmpty
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView Overrides

    override func didMoveToWindow() {
        guard let superview = superview else { return }
        frame = superview.bounds

        contentView.frame = bounds
        addSubview(contentView)

        if fadeInOnDisplay {
            UIView.animate(withDuration: 0.25, animations: { [weak self] () -> Void in
                self?.contentView.alpha = 1
            })
        } else {
            contentView.alpha = 1
        }
    }

    // MARK: - Layout

    func setupLayout() {

        prepareForReuse()

        var views = [UIView]()
        if canShowImage { views.append(imageView) }
        if canShowTitle { views.append(titleLabel) }
        if canShowDescription { views.append(descriptionLabel) }

        // skip layout if there is nothing to display
        guard views.count > 0 else { return }

        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = EmptyDataSetDefaultSpacing

        if let spacing = verticalSpacing {
            if let space = spacing[.image] { stackView.setCustomSpacing(space, after: imageView) }
            if let space = spacing[.title] { stackView.setCustomSpacing(space, after: titleLabel) }
            if let space = spacing[.description] { stackView.setCustomSpacing(space, after: descriptionLabel) }
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        // TODO: For some reason, the following implementation is causing conflicts and not laying out correctly!
        // This is the exact same result that the SnapKit implementation above!
//        NSLayoutConstraint.activate([
//            contentView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
//            contentView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
//        ])
    }

    func prepareForReuse() {
        guard contentView.subviews.count > 0 else { return }

        titleLabel.text = nil
        titleLabel.frame = .zero

        descriptionLabel.text = nil
        descriptionLabel.frame = .zero

        imageView.image = nil

        // Removes all subviews
        contentView.subviews.forEach({$0.removeFromSuperview()})
    }

    // MARK: - Gesture Handling

    fileprivate func didTapView(sender: UIView) {
        print("didTapView: \(sender)")
    }

    fileprivate func didTapButton(sender: UIButton) {
        print("didTapButton: \(self)")
    }
}

extension UIView {

    @discardableResult
    func equallyRelatedConstraint(view: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
    }
}
