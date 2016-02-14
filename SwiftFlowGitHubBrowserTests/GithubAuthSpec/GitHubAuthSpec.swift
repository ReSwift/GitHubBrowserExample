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
@testable import SwiftFlowGitHubBrowser

class GitHubAuthSpec: QuickSpec {

    override func spec() {

        describe("When receiving successful login action") {

            var store = Store<State>(reducer: AppReducer(), state: nil)

            beforeEach {

            }

            it("stores the TokenConfiguration in the auth state") {

            }

        }

    }

}