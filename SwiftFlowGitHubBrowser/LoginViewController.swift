//
//  ViewController.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 1/5/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import UIKit
import OctoKit

class LoginViewController: UIViewController {

    @IBAction func authenticateWithGitHub() {
        store.dispatch(authenticateUser)
    }

}

