import XCTest
@testable import WTKit

final class WTKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print("print asdasdasdsadas21das4321da52s341")
        XCTAssertEqual(WTKit().text, "Hello, World!")
        testBundle()
    }
    func testBundle() {
        let localizations = Bundle.main.localizations
        print("locals:\(localizations)")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
