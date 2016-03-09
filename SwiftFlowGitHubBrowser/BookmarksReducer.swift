//
//  BookmarksReducer.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 3/8/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter

func bookmarksReducer(state: [Bookmark]?, action: Action) -> [Bookmark] {
    var state = state ?? []

    switch action {
    case let action as CreateBookmark:
        let bookmark = (route: action.route, routeSpecificData: action.routeSpecificData)
        state.append(bookmark)
        return state
    default:
        return state
    }
}
