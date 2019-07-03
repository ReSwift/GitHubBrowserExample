//
//  AuthenticationActions.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import ReSwift
import ReSwiftRouter
import ReSwiftThunk
import OctoKit

let authenticateUser = Thunk<State> { dispatch, getStat in
    guard let config = getStat()?.authenticationState.oAuthConfig else { return }

    let url = config.authenticate()

    if let url = url {
        dispatch(SetOAuthURL(oAuthUrl: url))
        dispatch(SetRouteAction([loginRoute, oAuthRoute]))
    }
}

func handleOpenURL(url: URL) -> Thunk<State> {
    return Thunk<State> { dispatch, getState in
        guard let config = getState()?.authenticationState.oAuthConfig else { return }

        config.handleOpenURL(openUrl: url) { (config: TokenConfiguration) in
            DispatchQueue.main.async {
                AuthenticationService().saveAuthenticationData(config)

                dispatch(UpdateLoggedInState(loggedInState: .loggedIn(config)))
                // Switch to the Main View Route
                dispatch(ReSwiftRouter.SetRouteAction([mainViewRoute]))
            }
        }
    }
}

struct SetOAuthURL: Action {
    let oAuthUrl: URL
}

struct UpdateLoggedInState: Action {
    let loggedInState: LoggedInState
}
