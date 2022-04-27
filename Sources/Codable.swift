//
//  File.swift
//  
//
//  Created by Wentong Song on 2022/4/21.
//

import Foundation
/**
 数据解析扩展
 处理了无key异常(无此字段)和类型异常
 对于Int/String/Double常见类型兼容
 */
public extension KeyedDecodingContainer{
    ///尝试解析，异常不throw，没有就没有了
    func decodeNoThrow<T:Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) -> T?{
        do{
            let obj:T? = try decodeIfPresent(type, forKey: key)
            return obj
        }catch{
            
        }
        return nil
    }
    
    /**
     Int解析
     兼容异常:无key异常,类型异常
     无key有默认值-1
     类型异常会找字符串类型和Double类型
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
                    return Int(str) ?? -1
                } catch  {
                    return -1
                }
            }
        }
    }
    /**
     Double解析
     兼容情况:无key异常,类型异常
     无key有默认值-1.0
     类型异常会找字符串类型和Int类型
     */
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
                    return -1.0
                }
            }
        }
    }
    /**
     String解析,兼容Double,Int,
     兼容情况:无key异常,类型异常
     无key有默认值为空字符串
     类型异常会找字符串类型和Int类型
     */
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
    func decodeToObject<T:Decodable>(forKey key: KeyedDecodingContainer<K>.Key) -> T?{
        do {
            return try decode(T.self, forKey: key)
        } catch  {
            return nil
        }
    }
}
public extension JSONDecoder{
    ///不处理异常
    func decodeIfPresent<T>(_ type: T.Type, from data: Data) -> T? where T : Decodable{
        do {
            let obj = try decode(type, from: data)
            return obj
        } catch {
            
        }
        return nil
    }
}

// MARK: - Encodable
public extension Encodable{
    ///convert self to data
    var jsonData:Data{
        let encoder = JSONEncoder()
        if #available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *){
            encoder.outputFormatting = [.withoutEscapingSlashes,.prettyPrinted,.sortedKeys]
        }else if #available(OSX 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *) {
            encoder.outputFormatting = [.prettyPrinted,.sortedKeys]
        } else {
            encoder.outputFormatting = [.prettyPrinted]
        }
        if let data = try? encoder.encode(self){
            return data
        }
        return Data()
    }
    ///convert self to json string (recommand use print,not lldb)
    var jsonString:String{
        return jsonData.utf8String
    }
    #if DEBUG
    ///use in lldb to print jsonstring,like(lldb) po obj.lldbPrint()
    ///this method is only recommanded use in lldb,so it's in debug mode
    func lldbPrint() {
        print("\(jsonString)")
    }
    #endif

}
// MARK: - Decodable
public extension Decodable{
    static func decodeIfPresent(with data:Data) -> Self? {
        return JSONDecoder().decodeIfPresent(self, from: data)
    }
}



///即将废弃
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
            self = .defaultValue()
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
