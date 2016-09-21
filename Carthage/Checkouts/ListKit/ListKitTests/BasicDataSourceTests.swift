//
//  ListKitTests.swift
//  ListKitTests
//
//  Created by Benjamin Encz on 2/19/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import XCTest
import UIKit
import ListKit

class CustomTableViewCell: UITableViewCell, ListKitCellProtocol {

  var model: String? {
    didSet {
      self.textLabel!.text = model
    }
  }

}

class BasicDataSourceTests: XCTestCase {
  
    func testRowCount() {
      var array: [String]
      array = ["Yay", "Test", "Nothing"]
    
      let source: ArrayDataSource<CustomTableViewCell, String> = ArrayDataSource(array: array, cellType: CustomTableViewCell.self)
      
      let rows = source.tableView(UITableView(), numberOfRowsInSection: 0)
      XCTAssertEqual(array.count, rows)
    }
  
    func testCell() {
      var array: [String]
      array = ["Yay", "Test", "Nothing"]
      let source: ArrayDataSource<CustomTableViewCell, String> = ArrayDataSource(array: array, cellType: CustomTableViewCell.self)
      let cell = source.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0))
      
      XCTAssertEqual(cell.textLabel!.text, "Yay")
    }
  
}
