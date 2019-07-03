//
//  AuthenticationService.swift
//  SwiftFlowGitHubBrowser
//
//  Created by Benji Encz on 2/22/16.
//  Copyright © 2016 Benji Encz. All rights reserved.
//

import Foundation
import SAMKeychain
import OctoKit

class AuthenticationService {

    func authenticationData() -> TokenConfiguration? {
        if let data = SAMKeychain.passwordData(forService: "GitHubAuth", account: "TokenConfiguration") {
            return TokenConfiguration(data: data)
        } else {
            return nil
        }
    }

    func saveAuthenticationData(_ token: TokenConfiguration) {
        let data = token.toData()
        SAMKeychain.setPasswordData(data, forService: "GitHubAuth", account: "TokenConfiguration")
    }

}

// TODO: Cleanup
extension TokenConfiguration {

    init(data: Data) {
        let json: [String: AnyObject] = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
        let url = json["endpoint"] as! String
        let accessToken: String? = {
            if case let s = json["accesstoken"] as? String, s != "null" {
                return s
            } else {
                return nil
            }
        }()

        self.init(accessToken, url: url)
    }

    func toData() -> Data {
        let json: NSDictionary = [
            "endpoint": self.apiEndpoint,
            "accesstoken": self.accessToken ?? "null"
        ]

        return try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
    }

}
