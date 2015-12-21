//
//  ViewController.swift
//  Sample
//
//  Created by Ignacio Romero on 12/18/15.
//  Copyright © 2015 DZN Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var items = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAll")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "assignAll")
        
        self.view.addSubview(self.tableView)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    func deleteAll() {
        items = []
        tableView.reloadData()
    }
    
    func assignAll() {
        items = ["Hello", "Hello", "Hello", "Hello", "Hello", "Hello"]
        tableView.reloadData()
    }
    
    // MARK: - DZNEmptyDataSetSource
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return nil
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView) -> UIColor? {
        return UIColor.redColor()
    }
    
    // MARK: - DZNEmptyDataSetDelegate

    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if let title = items[indexPath.row] as? String {
            cell.textLabel?.text = title
        }
        
        return cell
    }
}