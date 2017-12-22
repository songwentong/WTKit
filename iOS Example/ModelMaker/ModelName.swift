//
//  ModelMaker.ViewController.swift
//
//  this file is auto create by WTKit on 2017-12-22 13:32:41.
//  site:https://github.com/swtlovewtt/WTKit
//  Thank you for use my json model maker
//

public struct ModelName: Codable {
    var otherDict:otherDict
    var testboolean:Bool
    var testStringArray:[String]
    var numberDict:[String:Int]
    var testIntArray:[Int]
    var testString:String
    var stringDict:[String:String]
    //var otherArray:[Any]
    var testInt:Int
    var testFloat:Double
}
public struct otherDict: Codable {
    var b:Int
    var a:String
    var c:c
}
public struct c: Codable {
    var d:Int
    var e:String
}

