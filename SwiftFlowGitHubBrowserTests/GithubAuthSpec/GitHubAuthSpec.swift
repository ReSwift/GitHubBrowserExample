//
//  GitHubAuthSpec.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benjamin Encz on 2/13/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Quick
import Nimble
import ReSwift
import OctoKit
import ReSwiftRouter
import ReSwiftThunk
@testable import SwiftFlowGitHubBrowser

class GitHubAuthSpec: QuickSpec {

    override func spec() {

        describe("When receiving a success OAuth URL callback ") {

            var store: Store<State>!

            beforeEach {
                let fakeOAuth = FakeOAuthConfiguration(injectedTokenConfiguration: TokenConfiguration("Token"))
                let state = State(
                    navigationState: NavigationState(),
                    authenticationState: AuthenticationState(
                        oAuthConfig: fakeOAuth,
                        oAuthURL: nil,
                        loggedInState: .notLoggedIn),
                    repositories: nil, bookmarks: [])
                let thunkMiddleware: Middleware<State> = createThunksMiddleware()
                store = Store<State>(reducer: appReducer, state: state, middleware: [thunkMiddleware])

                let oAuthCallbackURL = URL(string: "swiftflowgithub://success")!

                store.dispatch(handleOpenURL(url: oAuthCallbackURL))
            }

            it("updates the route to the main view") {
                expect(store.state.navigationState.route).toEventually(equal([mainViewRoute]))
            }

            it("updates the state to reflect that user is logged in") {
                expect { () -> TokenConfiguration? in
                    let tokenConfiguration: TokenConfiguration?

                    if case let .loggedIn(config) = store.state.authenticationState.loggedInState {
                        tokenConfiguration = config
                    } else {
                        tokenConfiguration = nil
                    }

                    return tokenConfiguration
                }.toEventuallyNot(beNil())
            }

        }

        describe("When receiving successful login action") {

            let store = Store<State>(reducer: appReducer, state: nil)

            beforeEach {
                let tokenConfiguration = TokenConfiguration("Token")
                let loggedInAction = UpdateLoggedInState(loggedInState: .loggedIn(tokenConfiguration))
                store.dispatch(loggedInAction)
            }

            it("stores the TokenConfiguration in the auth state") {
                let tokenConfiguration: TokenConfiguration?

                if case let .loggedIn(config) = store.state.authenticationState.loggedInState {
                    tokenConfiguration = config
                } else {
                    tokenConfiguration = nil
                }

                expect(tokenConfiguration?.accessToken).to(equal("Token"))
            }

        }

    }

}

struct FakeOAuthConfiguration: OAuthConfigurationType {
    var injectedTokenConfiguration: TokenConfiguration

    func authenticate() -> URL? {
        return nil
    }

    func handleOpenURL(openUrl: URL, completion: @escaping (TokenConfiguration) -> Void) {
        completion(injectedTokenConfiguration)
    }
}
