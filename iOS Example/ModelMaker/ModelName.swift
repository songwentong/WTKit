//
//  ModelName.swift
//
//  this file is auto create by WTKit on 2017-12-28 14:57:29.
//  site:https://github.com/swtlovewtt/WTKit
//  Thank you for use my json model maker😜
//

public struct ModelName: Codable {
    var numberDict:[String:Int]
    var let_var:String
    //var otherArray:[Any]
    var var_var:String
    var func_var:func_var
    var super_var:Double
    var testStringArray:[String]
    var testboolean:Bool
    var testString:String
    var testIntArray:[Int]
    var stringDict:[String:String]
    var testInt:Int
    var testFloat:Double
    enum CodingKeys: String, CodingKey {
        case numberDict = "numberDict"
        case let_var = "let"
        //case otherArray = "otherArray"
        case var_var = "var"
        case func_var = "func"
        case super_var = "super"
        case testStringArray = "testStringArray"
        case testboolean = "testboolean"
        case testString = "testString"
        case testIntArray = "testIntArray"
        case stringDict = "stringDict"
        case testInt = "testInt"
        case testFloat = "testFloat"
    }
}
public struct func_var: Codable {
    var b:Int
    var a:String
    var class_var:class_var
    enum CodingKeys: String, CodingKey {
        case b = "b"
        case a = "a"
        case class_var = "class"
    }
}
public struct class_var: Codable {
    var d:Int
    var e:String
    enum CodingKeys: String, CodingKey {
        case d = "d"
        case e = "e"
    }
}
