//
//  File.swift
//  
//
//  Created by Wentong Song on 2022/4/21.
//

import Foundation
/**
 数据解析扩展,对于Int/String/Double常见类型兼容
 Int可以接收Double和String
 Double可以接收String和Int
 String可以接收Int和Double
 */
public extension KeyedDecodingContainer{
    /**
     Int解析,兼容字符串
     */
    func decodeToInt(forKey key: KeyedDecodingContainer<K>.Key) -> Int{
        do {
            return try decode(Int.self, forKey: key)
        } catch {
            do {
                let dou = try decode(Double.self, forKey: key)
                return Int(dou)
            } catch  {
                do {
                    let str = try decode(String.self, forKey: key)
                    return Int(Double(str) ?? 0)
                } catch  {
                    return 0
                }
            }
        }
    }
    ///Double解析,兼容字符串
    func decodeToDouble(forKey key: KeyedDecodingContainer<K>.Key) -> Double{
        do {
            let num = try decode(Double.self, forKey: key)
            return num
        } catch  {
            do {
                let str = try decode(String.self, forKey: key)
                return str.doubleValue
                
            } catch  {
                do {
                    let num = try decode(Int.self, forKey: key)
                    return num.doubleValue
                } catch  {
                    return 0.0
                }
            }
        }
    }
    ///String解析,兼容Double
    func decodeToString(forKey key: KeyedDecodingContainer<K>.Key) -> String{
        do {
            let str = try decode(String.self, forKey: key)
            return str
        } catch  {
            do {
                let num = try decode(Int.self, forKey: key)
                return num.stringValue
            } catch {
                do {
                    let dou = try decode(Double.self, forKey: key)
                    return dou.stringValue
                } catch  {
                    return ""
                }
            }
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
