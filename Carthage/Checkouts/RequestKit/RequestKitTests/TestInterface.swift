import RequestKit

class TestInterfaceConfiguration: Configuration {
    var apiEndpoint: String
    var errorDomain = "com.nerdishbynature.RequestKitTests"
    var accessToken: String? = nil

    init(url: String) {
        apiEndpoint = url
    }
}

class TestInterface {
    var configuration: Configuration {
        return TestInterfaceConfiguration(url: "https://example.com")
    }

    func postJSON(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<[String: AnyObject]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = JSONTestRouter.testRoute(configuration)
        return router.postJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    completion(Response.success(json))
                }
            }
        }
    }
}

enum JSONTestRouter: JSONPostRouter {
    case testRoute(Configuration)

    var configuration: Configuration {
        switch self {
        case .testRoute(let config): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .testRoute:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .testRoute:
            return .json
        }
    }

    var path: String {
        switch self {
        case .testRoute:
            return "some_route"
        }
    }

    var params: [String: Any] {
        switch self {
        case .testRoute:
            return [:]
        }
    }
}
