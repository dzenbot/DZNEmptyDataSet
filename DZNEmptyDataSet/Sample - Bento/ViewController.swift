//
//  ViewController.swift
//  Bento
//
//  Created by Ignacio Romero Zurbuchen on 2019-12-31.
//  Copyright © 2019 DZN. All rights reserved.
//

import UIKit
import EmptyDataSet
import SnapKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension ViewController: EmptyDataSetSource {

    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return nil
    }

    func tintColorForEmptyDataSet(scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func backgroundColorForEmptyDataSet(scrollView: UIScrollView) -> UIColor? {
        return nil
    }
}

extension ViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetDidUpdateState(_ scrollView: UIScrollView, state: EmptyDataSetState) {

    }
}
