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

class RepositoryTableViewCell: UITableViewCell, ListKitCellProtocol {
    var model: Repository? {
        didSet {
            self.textLabel!.text = model?.name ?? ""
        }
    }
}

class MainViewController: UIViewController, StoreSubscriber {

    @IBOutlet var tableView: UITableView!

    var dataSource: ArrayDataSource<RepositoryTableViewCell, Repository>?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            state.repositories
        }

        store.dispatch(fetchGitHubRepositories)
        self.dataSource = ArrayDataSource(array: [], cellType: RepositoryTableViewCell.self)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }

    func newState(state: Response<[Repository]>?) {
        guard let state = state else { return }

        if case let .Success(repositories) = state {
            dataSource?.array = repositories
            tableView.reloadData()
        }
    }

    @IBAction func bookmarkButtonTapped(sender: AnyObject) {
        let newRoute = [mainViewRoute, bookmarkRoute]
        store.dispatch(ReSwiftRouter.SetRouteAction(newRoute))
    }
}

//MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRepository = self.dataSource?.array[indexPath.row]
        let newRoute = [mainViewRoute, repositoryDetailRoute]

        let routeAction = ReSwiftRouter.SetRouteAction(newRoute)
        let setDataAction = ReSwiftRouter.SetRouteSpecificData(route: newRoute, data: selectedRepository!)
        store.dispatch(setDataAction)
        store.dispatch(routeAction)
    }

}
