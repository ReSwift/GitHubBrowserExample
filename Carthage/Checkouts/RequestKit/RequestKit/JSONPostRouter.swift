import Foundation

public protocol JSONPostRouter: Router {
    func postJSON<T>(_ session: RequestKitURLSession, expectedResultType: T.Type, completion: @escaping (_ json: T?, _ error: Error?) -> Void) -> URLSessionDataTaskProtocol?
}

public let RequestKitErrorResponseKey = "RequestKitErrorResponseKey"

public extension JSONPostRouter {
    public func postJSON<T>(_ session: RequestKitURLSession = URLSession.shared, expectedResultType: T.Type, completion: @escaping (_ json: T?, _ error: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        guard let request = request() else {
            return nil
        }

        let data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
        } catch {
            completion(nil, error)
            return nil
        }

        let task = session.uploadTask(with: request, fromData: data) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if !response.wasSuccessful {
                    var userInfo = [String: AnyObject]()
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        userInfo[RequestKitErrorResponseKey] = json as AnyObject?
                    } else if let data = data, let string = String(data: data, encoding: String.Encoding.utf8) {
                        userInfo[RequestKitErrorResponseKey] = string as AnyObject?
                    }
                    let error = NSError(domain: self.configuration.errorDomain, code: response.statusCode, userInfo: userInfo)
                    completion(nil, error)
                    return
                }
            }

            if let error = error {
                completion(nil, error)
            } else {
                if let data = data {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? T
                        completion(JSON, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}
