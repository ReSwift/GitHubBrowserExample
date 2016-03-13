//
//  BookmarkViewController.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 3/12/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter
import OctoKit
import ListKit

class BookmarkTableViewCell: UITableViewCell, ListKitCellProtocol {
    var model: Bookmark? {
        didSet {
            if let repository = model?.routeSpecificData as? Repository {
                self.textLabel!.text = repository.name ?? ""
            }
        }
    }
}

class BookmarkViewController: UIViewController, StoreSubscriber {

    @IBOutlet var tableView: UITableView!

    var dataSource: ArrayDataSource<BookmarkTableViewCell, Bookmark>?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.dataSource = ArrayDataSource(array: [], cellType: BookmarkTableViewCell.self)
        tableView.dataSource = dataSource
        tableView.delegate = self

        // Subscribe after other setup is complete
        store.subscribe(self) { state in
            state.bookmarks
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)

        // Required to update the route, when this VC was dismissed through back button from
        // NavigationController, since we can't intercept the back button
        if store.state.navigationState.route == [mainViewRoute, bookmarkRoute] {
            store.dispatch(SetRouteAction([mainViewRoute]))
        }
    }

    func newState(state: [Bookmark]) {
        dataSource?.array = state
        tableView.reloadData()
    }

}

//MARK: UITableViewDelegate

extension BookmarkViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedBookmark = self.dataSource!.array[indexPath.row]
        let routeAction = ReSwiftRouter.SetRouteAction(selectedBookmark.route)
        let setDataAction = ReSwiftRouter.SetRouteSpecificData(route:
            selectedBookmark.route,
            data: selectedBookmark.routeSpecificData)

        store.dispatch(setDataAction)
        store.dispatch(routeAction)
    }
    
}