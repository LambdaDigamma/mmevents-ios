import XCTest
@testable import MMEvents

final class mmevents_iosTests: XCTestCase {
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MMEvents().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
