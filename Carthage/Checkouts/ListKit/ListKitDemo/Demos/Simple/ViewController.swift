//
//  ViewController.swift
//  ListKitDemo
//
//  Created by Benjamin Encz on 2/19/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit
import ListKit

class CustomTableViewCell: UITableViewCell, ListKitCellProtocol {
  var model: String? {
    didSet {
      self.textLabel!.text = model as String?
    }
  }
}

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var dataSource: ArrayDataSource<CustomTableViewCell, String>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    dataSource = ArrayDataSource(array: ["Test", "Another One", "OK"], cellType: CustomTableViewCell.self)
    tableView.dataSource = dataSource
  }

}