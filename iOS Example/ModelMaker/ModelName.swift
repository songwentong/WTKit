//
//  ModelName.swift
//
//  this file is auto create by WTKit on 2017-12-28 11:32:30.
//  site:https://github.com/swtlovewtt/WTKit
//  Thank you for use my json model maker😜
//

public struct ModelName: Codable {
    var otherDict:otherDict
    var classProperty:String
    var numberDict:[String:Int]
    var letProperty:String
    //var otherArray:[Any]
    var varProperty:String
    var superProperty:Double
    var testStringArray:[String]
    var testboolean:Bool
    var testString:String
    var testIntArray:[Int]
    var stringDict:[String:String]
    var testInt:Int
    var testFloat:Double
    enum CodingKeys: String, CodingKey {
        case otherDict = "otherDict"
        case classProperty = "class"
        case numberDict = "numberDict"
        case letProperty = "let"
        //case otherArray = "otherArray"
        case varProperty = "var"
        case superProperty = "super"
        case testStringArray = "testStringArray"
        case testboolean = "testboolean"
        case testString = "testString"
        case testIntArray = "testIntArray"
        case stringDict = "stringDict"
        case testInt = "testInt"
        case testFloat = "testFloat"
    }
}
public struct otherDict: Codable {
    var b:Int
    var a:String
    var c:c
    enum CodingKeys: String, CodingKey {
        case b = "b"
        case a = "a"
        case c = "c"
    }
}
public struct c: Codable {
    var d:Int
    var e:String
    enum CodingKeys: String, CodingKey {
        case d = "d"
        case e = "e"
    }
}
