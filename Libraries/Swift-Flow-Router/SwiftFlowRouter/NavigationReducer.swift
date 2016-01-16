//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import SwiftFlow

public struct NavigationReducer: Reducer {

    public init() {}

    public func handleAction(_state: NavigationState?, action: Action) -> NavigationState {
        guard let state = _state else { return NavigationState() }

        switch action {
        case let action as SetRouteAction:
            return setRoute(state, route: action.route)
        default:
            break
        }

        return state
    }

    func setRoute(var state: NavigationState, route: [RouteElementIdentifier]) -> NavigationState {
        state.route = route

        return state
    }

}