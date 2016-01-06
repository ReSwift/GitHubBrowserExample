//
//  AuthenticationState.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import OctoKit

struct AuthenticationState {
    var oAuthConfig: OAuthConfiguration?
    var oAuthURL: NSURL?
    var loggedInState: LoggedInState
}

enum LoggedInState {
    case NotLoggedIn
    case LoggedIn(TokenConfiguration)
}
