import Foundation

let errorDomain = "com.octokit.swift"

public enum Response<T> {
    case Success(T)
    case Failure(ErrorType)
}

public enum HTTPMethod: String {
    case GET = "GET", POST = "POST"
}

public enum HTTPEncoding: Int {
    case URL, FORM, JSON
}

public protocol Configuration {
    var apiEndpoint: String { get }
    var accessToken: String? { get }
    var accessTokenFieldName: String { get }
}

public extension Configuration {
    var accessTokenFieldName: String {
        return "access_token"
    }
}

public protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var encoding: HTTPEncoding { get }
    var params: [String: String] { get }
    var configuration: Configuration { get }

    func urlQuery(parameters: [String: String]) -> String
    func request(urlString: String, parameters: [String: String]) -> NSURLRequest?
    func loadJSON<T>(expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void)
    func request() -> NSURLRequest?
}

public extension Router {
    public func request() -> NSURLRequest? {
        let URLString = configuration.apiEndpoint.stringByAppendingURLPath(path)
        var parameters = encoding == .JSON ? [:] : params
        if let accessToken = configuration.accessToken {
            parameters[configuration.accessTokenFieldName] = accessToken
        }
        return request(URLString, parameters: parameters)
    }

    public func urlQuery(parameters: [String: String]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys.sort(<) {
            if let value = parameters[key] {
                let encodedValue = value.urlEncodedString()
                components.append(key, encodedValue!)
            }
        }

        return components.map{"\($0)=\($1)"}.joinWithSeparator("&")
    }

    public func request(urlString: String, parameters: [String: String]) -> NSURLRequest? {
        var URLString = urlString
        switch encoding {
        case .URL, .JSON:
            if parameters.keys.count > 0 {
                URLString = [URLString, urlQuery(parameters) ?? ""].joinWithSeparator("?")
            }
            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.HTTPMethod = method.rawValue
                return mutableURLRequest
            }
        case .FORM:
            let queryData = urlQuery(parameters).dataUsingEncoding(NSUTF8StringEncoding)
            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
                mutableURLRequest.HTTPBody = queryData
                mutableURLRequest.HTTPMethod = method.rawValue
                return mutableURLRequest
            }
        }

        return nil
    }

    public func loadJSON<T>(expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void) {
        if let request = request() {
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, err in
                if let response = response as? NSHTTPURLResponse {
                    if response.wasSuccessful == false {
                        let error = NSError(domain: errorDomain, code: response.statusCode, userInfo: nil)
                        completion(json: nil, error: error)
                        return
                    }
                }

                if let err = err {
                    completion(json: nil, error: err)
                } else {
                    if let data = data {
                        do {
                            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? T
                            completion(json: JSON, error: nil)
                        } catch {
                            completion(json: nil, error: error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

public extension NSHTTPURLResponse {
    public var wasSuccessful: Bool {
        let successRange = 200..<300
        return successRange.contains(statusCode)
    }
}
