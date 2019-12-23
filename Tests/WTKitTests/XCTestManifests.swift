#if os(watchOS)
#else
import XCTest
#if canImport(ObjectiveC)
#else
func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(WTKitTests.allTests),
    ]
}
#endif
#endif
