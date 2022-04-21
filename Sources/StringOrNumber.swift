//
//  File.swift
//  
//
//  Created by Wentong Song on 2022/4/21.
//

import Foundation
public extension KeyedDecodingContainer{
    /**
     Int解析,兼容字符串
     */
    func decodeToInt(forKey key: KeyedDecodingContainer<K>.Key) -> Int{
        do {
            
            if let num = try decodeIfPresent(Int.self, forKey: key) {
                print("aaaaaa")
            }
//            let num = try decode(Int.self, forKey: key)
            return 1
        } catch  {
            let str = decodeToString(forKey: key)
            return Int.init(str) ?? 0
        }
    }
    ///Double解析,兼容字符串
    func decodeToDouble(forKey key: KeyedDecodingContainer<K>.Key) -> Double{
        do {
            let num = try decode(Double.self, forKey: key)
            return num
        } catch  {
            let str = decodeToString(forKey: key)
            return Double.init(str) ?? 0
        }
    }
    func decodeToBool(forKey key: KeyedDecodingContainer<K>.Key) -> Bool{
        do {
            let num = try decode(Bool.self, forKey: key)
            return num
        } catch  {
            return false
        }
    }
    ///String解析,兼容Double
    func decodeToString(forKey key: KeyedDecodingContainer<K>.Key) -> String{
        do {
            let str = try decode(String.self, forKey: key)
            return str
        } catch  {
            let num = decodeToDouble(forKey: key)
            return String.init(num)
        }
    }
}
///类型枚举器,用于JSON数据枚举,允许字段的数据是int,double和string
///配合Model Maker使用,可以让属性异常好用
public enum StringOrNumber: Codable {
    case string(String)
    case double(Double)
    case int(Int)
    ///默认值,是空字符串,数据类型的话是0
    public static func defaultValue() -> Self{
        return StringOrNumber.string("")
    }
    public func intValue() -> Int {
        switch self {
        case .int(let num):
            return num
        case .double(let dou):
            return Int(dou)
        case .string(let str):
            return Int(str) ?? 0
        }
    }
    public func stringValue() -> String {
        switch self {
        case .string(let str):
            return str
        case .int(let num):
            return num.stringValue
        case .double(let dou):
            return dou.stringValue
        }
    }
    public func doubleValue() -> Double {
        switch self {
        case .double(let num):
            return num
        case .int(let num):
            return num.doubleValue
        case .string(let str):
            return Double.init(str) ?? 0
        }
    }
    
    public init(from decoder: Decoder) throws {
        if let num = try? decoder.singleValueContainer().decode(Int.self){
            self = .int(num)
        }else if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }else if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }else{
            throw Error.couldNotFindStringOrDouble
        }
    }
    public func encode(to encoder: Encoder) throws{
        var container = encoder.singleValueContainer()
        try container.encode(stringValue())
        
    }
    enum Error: Swift.Error {
        case couldNotFindStringOrDouble
    }
}
