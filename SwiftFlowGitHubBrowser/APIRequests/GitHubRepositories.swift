//
//  GitHubRepositories.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benjamin Encz on 3/6/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import OctoKit
import ReSwift

func fetchGitHubRepositories(state: State, store: Store<State>) -> Action? {
    guard case let .loggedIn(configuration) = state.authenticationState.loggedInState  else { return nil }

    Octokit(configuration).repositories { response in
        DispatchQueue.main.async {
            store.dispatch(SetRepositories(repositories: response))
        }
    }

    return nil
}
