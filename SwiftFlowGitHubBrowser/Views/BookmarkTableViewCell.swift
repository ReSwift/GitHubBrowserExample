//
//  BookmarkTableViewCell.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 7/23/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import ListKit
import OctoKit

class BookmarkTableViewCell: UITableViewCell, ListKitCellProtocol {
    var model: Bookmark? {
        didSet {
            if let repository = model?.routeSpecificData as? Repository {
                self.textLabel!.text = repository.name ?? ""
            }
        }
    }
}
