# RequestKit

[![Build Status](https://travis-ci.org/nerdishbynature/RequestKit.svg?branch=master)](https://travis-ci.org/nerdishbynature/RequestKit)
[![codecov.io](https://codecov.io/github/nerdishbynature/RequestKit/coverage.svg?branch=master)](https://codecov.io/github/nerdishbynature/RequestKit?branch=master)

The base of [octokit.swift](https://github.com/nerdishbynature/Octokit.swift), [TanukiKit](https://github.com/nerdishbynature/TanukiKit), [TrashCanKit](https://github.com/nerdishbynature/TrashCanKit) and [VloggerKit](https://github.com/nerdishbynature/VloggerKit).

## Installation

### Carthage

```
# Cartfile
github "nerdishbynature/RequestKit"
```

### CocoaPods

```
# Podfile
pod "NBNRequestKit"
```

## Usage

To make a request using RequestKit you will need three parts: a `Router`, a `Configuration` and usually an object that know both and connects them. See [OctoKit](https://github.com/nerdishbynature/octokit.swift/blob/master/OctoKit/Octokit.swift#L3).

### Defining a Router

Router are defined by the `Router` protocol. It is recommended to define them as `Enumerations` having a case for every route.

This is what a basic router looks like:

```swift
enum MyRouter: Router {
    case GetMyself(Configuration)

    var configuration: Configuration {
        switch self {
        case .GetMyself(let config): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .GetMyself:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .GetMyself:
            return .URL
        }
    }

    var path: String {
        switch self {
        case .GetMyself:
            return "myself"
        }
    }

    var params: [String: AnyObject] {
        switch self {
        case .GetMyself(_):
            return ["key1": "value1", "key2": "value2"]
        }
    }
}
```

## Defining a Configuration

As RequestKit was designed to handle OAuth requests we needed something to store user credentials. This is where Configurations come into play. Configurations are defined in the `Configuration` protocol.

```swift
public struct TokenConfiguration: Configuration {
    public let accessToken: String?
    public let apiEndpoint = "https://my.webservice.example/api/2.0/"
    public let accessTokenFieldName = "access_token"
    public let errorDomain: String = "com.my.customErrorDomain"

    public init(_ accessToken: String? = nil) {
        self.accessToken = accessToken
    }
}
```

## Defining the binding object

We will need something that connects the router and the configuration to make provide a convenient interface. The common way of doing this is to use a `struct` or a `class` that does it for you.

```swift
struct MyWebservice {
    var configuration: Configuration

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    func getMyself(session: RequestKitURLSession = NSURLSession.sharedSession(), completion: (response: Response<[String: AnyObject]>) -> Void) -> RequestKitURLSession {
        let router = MyRouter.GetMyself(configuration)
        router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    completion(response: Response.Success(json))
                }
            }
        }
    }
}
```

## Making a request

All your user has to to is call your `MyWebservice`:

```swift
let config = TokenConfiguration(accessToken: "123456")
MyWebservice(config).getMySelf { response in
    switch response {
        case .Success(let myself):
            print(myself)
        case .Failure(let error):
            print(error)
    }
}
```
