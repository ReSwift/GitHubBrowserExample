//
//  BookmarkActions.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 3/8/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter

struct CreateBookmark: Action {
    let route: [RouteElementIdentifier]
    let routeSpecificData: Any?
}
