//
//  DataSource.swift
//  ListKitDemo
//
//  Created by Benjamin Encz on 2/19/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import Foundation
import UIKit

/// A `UITableViewCell` adopting this type can be used together
/// with the `ArrayDataSource` class.
public protocol ListKitCellProtocol {
  associatedtype CellType
  
  /// Stores the content that is represented within the cell.
  /// Types adopting this protocol should update the UI when this
  /// property is set
  var model: CellType? {get set}
}

/// Implements the `UITableViewDataSource` protocol. Needs to be initialized with a custom cell class.
/// Optionally you can provide a NIB file from which the cell should be created. You define the content
/// of the table view by setting the `array` property.
open class ArrayDataSource<U, T> : NSObject, UITableViewDataSource where U:ListKitCellProtocol, U:UITableViewCell, T == U.CellType {

  let cellIdentifier = "arrayDataSourceCell"
  
  fileprivate let nib: UINib?

  /// The content represented in the table view
  open var array: Array<T>
  
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
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return array.count
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var nullableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? U
    
    if nullableCell == nil {
      if let nib = nib {
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        nullableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? U
      } else {
        nullableCell = U(style: .default, reuseIdentifier: cellIdentifier)
      }
    }
    
    // This can only be invalid if `nib` specifies a cell with the wrong class and the first dequeue didn't work
    guard var cell = nullableCell else {
      fatalError("Unable to dequeue valid cell of type \(U.self) from reuse identifier \(cellIdentifier) or create cell of type \(U.self) from nib \(nib)")
    }
    
    cell.model = array[(indexPath as NSIndexPath).row]
    
    return cell
  }
  
}
