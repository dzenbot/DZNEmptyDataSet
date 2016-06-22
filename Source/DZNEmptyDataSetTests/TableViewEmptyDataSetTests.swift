//
//  TableViewEmptyDataSetTests.swift
//  DZNEmptyDataSet
//
//  Created by Rene on 22/06/16.
//  Copyright © 2016 KenziTrader. All rights reserved.
//

import XCTest
@testable import DZNEmptyDataSet

class TableViewEmptyDataSetTests: XCTestCase {
    // MARK: Subject under test
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    // MARK: Test doubles
    
    class TableViewWithEmptyDataSet: UITableView, UITableViewDataSource, DZNEmptyDataSetSource
    {
        var items = [String]()
        
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame: frame, style: style)
            dataSource = self
            emptyDataSetSource = self
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("\(self.dynamicType)\(#function) count=\(items.count)")
            return items.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = UITableViewCell()
            
            return cell
        }
        
        func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
            let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(27), NSForegroundColorAttributeName: UIColor.lightGrayColor()]
            
            return NSAttributedString.init(string: "No items found", attributes: attributes)
        }
        
        func refresh() {
            items.append("Hello")
        }
        
        func deleteAll() {
            items = []
        }
        
    }
    
    class CollectionViewWithEmptyDataSet: UICollectionView, UICollectionViewDataSource, DZNEmptyDataSetSource
    {
        var items = [String]()
        
        override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
            super.init(frame: frame, collectionViewLayout: layout)
            dataSource = self
            emptyDataSetSource = self
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print("\(self.dynamicType)\(#function) count=\(items.count)")
            return items.count
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
        {
            let cell = UICollectionViewCell()
            
            return cell
        }
        
        func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
            let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(27), NSForegroundColorAttributeName: UIColor.lightGrayColor()]
            
            return NSAttributedString.init(string: "No items found", attributes: attributes)
        }
        
        func refresh() {
            items.append("Hello")
        }
        
        func deleteAll() {
            items = []
        }
        
    }
    
    // MARK: Tests
    
    func testTableViewWithEmptyDataSetHasPlaceholderVisible()
    {
        // Given
        let tableView = TableViewWithEmptyDataSet()
        tableView.deleteAll()
        
        // When
        tableView.reloadEmptyDataSet()
        
        // Then
        XCTAssert(tableView.isEmptyDataSetVisible, "With an empty table the EmptyDataSetView should be visible")
    }
    
    func testTableViewWithDataSetHasNoPlaceholderVisible()
    {
        // Given
        let tableView = TableViewWithEmptyDataSet()
        
        // When
        tableView.beginUpdates()
        tableView.refresh()
        tableView.endUpdates()
        
        // Then
        XCTAssert(!tableView.isEmptyDataSetVisible, "With data in the table the EmptyDataSetView should not be visible")
    }
    
    func testCollectionViewWithEmptyDataSetHasPlaceholderVisible()
    {
        // Given
        let layout = UICollectionViewFlowLayout()
        let frame = CGRectZero
        let collectionView = CollectionViewWithEmptyDataSet(frame: frame, collectionViewLayout: layout)
        collectionView.deleteAll()
        
        // When
        collectionView.reloadEmptyDataSet()
        
        // Then
        XCTAssert(collectionView.isEmptyDataSetVisible, "With an empty table the EmptyDataSetView should be visible")
    }
    
}
