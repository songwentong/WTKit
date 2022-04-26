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
        guard let obj2 = TWGiftWallOuterModel.decodeIfPresent(with: json1().utf8Data) else{
            return
        }
        print(obj2.jsonString)
    }
    
    ///模型创建
    func testModelCreate() {
        let maker = WTModelMaker.default
//        maker.needOptionalMark = false
//        maker.useStruct = true
        let className = "TWGiftWallOuterModel"
        let classCode = maker.createModelWith(className: className, jsonString: json1())
        print(NSHomeDirectory())
        print(classCode)
        
        let path = NSHomeDirectory() + "/Documents/" + className + ".swift"
        print(path)
        do {
            try classCode.write(toFile: path, atomically: true, encoding: .utf8)
#if os(macOS)
            let url = path.urlValue
            NSWorkspace.shared.activateFileViewerSelecting([url])
            NSWorkspace.shared.selectFile(path, inFileViewerRootedAtPath: "/")
#else
#endif
        } catch {
            
        }
    }
    
    
    
    func json1() -> String {
        let json1 = """
    {
      "intValue": 3,
      "strValue": "3.8",
      "double": "3.5",
      "intList": [
        1,
        2
      ],
      "flag": true,
      "doubleList": [
        1.1,
        2.2
      ],
      "object": {
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "zh-cn",
        "Host": "httpbin.org",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15",
        "X-Amzn-Trace-Id": "Root=1-5e716637-2f2252cc4747e55326ef4a08"
      },
      "objectList": [
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
      ]
    }
    """
        return json1
    }
    func json2() -> String {
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
        return json2
    }

    
    
    func testCookie() {
        
        let httpCookieStorage = URLSession.default.configuration.httpCookieStorage
        let date = Date.init(timeIntervalSinceReferenceDate: 99999999999)
        let cookieProps:[HTTPCookiePropertyKey:Any] = [
            .domain: "www.apple.com",
            .path: "index.html",
            .name: "name",
            .value: "value",
            .secure: true,
            .expires: date
            ]
        guard let cook = HTTPCookie.init(properties: cookieProps) else{
            return
        }
        
        httpCookieStorage?.setCookie(cook)
        WT.dataTask(with: "") { a, b, c in
            
        }
        URLSession.default.configuration.httpCookieStorage = httpCookieStorage
        let task = URLSession.default.dataTask(with: "https://www.apple.com/index.html") { d, u, e in
            
        }
        print(task.printer)
    }
    
    enum PrinterError: Error {
        case outOfPaper
        case noToner
        case onFire
    }
    static var allTests = [
        ("testExample", testExample),
    ]
}
#endif
