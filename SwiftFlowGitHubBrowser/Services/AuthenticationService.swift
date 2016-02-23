//
//  AuthenticationService.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 2/22/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import SSKeychain
import OctoKit

class AuthenticationService {

    func authenticationData() -> TokenConfiguration? {
        if let data = SSKeychain.passwordDataForService("GitHubAuth", account: "TokenConfiguration") {
            return TokenConfiguration(data: data)
        } else {
            return nil
        }
    }

    func saveAuthenticationData(token: TokenConfiguration) {
        let data = token.toData()
        SSKeychain.setPasswordData(data, forService: "GitHubAuth", account: "TokenConfiguration")
    }

}

// TODO: Cleanup
extension TokenConfiguration {

    init(data: NSData) {
        let json: [String: AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! [String : AnyObject]

        self.apiEndpoint = json["endpoint"] as! String
        self.accessToken = { if case let s = json["accesstoken"] as? String where s != "null" { return s } else { return nil } }()
    }

    func toData() -> NSData {
        let json: NSDictionary = [
            "endpoint": self.apiEndpoint,
            "accesstoken": self.accessToken ?? "null"
        ]

        return try! NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions(rawValue: 0))
    }

}
