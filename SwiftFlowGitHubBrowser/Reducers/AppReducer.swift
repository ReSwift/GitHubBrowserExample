//
//  AppReducer.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import ReSwift
import ReSwiftRouter

struct AppReducer: Reducer {

    func handleAction(action: Action, state: State?) -> State {
        return State(
            navigationState: NavigationReducer.handleAction(action, state: state?.navigationState),
            authenticationState: authenticationReducer(state: state?.authenticationState, action: action),
            repositories: repositoriesReducer(state: state?.repositories, action: action),
            bookmarks: bookmarksReducer(state: state?.bookmarks, action: action)
        )
    }

}
