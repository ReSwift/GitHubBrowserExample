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

func bookmarksReducer(state: [(route: [RouteElementIdentifier], routeSpecificData: Any)]?, action: Action) -> [(route: [RouteElementIdentifier], routeSpecificData: Any)] {
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
