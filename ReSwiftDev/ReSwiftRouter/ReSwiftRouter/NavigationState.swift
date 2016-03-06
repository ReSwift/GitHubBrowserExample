//
//  NavigationState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import ReSwift

public typealias RouteElementIdentifier = String

public struct RouteHash: Hashable {
    let routeHash: String

    init(route: [RouteElementIdentifier]) {
        self.routeHash = route.joinWithSeparator("/")
    }

    public var hashValue: Int { return self.routeHash.hashValue }
}

public func == (lhs: RouteHash, rhs: RouteHash) -> Bool {
    return lhs.routeHash == rhs.routeHash
}

public struct NavigationState {
    public init() {}

    public var route: [RouteElementIdentifier] = []
    public var routeSpecificState: [RouteHash: Any] = [:]
}

public protocol HasNavigationState {
    var navigationState: NavigationState { get set }
}
