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
import ReSwiftRouter

class RepositoryDetailViewController: UIViewController, StoreSubscriber {

    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var bookmarkButton: UIBarButtonItem!

    var repository: Repository?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            (
                state.navigationState.getRouteSpecificState(state.navigationState.route),
                state.bookmarks
            )
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)

        // Required to update the route, when this VC was dismissed through back button from
        // NavigationController, since we can't intercept the back button
        if store.state.navigationState.route == [mainViewRoute, repositoryDetailRoute] {
            store.dispatch(SetRouteAction([mainViewRoute]))
        }
    }

    func newState(state: (selectedRepository: Repository?, bookmarks: [Bookmark])) {
        self.repository = state.selectedRepository
        self.mainLabel.text = state.selectedRepository?.name ?? ""
        self.title = state.selectedRepository?.name ?? ""

        let bookmarkActive = !state.bookmarks.contains { route, data in
            guard let repository = data as? Repository else { return false }

            return RouteHash(route: route) == RouteHash(route: [mainViewRoute, repositoryDetailRoute])
                && repository.name == self.repository?.name
        }

        self.bookmarkButton.enabled = bookmarkActive
    }

    @IBAction func bookmarkButtonTapped(sender: AnyObject) {
        store.dispatch(
            CreateBookmark(
                route: [mainViewRoute, repositoryDetailRoute],
                routeSpecificData: self.repository
            )
        )
    }
}
