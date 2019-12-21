#if !os(watchOS)
import XCTest

#if !canImport(ObjectiveC)
func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(WTKitTests.allTests),
    ]
}
#endif
#endif
