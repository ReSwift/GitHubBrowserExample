//
//  CustomCell.swift
//  ListKitDemo
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Benjamin Encz. All rights reserved.
//

import UIKit
import ListKit

class CityCell: UITableViewCell, ListKitCellProtocol {
  
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var mainLabel: UILabel!
  
    var model: City? {
      didSet {
        if mainLabel != nil {
          configureCell()
        }
      }
    }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureCell()
  }
  
  func configureCell() {
    mainLabel.text = model?.name
    subLabel.text = model?.country
    mainImageView.image = model?.image
  }

}