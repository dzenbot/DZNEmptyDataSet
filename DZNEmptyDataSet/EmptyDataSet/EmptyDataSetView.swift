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

        contentView.frame = UIScreen.main.bounds
        addSubview(contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView Overrides

    override func didMoveToWindow() {
        guard let superview = self.superview else { return }
        self.frame = superview.bounds

        if self.fadeInOnDisplay {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.contentView.alpha = 1
            })
        }
        else {
            self.contentView.alpha = 1
        }
    }

    // MARK: - Layout

    func setupLayout() {

        prepareForReuse()

        let padding = frame.width/16
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
        stackView.spacing = 10

        if canShowImage { stackView.setCustomSpacing(50, after: imageView) }
//        stackView.setCustomSpacing(10, after: titleLabel)

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
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

    fileprivate func didTapView() {
        print("didTapView: \(self)")
    }
}
