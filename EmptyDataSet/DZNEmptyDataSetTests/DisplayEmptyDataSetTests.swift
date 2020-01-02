//
//  DisplayEmptyDataSetTests.swift
//  DZNEmptyDataSetTests
//
//  Created by Ignacio Romero Zurbuchen on 2020-01-01.
//  Copyright © 2020 DZN. All rights reserved.
//

import XCTest
import EmptyDataSet

class DisplayEmptyDataSetTests: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

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
        XCTAssert(tableView.isEmptyDataSetVisible, "With data in the table the EmptyDataSetView should not be visible")
    }

    func testCollectionViewWithEmptyDataSetHasPlaceholderVisible()
    {
        // Given
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect.zero
        let collectionView = CollectionViewWithEmptyDataSet(frame: frame, collectionViewLayout: layout)
        collectionView.deleteAll()

        // When
        collectionView.reloadEmptyDataSet()

        // Then
        XCTAssert(collectionView.isEmptyDataSetVisible, "With an empty table the EmptyDataSetView should be visible")
    }
}

class TableViewWithEmptyDataSet: UITableView, UITableViewDataSource, EmptyDataSetSource
{
    var items = [String]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        dataSource = self
        emptyDataSetSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        return NSAttributedString.init(string: "No items found", attributes: attributes)
    }

    func refresh() {
        items.append("Hello")
    }

    func deleteAll() {
        items = []
    }

}

class CollectionViewWithEmptyDataSet: UICollectionView, UICollectionViewDataSource, EmptyDataSetSource
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        return NSAttributedString.init(string: "No items found", attributes: attributes)
    }

    func refresh() {
        items.append("Hello")
    }

    func deleteAll() {
        items = []
    }
}
