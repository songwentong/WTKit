#if os(watchOS)
@testable import WTKit
#else
import XCTest

@testable import WTKit

final class WTKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print("print asdasdasdsadas21das4321da52s341")
        
        testBundle()
    }
    func testBundle() {
        let localizations = Bundle.main.localizations
        print("locals:\(localizations)")
    }
    override func measure(_ block: () -> Void) {
        
    }
    func testSaveData() {
        URLSession.default.useCacheElseLoadUrlData(with: "https://img2.tuwandata.com/com/20220411/7dHbGxe3Sd.mp4".urlValue) { data in
            DataCacheManager.shared.save(data: data, for: "7dHbGxe3Sd.mp4") {
                dprint(NSHomeDirectory())
            }
        } failed: { error in
            
        }

    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
#endif
