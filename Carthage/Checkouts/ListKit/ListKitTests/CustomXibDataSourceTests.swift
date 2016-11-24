//
//  CustomXibDataSourceTests.swift
//  ListKitDemo
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Benjamin Encz. All rights reserved.
//

import XCTest
import UIKit
import ListKit

class CustomXibDataSourceTests: XCTestCase {
  
  var array: [City]!
  
  override func setUp() {
    let city1 = City(
      name: "Stuttgart",
      country: "Germany",
      image: imageInTestBundle("stuttgart", type:"jpg")
    )
    
    let city2 = City(
      name: "San Francisco",
      country: "USA",
      image: imageInTestBundle("sf", type:"jpg")
    )
    
    array = [city1, city2]
  }
  
  func testRowCount() {
    let source = ArrayDataSource(array: array, cellType: CityCell.self)
    
    let rows = source.tableView(UITableView(), numberOfRowsInSection: 0)
    XCTAssertEqual(array.count, rows)
  }
  
  func testCell() {
    let bundle = Bundle(for: CustomXibDataSourceTests.self)
    let nib = UINib(nibName: "CityCell", bundle: bundle)
    let source = ArrayDataSource(array: array, cellType: CityCell.self, nib: nib)
    
    let cell = source.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0)) as! CityCell
    
    XCTAssertEqual(cell.mainLabel.text!, array[0].name)
  }
  
  func testAddRow() {
    let bundle = Bundle(for: CustomXibDataSourceTests.self)
    let nib = UINib(nibName: "CityCell", bundle: bundle)
    let source = ArrayDataSource(array: array, cellType: CityCell.self, nib: nib)
    
    let additionalCity = City(
      name: "Tokyo",
      country: "Japan",
      image: imageInTestBundle("tokyo", type:"jpg")
    )

    array.append(additionalCity)
    
    source.array = array

    let rows = source.tableView(UITableView(), numberOfRowsInSection: 0)
    XCTAssertEqual(array.count, rows)
  }
  
  func imageInTestBundle(_ name: String, type: String) -> UIImage {
    let bundle = Bundle(for: CustomXibDataSourceTests.self)
    let path = bundle.path(forResource: name, ofType: type)
    let image = UIImage(contentsOfFile: path!)
    
    return image!
  }
  
}
