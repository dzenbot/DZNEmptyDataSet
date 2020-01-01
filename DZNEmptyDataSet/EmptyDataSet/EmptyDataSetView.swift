//
//  EmptyDataSetView.swift
//  EmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 2019-12-31.
//  Copyright © 2019 DZN. All rights reserved.
//

import UIKit

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

    // MARK: - Private

    fileprivate func verticalStackView(with views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }

    fileprivate var canShowImage: Bool {
        return imageView.image != nil
    }

    fileprivate var canShowTitle: Bool {
        guard let attributedString = titleLabel.attributedText else { return false }
        return !attributedString.string.isEmpty
    }

    fileprivate var canShowDetail: Bool {
        guard let attributedString = descriptionLabel.attributedText else { return false }
        return !attributedString.string.isEmpty
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
}
