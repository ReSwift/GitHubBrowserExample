//
//  AuthenticationState.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import OctoKit

struct AuthenticationState {
    var oAuthConfig: OAuthConfigurationType?
    var oAuthURL: NSURL?
    var loggedInState: LoggedInState
}

enum LoggedInState {
    case NotLoggedIn
    case LoggedIn(TokenConfiguration)
}

protocol OAuthConfigurationType {
    

    func authenticate() -> NSURL?
    func handleOpenURL(url: NSURL, completion: (config: TokenConfiguration) -> Void)
}

extension OAuthConfiguration: OAuthConfigurationType { }
