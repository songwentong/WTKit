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
    
    /**
     测试了类型异常，字段异常，通过测试
     Int/Double/String 异常处理
     Dict/Array异常处理
     null异常处理
     */
    func testDecode() {
       
//        guard let obj2 = Model.decodeIfPresent(with: jsonString.utf8Data) else{
//            return
//        }
//        print(obj2.jsonString)
    }
    let json1 = """
{
"intValue":3,
"strValue":"3.8",
"double":"3.5",
"ints":[1,2],
"flag":true,
"doubles":[1.1,2.2],
"object": {
"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
"Accept-Encoding": "gzip, deflate, br",
"Accept-Language": "zh-cn",
"Host": "httpbin.org",
"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15",
"X-Amzn-Trace-Id": "Root=1-5e716637-2f2252cc4747e55326ef4a08"
}
}
"""
    
    let json2 = """
 {
    "data": [
      {
        "id": 145,
        "title": "喜欢你",
        "num": "4",
        "pic": "https://img3.tuwandata.com/uploads/play/9766281560847422.png"
      },
      {
        "id": 148,
        "title": "么么哒",
        "num": "3",
        "pic": "https://img3.tuwandata.com/uploads/play/6851431563789324.png"
      }
    ],
    "page": 1,
    "total_page": 1,
    "gift_total": 2
  }
"""
    func testGiftList() {
        let maker = WTModelMaker.default
        maker.needOptionalMark = false
        let str = maker.createModelWith(className: "TWGiftWallOuterModel", jsonString: json1)
        print(str)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
#endif
