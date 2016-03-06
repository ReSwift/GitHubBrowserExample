//
//  DataSource.swift
//  ListKitDemo
//
//  Created by Benjamin Encz on 2/19/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import Foundation
import UIKit

/// A `UITableViewCell` adopoting this type can be used together
/// with the `ArrayDataSource` class.
public protocol ListKitCellProtocol {
  typealias CellType
  
  /// Stores the content that is represented within the cell.
  /// Types adopting this protocol should update the UI when this
  /// property is set
  var model: CellType? {get set}
}

/// Implements the `UITableViewDataSource` protocol. Needs to be initialized with a custom cell class.
/// Optionally you can provide a NIB file from which the cell should be created. You define the content
/// of the table view by setting the `array` property.
public class ArrayDataSource<U, T where U:ListKitCellProtocol, U:UITableViewCell, T == U.CellType> : NSObject, UITableViewDataSource {

  let cellIdentifier = "arrayDataSourceCell"
  
  private let nib: UINib?

  /// The content represented in the table view
  public var array: Array<T>
  
  /// Initialize with a custom cell type
  public init (array:Array<T> = [], cellType: U.Type) {
    self.array = array
    self.nib = nil
  }
  
  /// Initialize with a custom cell type and a NIB file from which 
  /// the cell should be loaded
  public init (array:Array<T> = [], cellType: U.Type, nib: UINib) {
    self.array = array
    self.nib = nib
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return array.count
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! U?
    
    if var cell = cell {
      cell.model = array[indexPath.row]
    } else {
      if let nib = nib {
        // if nib was registered, load from there
        tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? U
        cell!.model = array[indexPath.row]
      } else {
        // else, create cell programatically
        cell = U(style: .Default, reuseIdentifier: cellIdentifier)
        cell!.model = array[indexPath.row]
      }
    }
    
    return cell!
  }
  
}