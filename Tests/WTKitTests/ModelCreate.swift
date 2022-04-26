//
//  TWGiftWallOuterModel.swift
//
//  this file is auto create by WTKit on 2022-04-26 16:22:48.
//  site:https://github.com/songwentong/ModelMaker
//  Thank you for use my json model maker😜
//

import Foundation
import WTKit
public class TWGiftWallOuterModel:NSObject, Codable {
    public override init() {
        super.init()
    }
    var double:String = ""
    var doubleList:[Double] = [Double]()
    var flag:Bool = false
    var intList:[Int] = [Int]()
    var intValue:Int = -1
    var object:TWGiftWallOuterModel_object = TWGiftWallOuterModel_object()
    var objectList:[TWGiftWallOuterModel_objectList] = [TWGiftWallOuterModel_objectList]()
    var strValue:String = ""
    enum CodingKeys: String, CodingKey {
        case double = "double"
        case doubleList = "doubleList"
        case flag = "flag"
        case intList = "intList"
        case intValue = "intValue"
        case object = "object"
        case objectList = "objectList"
        case strValue = "strValue"
    }
    required public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            double = values.decodeToString(forKey: .double)
            doubleList = values.decodeNoThrow([Double].self, forKey: .doubleList) ?? [Double]()
            flag = values.decodeNoThrow(Bool.self, forKey: .flag) ?? Bool()
            intList = values.decodeNoThrow([Int].self, forKey: .intList) ?? [Int]()
            intValue = values.decodeToInt(forKey: .intValue)
            object = values.decodeNoThrow(TWGiftWallOuterModel_object.self, forKey: .object) ?? TWGiftWallOuterModel_object()
            objectList = values.decodeNoThrow([TWGiftWallOuterModel_objectList].self, forKey: .objectList) ?? [TWGiftWallOuterModel_objectList]()
            strValue = values.decodeToString(forKey: .strValue)
        } catch {
            
        }
    }
}
public class TWGiftWallOuterModel_objectList:NSObject, Codable {
    public override init() {
        super.init()
    }
    var id:Int = -1
    var num:String = ""
    var pic:String = ""
    var title:String = ""
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case num = "num"
        case pic = "pic"
        case title = "title"
    }
    required public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = values.decodeToInt(forKey: .id)
            num = values.decodeToString(forKey: .num)
            pic = values.decodeToString(forKey: .pic)
            title = values.decodeToString(forKey: .title)
        } catch {
            
        }
    }
}
public class TWGiftWallOuterModel_object:NSObject, Codable {
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
