//
//  AuthenticationState.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import OctoKit
import RequestKit

struct AuthenticationState {
    var oAuthConfig: OAuthConfigurationType?
    var oAuthURL: URL?
    var loggedInState: LoggedInState
}

enum LoggedInState {
    case notLoggedIn
    case loggedIn(TokenConfiguration)
}

protocol OAuthConfigurationType {

    func authenticate() -> URL?
    // We're using first argument name in order to disambiguate between this protocol method and
    // the implementation on `OAuthConfiguration`.
    func handleOpenURL(openUrl: URL, completion: @escaping (TokenConfiguration) -> Void)
}

extension OAuthConfiguration: OAuthConfigurationType {
    // Since `handleOpenURL` on `OAuthConfiguration` uses a default argument, we need to trampoline
    // through this protocol implementation before calling it. 
    internal func handleOpenURL(openUrl: URL, completion: @escaping (TokenConfiguration) -> Void) {
        self.handleOpenURL(url: openUrl, completion: completion)
    }
 }
