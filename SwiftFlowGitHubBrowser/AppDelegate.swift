//
//  AppDelegate.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import UIKit
import OctoKit
import ReSwift
import ReSwiftRouter

var store = Store<State>(reducer: AppReducer(), state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: Router<State>!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        /* 
        Set a dummy VC to satisfy UIKit
        Router will set correct VC throug async call which means
        window would not have rootVC at completion of this method
        which causes a crash. 
        */
        window?.rootViewController = UIViewController()

        let rootRoutable = RootRoutable(window: window!)

        router = Router(store: store, rootRoutable: rootRoutable) { state in
            return state.navigationState
        }

        if case .LoggedIn(_) = store.state.authenticationState.loggedInState {
            store.dispatch(ReSwiftRouter.SetRouteAction([mainViewRoute]))
        } else {
            store.dispatch(ReSwiftRouter.SetRouteAction([loginRoute]))
        }

        window?.makeKeyAndVisible()

        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        store.dispatch(handleOpenURL(url))

        return false
    }

}
