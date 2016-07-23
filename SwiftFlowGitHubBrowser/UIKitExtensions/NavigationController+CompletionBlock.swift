//
//  NavigationController+CompletionBlock.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 7/23/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import UIKit

// Extension that provides completion blocks for push/pop on navigation controllers.
// Thanks to: http://stackoverflow.com/questions/9906966/completion-handler-for-uinavigationcontroller-pushviewcontrolleranimated
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
