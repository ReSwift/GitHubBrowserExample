import XCTest
import RequestKit

class StringAdditionsTests: XCTestCase {
    func testStringByAppendingURLPath() {
        let subject = "https://something.com"
        XCTAssertEqual(subject.stringByAppendingURLPath("/login/oauth"), "https://something.com/login/oauth")
        XCTAssertEqual(subject.stringByAppendingURLPath("login/oauth"), "https://something.com/login/oauth")
    }

    func testURLEncodedString() {
        let subject = "something with a space:<3"
        XCTAssertEqual(subject.urlEncodedString(), "something%20with%20a%20space%3A%3C3")

        let subject2 = "2015-11-06T03:45:07.833168+00:00"
        XCTAssertEqual(subject2.urlEncodedString(), "2015-11-06T03%3A45%3A07.833168%2B00%3A00")
    }
}
