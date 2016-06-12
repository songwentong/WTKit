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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.


        DEBUGBlock { 
            //code will run at debug mode
        }
        UIColor.colorWithHexString("333333",alpha: 0.5)
        
        
        testParseJSON()
    }
    func testReqeust(){
        NSURLRequest.request("")
        NSURLRequest.request("", method: "")
        NSURLRequest.request("", method: "", parameters: nil)
        NSURLRequest.request("", method: "", parameters: nil, headers: nil)
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
    
    func testParseJSON(){
        "a string".parseJSON { (obj, error) in
            
        }
        let data = "dasdada".dataUsingEncoding(NSUTF8StringEncoding)
        data?.parseJSON({ (obj, error) in
            print(obj)
            print(error)
        })
    }
    
    func testNSDate(){
        let date = NSDate()
        print("year:  \(date.numberFor(.Year)) month:\(date.numberFor(.Month)) day:\(date.numberFor(.Month))")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        
        NSOperationQueue.main { 
            let thread = NSThread.currentThread()
            print("main:   \(thread)")
            //main thread
        }
        NSOperationQueue.userInteractive {
            let thread = NSThread.currentThread()
            print("userInteractive: \(thread)")
            //separate thread
        }
        NSOperationQueue.globalQueue { 
            let thread = NSThread.currentThread()
            print("globalQueue: \(thread)")
            //separate thread
        }

    }
    
    func convertStringToData(){
        let string = "1"
        _ = string.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            self.convertStringToData()
        }
    }
    
}
