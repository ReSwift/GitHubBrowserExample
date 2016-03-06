//
//  MainViewController.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benjamin Encz on 2/13/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import UIKit
import ReSwift
import OctoKit
import RequestKit

class MainViewController: UIViewController, StoreSubscriber {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            state.repositories
        }

        store.dispatch(fetchGitHubRepositories)
    }

    override func viewWillDisappear(animated: Bool) {
        store.unsubscribe(self)
    }

    func newState(state: Response<[Repository]>?) {
        print(state)
    }

}
