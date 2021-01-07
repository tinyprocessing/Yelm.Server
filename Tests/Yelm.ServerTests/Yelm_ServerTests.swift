import XCTest
@testable import Yelm_Server

final class Yelm_ServerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Yelm_Server().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
