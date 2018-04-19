//
//  WTKitTests.swift
//  WTKitTests
//
//  Created by SongWentong on 19/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import XCTest
import WTKit
class WTKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testWTNetWork()
    }
    
    func testModelMaker() -> Void {
        
    }
    
    func testWTNetWork(){
        let task = WTKit.dataTask(with: "https://www.apple.com")
        let httpMethod = task.originTask.originalRequest?.httpMethod
        print("\(String(describing: httpMethod))")
        
    }
    func testNumberType(){
        //char, short int, int, long int, long long int, float, or double or as a BOOL
        // “c”, “C”, “s”, “S”, “i”, “I”, “l”, “L”, “q”, “Q”, “f”, and “d”.
        //1->q    true->c     1.0->d   6766882->q   6766882.1->d   0->q   false->c
        let number = NSNumber.init(value: false)
        let type = String.init(cString: number.objCType)
        print("type:\(type)")
    }
    
    func testBubbleSort(){
        WTPrint("qweqwe")
        let ints = [1,2,3,0]
        print("bubbleSort:\(bubbleSort(array:ints))")
    }
    //插入排序
    func testInsertionSort(){
        print("insert sort: \(insertionSort(array: [3,0,1,2])) ")
    }
    //选择排序
    func testSelectionSort(){
        print("selection sort \(selectionSort(array:[3,0,1,2]))")
    }
    //快速排序
    func testQuickSort(){
        
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
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
