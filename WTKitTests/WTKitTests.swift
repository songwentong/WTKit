//
//  WTKitTests.swift
//  WTKitTests
//
//  Created by SongWentong on 4/29/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import XCTest
import WTKit
class WTKitTests: XCTestCase {
    let timeout: TimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.


        DEBUGBlock { 
            //code will run at debug mode
        }
        _ = UIColor.colorWithHexString("333333",alpha: 0.5)
        
        
        testParseJSON()
    }
    func testURLSession(){
        let url = "http://www.baidu.com"
        let task = URLSession.wt_dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
        
        print("int max: \(Int.max)")
        //int max: 9223372036854775807     iPhone SE
        //int max: 2147483647   iPhone 5
//        print("sizeOfInt \( sizeof(Int.self))")
        //sizeOfInt 8   iPhone SE
        //sizeOfInt 4   iPhone5
        #if arch(x86_64)
            print("x86_64 sizeOfInt \( sizeof(Int.self))")
        #else
            print("not x86_64 sizeOfInt \( sizeof(Int.self))")
        #endif
    }
    func testSession(){
        let session = URLSession.wt_sharedInstance()
        XCTAssertNil(session.delegate, "session delegate should not be nil")
    }
    func testReqeust(){
        
        
    
        /*
        var request:URLRequest?
        _ = URLRequest.wtRequest(with: "")
        _ = URLRequest.wtRequest(with:"", method: "")
        _ = URLRequest.wtRequest(with:"", method: "", parameters: nil)
        request = URLRequest.wtRequest(with:"http://www.baidu.com", method: "", parameters: nil, headers: nil)
        let credential = URLCredential(user: "user", password: "pwd", persistence:URLCredential.Persistence.forSession)
        var task = URLSession.wt_dataTask(with: request!, credential: credential) { (data, response, error) in
            
        }
        task = URLSession.wt_dataTask(with: request!, completionHandler: { (data, response, error) in
            
        })
        task.resume()
 */
//        let reqeust = URLRequest.request("http://www.baidu.com")
//        let session = URLSession.shared
//        session.delegate = WTURLSessionDelegate()
        
    }
    
    func testColorStatus(){
        for i in 0...255{
            let status = Float(Float(i) * 0.01)
            let color = UIColor.wtStatusColor(with: status)
            print("color: \(color)")
        }
    }
    
    func testInt(){
        for i in 0...100{
            let y = Int.wt_fibonacci(number: UInt(i))
            print("\(i):\(y)")
        }
    }
    
    func testwt_factorial(){
        for i in 1...10{
            let y = UInt.wt_factorial(number: UInt(i))
            print("\(i):\(y)")
        }
    }
    
    
    func testOperationQueue(){
        let queue = OperationQueue()
        queue.isSuspended = false
    }
    
    
    
    //{"NewKey 3": "a","NewKey 2": {"NewKey 2": {"NewKey": "b"},"NewKey": "c"},"NewKey": {"NewKey": "d"}}
    /*
    func testWTT(){
        let string = "{\"NewKey 3\": \"a\",\"NewKey 2\": {\"NewKey 2\": {\"NewKey\": \"b\"},\"NewKey\": \"c\"},\"NewKey\": {\"NewKey\": \"d\"}}"
        string.parseJSON { (anyObject, error) in
            if let json:AnyObject = anyObject{
                NSObject.wt_tarversal(with: json)
                
            }
        }
    }
    */
    /*
    func testWTcurry(){
        for i in 0...100 {
            let y = Int.wt_fibonacciCurry(number: i)
            print("\(i):\(y)")
        }
    }
 */
    
    func testUIApplication(){
        /*
        UIApplication.track()
        if UIApplication.sharedApplication().isFirstLaunchEver {
            WTLog("is first launch for build")
        }else{
            WTLog("not first launch for build")
        }
 */
    }
    
    func testNSData(){
        let string = "test data".toUTF8Data().toUTF8String()
        print(string)
    }
    
    func testParseJSON(){
        "a string".parseJSON { (obj, error) in
            
        }
        let data = "dasdada".data(using: String.Encoding.utf8)
        data?.parseJSON(handler: { (obj, error) in
            print(obj)
            print(error)
        })
    }
    
    func testWTURLSessionDelegate(){
//        let delegate = WTURLSessionDelegate()
//        let session = URLSession(configuration: URLSessionConfiguration(), delegate: delegate ,delegateQueue:nil)
//        session.delegate = delegate
    }
    
    
    func testNSDate(){
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: kWTReachabilityChangedNotification), object: nil, queue: nil) { [weak self](notification) in
//            
//        }
//        let date = Date()
//        print("year:\(date.numberForComponent(.year)) month:\(date.numberForComponent(.month)) day:\(date.numberForComponent(.day))")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        
        OperationQueue.main {
            let thread = Thread.current
            print("main:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")
        }
        OperationQueue.background {
            let thread = Thread.current
            print("background:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")
            
        }
        OperationQueue.userInteractive {
            let thread = Thread.current
            print("userInteractive:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")
            
        }
        OperationQueue.globalQueue {
            let thread = Thread.current
            print("globalQueue:\(thread) threadPriority:\(thread.threadPriority) qualityOfService:\(thread.qualityOfService.rawValue)")
        }

    }
    
    func convertStringToData(){
        let string = "1"
        _ = string.data(using: String.Encoding.utf8)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.convertStringToData()
        }
    }
    
}
class AuthenticationTestCase:WTKitTests{
    let user = "user"
    let password = "password"
    var URLString = ""
}
class BasicAuthenticationTestCase:AuthenticationTestCase{
    override func setUp() {
        super.setUp()
        URLString = "https://httpbin.org/basic-auth/\(user)/\(password)"
    }
    func testHTTPBasicAuthenticationWithInvalidCredentials() {
//        var request = URLRequest.request(URLString)
//        var task = URLSession.wt_dataTask(with: request, credential: URLCredential(user: user,password: passwd)) { (data, response, error) in
        
//        }
    }
}
