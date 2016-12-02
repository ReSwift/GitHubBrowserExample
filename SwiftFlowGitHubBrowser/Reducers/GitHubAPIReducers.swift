//
//  GitHubAPIReducers.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import ReSwift
import OctoKit
import RequestKit

func repositoriesReducer(state: Response<[Repository]>?, action: Action) -> Response<[Repository]>? {
    switch action {
    case let action as SetRepositories:
        return action.repositories
    default:
        return nil
    }
}
