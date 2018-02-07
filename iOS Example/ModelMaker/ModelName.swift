//
//  ModelName.swift
//
//  this file is auto create by WTKit on 2018-01-08 16:41:02.
//  site:https://github.com/swtlovewtt/WTKit
//  Thank you for use my json model maker😜
//
class test: Codable {
    var a:String
    var b:String
    enum CodingKeys: String, CodingKey {
        case a = "a"
        case b = "b"
    }
    public required init(from decoder: Decoder) throws{
        let values:KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        a = try values.decode(String.self, forKey: CodingKeys.a)
        let value = try values.decode(String.self, forKey: CodingKeys.b)
        b = "\(value)"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(a, forKey: CodingKeys.a)
        try container.encode(b, forKey: CodingKeys.b)
    }
}
public class ModelName: Codable {
    var numberDict:[String:Int]?
    var let_var:String?
    //var otherArray://[Any]?
    var var_var:String?
    var func_var:func_var?
    var super_var:Double?
    var testStringArray:[String]?
    var testboolean:Bool?
    var testString:String?
    var testIntArray:[Int]?
    var stringDict:[String:String]?
    var testInt:Int?
    var testFloat:Double?
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
public class func_var: Codable {
    var b:Int?
    var a:String?
    var class_var:class_var?
    enum CodingKeys: String, CodingKey {
        case b = "b"
        case a = "a"
        case class_var = "class"
    }
}
public class class_var: Codable {
    var d:Int?
    var e:String?
    enum CodingKeys: String, CodingKey {
        case d = "d"
        case e = "e"
    }
}
