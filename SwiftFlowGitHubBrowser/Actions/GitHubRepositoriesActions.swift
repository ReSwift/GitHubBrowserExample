//
//  GitHubRepositoriesActions.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benjamin Encz on 3/6/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import ReSwift
import OctoKit
import RequestKit

struct SetRepositories: Action {
    let repositories: Response<[Repository]>
}
