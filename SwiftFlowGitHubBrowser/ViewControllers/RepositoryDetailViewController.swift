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

    private var _originalNavigationBarDelegate: UINavigationBarDelegate?

    // MARK: View Lifecycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            let currentRepository: Repository? = state.navigationState.getRouteSpecificState(
                state.navigationState.route
            )

            let isCurrentRepositoryBookmarked = currentRepository.map {
                BookmarkService.isRepositoryBookmarked(state, currentRepository: $0)
            } ?? false

            return (
                currentRepository,
                isCurrentRepositoryBookmarked
            )
        }

        self._originalNavigationBarDelegate = self.navigationController?.navigationBar.delegate
        self.navigationController?.navigationBar.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

    // MARK: State Updates

    func newState(state: (selectedRepository: Repository?, isBookmarked: Bool)) {
        // Only perform repository related updates if the repository actually changed
        if self.repository?.gitURL != state.selectedRepository?.gitURL {
            self.repository = state.selectedRepository
            self.title = state.selectedRepository?.name ?? ""

            if let url = state.selectedRepository?.htmlURL.flatMap({NSURL.init(string: $0)}) {
                let request = NSURLRequest(URL: url)
                self.webView.loadRequest(request)
            }
        }

        self.bookmarkButton.enabled = state.isBookmarked
    }

    // MARK: Interaction

    @IBAction func bookmarkButtonTapped(sender: AnyObject) {
        store.dispatch(
            CreateBookmark(
                route: [mainViewRoute, repositoryDetailRoute],
                routeSpecificData: self.repository
            )
        )
    }
}

extension RepositoryDetailViewController: UINavigationBarDelegate {

    func navigationBar(
        navigationBar: UINavigationBar,
        shouldPopItem item: UINavigationItem) -> Bool
    {
        self.navigationController?.navigationBar.delegate = self._originalNavigationBarDelegate

        store.dispatch(SetRouteAction([mainViewRoute]))

        return true
    }

}
