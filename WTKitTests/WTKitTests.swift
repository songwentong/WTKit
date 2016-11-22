//
//  WTKitTests.swift
//  WTKitTests
//
//  Created by SongWentong on 19/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import XCTest

class WTKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testjson(){

        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let data = NSData(contentsOfFile: "/Users/songwentong/Github/WTKit/WTKitTests/JSONData")
        let jsonObject = JSONSerialization.WTJSONObject(with: data as! Data)
        print("\(jsonObject)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
