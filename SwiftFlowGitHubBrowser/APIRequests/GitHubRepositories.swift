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
import ReSwiftThunk

let fetchGitHubRepositories = Thunk<State> { dispatch, getState in
    guard case let .loggedIn(configuration)? = getState()?.authenticationState.loggedInState else { return }

    _ = Octokit(configuration).repositories { response in
        DispatchQueue.main.async {
            dispatch(SetRepositories(repositories: response))
        }
    }
}
