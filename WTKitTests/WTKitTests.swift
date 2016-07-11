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
    func textURLSession(){
        let url = "http://www.baidu.com"
        let task = URLSession.wtDataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    func testReqeust(){
        
        
    
        
        var request:URLRequest?
        _ = URLRequest.request("")
        _ = URLRequest.request("", method: "")
        _ = URLRequest.request("", method: "", parameters: nil)
        request = URLRequest.request("http://www.baidu.com", method: "", parameters: nil, headers: nil)
        let credential = URLCredential(user: "user", password: "pwd", persistence:URLCredential.Persistence.forSession)
        var task = URLSession.wtDataTask(with: request!, credential: credential) { (data, response, error) in
            
        }
        task = URLSession.wtDataTask(with: request!, completionHandler: { (data, response, error) in
            
        })
        task.resume()
//        let reqeust = URLRequest.request("http://www.baidu.com")
//        let session = URLSession.shared
//        session.delegate = WTURLSessionDelegate()
        
    }
    
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
        data?.parseJSON({ (obj, error) in
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
        var request = URLRequest.request(URLString)
        var task = URLSession.wtDataTask(with: request, credential: URLCredential(user: user,password: passwd)) { (data, response, error) in
            
        }
    }
}
