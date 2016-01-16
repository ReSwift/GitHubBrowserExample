//
//  Routes.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import SwiftFlowRouter
import SafariServices

let loginRoute: RouteElementIdentifier = "Login"
let oAuthRoute: RouteElementIdentifier = "OAuth"
let mainViewRoute: RouteElementIdentifier = "Main"

let storyboard = UIStoryboard(name: "Main", bundle: nil)

let loginViewControllerIdentifier = "LoginViewController"
let mainViewControllerIdentifier = "MainViewController"

class RootRoutable: Routable {

    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func setToLoginViewController() -> Routable {
        self.window.rootViewController = storyboard.instantiateViewControllerWithIdentifier(loginViewControllerIdentifier)

        return LoginViewRoutable(self.window.rootViewController!)
    }

    func setToMainViewController() -> Routable {
        self.window.rootViewController = storyboard.instantiateViewControllerWithIdentifier(mainViewControllerIdentifier)

        return MainViewRoutable(self.window.rootViewController!)
    }

    func changeRouteSegment(from: RouteElementIdentifier, to: RouteElementIdentifier, completionHandler: RoutingCompletionHandler) -> Routable {

        if to == loginRoute {
            completionHandler()
            return self.setToLoginViewController()
        } else if to == mainViewRoute {
            completionHandler()
            return self.setToMainViewController()
        } else {
            fatalError("Route not supported!")
        }
    }

    func pushRouteSegment(routeElementIdentifier: RouteElementIdentifier, completionHandler: RoutingCompletionHandler) -> Routable {

        if routeElementIdentifier == loginRoute {
            completionHandler()
            return self.setToLoginViewController()
        } else if routeElementIdentifier == mainViewRoute {
            completionHandler()
            return self.setToMainViewController()
        } else {
            fatalError("Route not supported!")
        }
    }

    func popRouteSegment(routeElementIdentifier: RouteElementIdentifier, completionHandler: RoutingCompletionHandler) {
        // TODO: this should technically never be called -> bug in router
        completionHandler()
    }

}

class LoginViewRoutable: Routable {

    let viewController: UIViewController

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func pushRouteSegment(routeElementIdentifier: RouteElementIdentifier, completionHandler: RoutingCompletionHandler) -> Routable {
        if routeElementIdentifier == oAuthRoute {
            if let url = (store.appState as? State)?.authenticationState.oAuthURL {
                let safariViewController = SFSafariViewController(URL: url)
                self.viewController.presentViewController(safariViewController, animated: true, completion: completionHandler)

                return OAuthRoutable()
            }
        }

        fatalError("Router could not proceed.")
    }

    func popRouteSegment(routeElementIdentifier: RouteElementIdentifier, completionHandler: RoutingCompletionHandler) {
        if routeElementIdentifier == oAuthRoute {
            self.viewController.dismissViewControllerAnimated(true, completion: completionHandler)
        }
    }

}

class MainViewRoutable: Routable {

    let viewController: UIViewController

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
}

class OAuthRoutable: Routable {}

