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
@testable import SwiftFlowGitHubBrowser

class GitHubAuthSpec: QuickSpec {

    override func spec() {

        describe("When receiving successful login action") {

            let store = Store<State>(reducer: AppReducer(), state: nil)

            beforeEach {
                let tokenConfiguration = TokenConfiguration("Token")
                let loggedInAction = UpdateLoggedInState(loggedInState: .LoggedIn(tokenConfiguration))
                store.dispatch(loggedInAction)
            }

            it("stores the TokenConfiguration in the auth state") {
                let tokenConfiguration: TokenConfiguration?

                if case let .LoggedIn(config) = store.state.authenticationState.loggedInState {
                    tokenConfiguration = config
                } else {
                    tokenConfiguration = nil
                }

                expect(tokenConfiguration?.accessToken).to(equal("Token"))
            }

        }

    }

}