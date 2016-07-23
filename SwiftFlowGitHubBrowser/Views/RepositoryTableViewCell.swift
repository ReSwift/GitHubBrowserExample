//
//  RepositoryDetailCell.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 7/23/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import ListKit
import OctoKit

class RepositoryTableViewCell: UITableViewCell, ListKitCellProtocol {
    var model: Repository? {
        didSet {
            self.textLabel!.text = model?.name ?? ""
        }
    }
}
