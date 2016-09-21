//
//  CityViewController.swift
//  ListKitDemo
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Benjamin Encz. All rights reserved.
//

import UIKit
import ListKit

class CityViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  
  var dataSource: ArrayDataSource<CityCell, City>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up cities
    let city1 = City(
      name: "Stuttgart",
      country: "Germany",
      image: UIImage(named: "stuttgart.jpg")!
    )
    
    let city2 = City(
      name: "San Francisco",
      country: "USA",
      image: UIImage(named: "sf.jpg")!
    )
    
    let cities = [city1, city2]
    
    let nib = UINib(nibName: "CityCell", bundle: Bundle.main)

    dataSource = ArrayDataSource(array: cities, cellType: CityCell.self, nib: nib)
    tableView.dataSource = dataSource
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
  
  @IBAction func addButtonTapped(_ sender: AnyObject) {
    let additionalCity = City(
      name: "Tokyo",
      country: "Japan",
      image: UIImage(named: "tokyo.jpg")!
    )
    
    dataSource?.array.append(additionalCity)
    tableView.reloadData()
  }
  
}
