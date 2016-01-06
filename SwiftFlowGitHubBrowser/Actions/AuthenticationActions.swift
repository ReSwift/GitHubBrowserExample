//
//  AuthenticationActions.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import SwiftFlow
import SwiftFlowRouter

func authenticateUser(_state: StateType, store: Store) -> Action? {
    guard let state = _state as? State else { return nil }
    guard let config = state.authenticationState.oAuthConfig else { return nil }

    let url = config.authenticate()

    if let url = url {
        store.dispatch(SetOAuthURL(oAuthUrl: url))
        store.dispatch(SetRouteAction([loginRoute, oAuthRoute]))
    }

    return nil
}

func handleOpenURL(url: NSURL) -> ActionCreator {
    return { state, store in
        (state as? State)?.authenticationState.oAuthConfig?.handleOpenURL(url) { config in
            store.dispatch(SwiftFlowRouter.SetRouteAction([mainViewRoute]))
        }

        return nil
    }
}

struct SetOAuthURL: Action {
    let oAuthUrl: NSURL
}