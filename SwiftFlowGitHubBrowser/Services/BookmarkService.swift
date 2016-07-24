//
//  BookmarkService.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 7/23/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import OctoKit
import ReSwiftRouter

class BookmarkService {

    static func isRepositoryBookmarked(state: State, currentRepository: Repository) -> Bool {
        let bookmarkActive = !state.bookmarks.contains { route, data in
            guard let repository = data as? Repository else { return false }

            return RouteHash(route: route) == RouteHash(route: [mainViewRoute, repositoryDetailRoute])
                && repository.name == currentRepository.name
        }
        
        return bookmarkActive
    }
    
}
