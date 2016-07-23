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

    @IBOutlet var webView: UIWebView!
    @IBOutlet var bookmarkButton: UIBarButtonItem!

    var repository: Repository?

    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            // Required to update the route, when this VC was dismissed through back button from
            // NavigationController, since we can't intercept the back button
            if store.state.navigationState.route == [mainViewRoute, repositoryDetailRoute] {
                store.dispatch(SetRouteAction([mainViewRoute]))
            }
        }
    }

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
    }

    func newState(state: (selectedRepository: Repository?, bookmarks: [Bookmark])) {
        // Only perform repository related updates if the repository actually changed
        if self.repository?.gitURL != state.selectedRepository?.gitURL {
            self.repository = state.selectedRepository
            self.title = state.selectedRepository?.name ?? ""

            if let url = state.selectedRepository?.htmlURL.flatMap({NSURL.init(string: $0)}) {
                let request = NSURLRequest(URL: url)
                self.webView.loadRequest(request)
            }
        }

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
