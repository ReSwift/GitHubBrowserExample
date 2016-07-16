//
//  Routes.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import ReSwiftRouter
import SafariServices

let loginRoute: RouteElementIdentifier = "Login"
let oAuthRoute: RouteElementIdentifier = "OAuth"
let mainViewRoute: RouteElementIdentifier = "Main"
let bookmarkRoute: RouteElementIdentifier = "BookMark"
let repositoryDetailRoute: RouteElementIdentifier = "RepositoryDetail"

let storyboard = UIStoryboard(name: "Main", bundle: nil)

let loginViewControllerIdentifier = "LoginViewController"
let mainViewControllerIdentifier = "MainViewController"
let repositoryDetailControllerIdentifier = "RepositoryDetailViewController"
let bookmarkControllerIdentifier = "BookmarkViewController"

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

    func changeRouteSegment(
        from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler) -> Routable
    {

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

    func pushRouteSegment(
        routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler) -> Routable
    {

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

    func popRouteSegment(
        routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler)
    {
        // TODO: this should technically never be called -> bug in router
        completionHandler()
    }

}

class LoginViewRoutable: Routable {

    let viewController: UIViewController

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func pushRouteSegment(
        routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler) -> Routable
    {
        if routeElementIdentifier == oAuthRoute {
            if let url = store.state.authenticationState.oAuthURL {
                let safariViewController = SFSafariViewController(URL: url)
                self.viewController.presentViewController(safariViewController, animated: true, completion: completionHandler)

                return OAuthRoutable()
            }
        }

        fatalError("Router could not proceed.")
    }

    func popRouteSegment(
        routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler)
    {
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

    func pushRouteSegment(
        routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler) -> Routable {
            if routeElementIdentifier == repositoryDetailRoute {
                let detailViewController = storyboard.instantiateViewControllerWithIdentifier(repositoryDetailControllerIdentifier)
                (self.viewController as! UINavigationController).pushViewController(
                    detailViewController,
                    animated: true,
                    completion: completionHandler
                )

                return RepositoryDetailRoutable()

            } else if routeElementIdentifier == bookmarkRoute {
                let bookmarkViewController = storyboard.instantiateViewControllerWithIdentifier(bookmarkControllerIdentifier)
                (self.viewController as! UINavigationController).pushViewController(
                    bookmarkViewController,
                    animated: true,
                    completion: completionHandler
                )

                return BookmarkRoutable()
            }

        fatalError("Cannot handle this route change!")
    }

    func changeRouteSegment(
        from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler) -> Routable
    {

        if from == bookmarkRoute && to == repositoryDetailRoute {
            (self.viewController as! UINavigationController).popViewController(true) {
                let repositoryDetailViewController = storyboard.instantiateViewControllerWithIdentifier(repositoryDetailControllerIdentifier)
                (self.viewController as! UINavigationController).pushViewController(
                    repositoryDetailViewController,
                    animated: true,
                    completion: completionHandler
                )
            }

            return BookmarkRoutable()
        }

        fatalError("Cannot handle this route change!")
    }

    func popRouteSegment(
        routeElementIdentifier: RouteElementIdentifier,
        animated: Bool,
        completionHandler: RoutingCompletionHandler) {
            // no-op, since this is called when VC is already popped.
            completionHandler()
    }
}

class RepositoryDetailRoutable: Routable {}
class BookmarkRoutable: Routable {}
class OAuthRoutable: Routable {}

extension UINavigationController {

    func pushViewController(viewController: UIViewController,
        animated: Bool, completion: Void -> Void) {

            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            pushViewController(viewController, animated: animated)
            CATransaction.commit()
    }

    func popViewController(animated: Bool, completion: Void -> Void) {

            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            popViewControllerAnimated(animated)
            CATransaction.commit()
    }
    
}

