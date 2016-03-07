//
//  RepositoryDetailViewController.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benjamin Encz on 3/6/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import UIKit
import OctoKit
import ReSwift

class RepositoryDetailViewController: UIViewController, StoreSubscriber {

    @IBOutlet var mainLabel: UILabel!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            return state.navigationState.getRouteSpecificState(state.navigationState.route)
        }
    }

    func newState(selectedRepository: Repository?) {
        self.mainLabel.text = selectedRepository?.name ?? ""
    }

}
