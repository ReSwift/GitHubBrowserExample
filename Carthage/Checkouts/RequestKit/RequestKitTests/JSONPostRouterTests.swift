import RequestKit
import XCTest

class JSONPostRouterTests: XCTestCase {
    func testJSONPostJSONError() {
        let jsonDict = ["message": "Bad credentials", "documentation_url": "https://developer.github.com/v3"]
        let jsonString = String(data: try! JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions()), encoding: String.Encoding.utf8)
        let session = RequestKitURLTestSession(expectedURL: "https://example.com/some_route", expectedHTTPMethod: "POST", response: jsonString, statusCode: 401)
        let task = TestInterface().postJSON(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve a succesful response")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, "com.nerdishbynature.RequestKitTests")
                XCTAssertEqual((error.userInfo[RequestKitErrorResponseKey] as? [String: String]) ?? [:], jsonDict)
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testJSONPostStringError() {
        let errorString = "Just nope"
        let session = RequestKitURLTestSession(expectedURL: "https://example.com/some_route", expectedHTTPMethod: "POST", response: errorString, statusCode: 401)
        let task = TestInterface().postJSON(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve a succesful response")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, "com.nerdishbynature.RequestKitTests")
                XCTAssertEqual((error.userInfo[RequestKitErrorResponseKey] as? String) ?? "", errorString)
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
