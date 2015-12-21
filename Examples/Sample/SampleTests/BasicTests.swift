//
//  SampleTests.swift
//  SampleTests
//
//  Created by Ignacio Romero on 12/18/15.
//  Copyright © 2015 DZN Labs. All rights reserved.
//

import XCTest

class TVC: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
}

class BasicTests: XCTestCase {
    
    var tvc = TVC()
    
    override func setUp() {
        super.setUp()
        
        tvc.tableView.emptyDataSetSource = tvc
        tvc.tableView.emptyDataSetDelegate = tvc
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAssociatedObjects() {
        
        // DZNEmptyDataSet uses Objective-C associated objects to assign the weak delegate and datasource in a UIScrollView extension.
        // We need to make sure this doesn't break in future Swift releases.
        XCTAssertNotNil(tvc.tableView.emptyDataSetSource)
        XCTAssertNotNil(tvc.tableView.emptyDataSetDelegate)
    }
}
