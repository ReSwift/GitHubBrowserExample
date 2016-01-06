//
//  AppReducer.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import SwiftFlow
import SwiftFlowRouter

struct AppReducer: Reducer {

    func handleAction(state: State?, action: Action) -> State {
        return State(
            navigationState: NavigationReducer().handleAction(state?.navigationState, action: action),
            authenticationState: authenticationReducer(state?.authenticationState, action: action),
            repositories: repositoriesReducer(state?.repositories, action: action)
        )
    }

}