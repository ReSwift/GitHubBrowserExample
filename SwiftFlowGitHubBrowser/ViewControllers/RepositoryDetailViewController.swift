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

    // MARK: View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            let currentRepository: Repository? = state.navigationState.getRouteSpecificState(
                state.navigationState.route
            )

            let isCurrentRepositoryBookmarked = currentRepository.map {
                BookmarkService.isRepositoryBookmarked(state: state, currentRepository: $0)
            } ?? false

            return (
                currentRepository,
                isCurrentRepositoryBookmarked
            )
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            // Required to update the route, when this VC was dismissed through back button from
            // NavigationController, since we can't intercept the back button
            if store.state.navigationState.route == [mainViewRoute, repositoryDetailRoute] {
                store.dispatch(SetRouteAction([mainViewRoute]))
            }
        }
    }

    // MARK: State Updates

    func newState(state: (selectedRepository: Repository?, isBookmarked: Bool)) {
        // Only perform repository related updates if the repository actually changed
        if self.repository?.gitURL != state.selectedRepository?.gitURL {
            self.repository = state.selectedRepository
            self.title = state.selectedRepository?.name ?? ""

            if let url = state.selectedRepository?.htmlURL.flatMap({URL.init(string: $0)}) {
                let request = URLRequest(url: url)
                self.webView.loadRequest(request)
            }
        }

        self.bookmarkButton.isEnabled = state.isBookmarked
    }

    // MARK: Interaction

    @IBAction func bookmarkButtonTapped(_ sender: AnyObject) {
        store.dispatch(
            CreateBookmark(
                route: [mainViewRoute, repositoryDetailRoute],
                routeSpecificData: self.repository
            )
        )
    }
}
