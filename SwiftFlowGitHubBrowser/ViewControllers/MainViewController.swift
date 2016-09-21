//
//  MainViewController.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benjamin Encz on 2/13/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter
import OctoKit
import RequestKit
import ListKit

class MainViewController: UIViewController, StoreSubscriber {

    @IBOutlet var tableView: UITableView!

    var dataSource: ArrayDataSource<RepositoryTableViewCell, Repository>?

    // MARK: View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            state.repositories
        }

        // Kick off request to update list of repositories
        store.dispatch(fetchGitHubRepositories)

        if self.dataSource == nil {
            // If we have no intial data, let's configure it.
            self.dataSource = ArrayDataSource(array: [], cellType: RepositoryTableViewCell.self)
        }

        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }

    // MARK: State Updates

    func newState(state: Response<[Repository]>?) {
        guard let state = state else { return }

        if case let .success(repositories) = state {
            dataSource?.array = repositories
            tableView.reloadData()
        }
    }

    // MARK: Interaction

    @IBAction func bookmarkButtonTapped(_ sender: AnyObject) {
        let newRoute = [mainViewRoute, bookmarkRoute]
        store.dispatch(ReSwiftRouter.SetRouteAction(newRoute))
    }
}

//MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepository = self.dataSource?.array[indexPath.row]
        let newRoute = [mainViewRoute, repositoryDetailRoute]

        let routeAction = ReSwiftRouter.SetRouteAction(newRoute)
        let setDataAction = ReSwiftRouter.SetRouteSpecificData(route: newRoute, data: selectedRepository!)
        store.dispatch(setDataAction)
        store.dispatch(routeAction)
    }

}
