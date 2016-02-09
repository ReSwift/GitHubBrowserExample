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
            authenticationState: authenticationReducer(state?.authenticationState, action: action),
            repositories: repositoriesReducer(state?.repositories, action: action)
        )
    }

}
