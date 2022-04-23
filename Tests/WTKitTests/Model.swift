//
//  Model.swift
//
//  this file is auto create by WTKit on 2022-04-22 06:51:00.
//  site:https://github.com/songwentong/ModelMaker
//  Thank you for use my json model maker😜
//

import Foundation
import WTKit
public class Model:NSObject, Codable {
    public override init() {
        super.init()
    }
    var double:Double = -1
    var doubles:[Double] = [Double]()
    var flag:Bool = false
    var intValue:Int = -1
    var ints:[Int] = [Int]()
    var object:object_class = object_class()
    var strValue:String = ""
    enum CodingKeys: String, CodingKey {
        case double = "double"
        case doubles = "doubles"
        case flag = "flag"
        case intValue = "intValue"
        case ints = "ints"
        case object = "object"
        case strValue = "strValue"
    }
    required public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            double = values.decodeToDouble(forKey: .double)
            doubles = try values.decode([Double].self, forKey: .doubles)
            flag = try values.decode(Bool.self, forKey: .flag)
            intValue = values.decodeToInt(forKey: .intValue)
            ints = try values.decode([Int].self, forKey: .ints)
            object = try values.decode(object_class.self, forKey: .object)
            strValue = values.decodeToString(forKey: .strValue)
        } catch {
            
        }
    }
}
public class object_class:NSObject, Codable {
    public override init() {
        super.init()
    }
    var Accept:String = ""
    var Accept_Encoding:String = ""
    var Accept_Language:String = ""
    var Host:String = ""
    var User_Agent:String = ""
    var X_Amzn_Trace_Id:String = ""
    enum CodingKeys: String, CodingKey {
        case Accept = "Accept"
        case Accept_Encoding = "Accept-Encoding"
        case Accept_Language = "Accept-Language"
        case Host = "Host"
        case User_Agent = "User-Agent"
        case X_Amzn_Trace_Id = "X-Amzn-Trace-Id"
    }
    required public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            Accept = values.decodeToString(forKey: .Accept)
            Accept_Encoding = values.decodeToString(forKey: .Accept_Encoding)
            Accept_Language = values.decodeToString(forKey: .Accept_Language)
            Host = values.decodeToString(forKey: .Host)
            User_Agent = values.decodeToString(forKey: .User_Agent)
            X_Amzn_Trace_Id = values.decodeToString(forKey: .X_Amzn_Trace_Id)
        } catch {
            
        }
    }
}

