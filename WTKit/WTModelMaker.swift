//
//  JSONModel.swift
//  WTKit
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
/*
  自动生成Codable的对象,可以处理字段和swift关键字重名的情况,能正确处理super,import,class这类字段
 可在属性添加前缀和后缀,自动解析嵌套类型,用JSONDecoder读取json数据可以直接生成一个已经赋值的类的实例.
 */
import Foundation
public class WTModelMaker {
    public var commonKeywords:[String] = ["super","class","var","let","sturct","func","private","public","open","return","import"]//常用的关键字,如有需要可以添加
    public var keywordsVarPrefix = ""//关键字属性的前缀,如有需要可以添加
    public var keywordsVarSuffix = "_var"//关键字属性的后缀,默认添加的是_var
    public var needQuestionMark:Bool = false //是否需要添加问号
    open static let `default`:WTModelMaker = {
       return WTModelMaker()
    }()
    public func randomClassName(with prefix:String)->String{
        let randomNumber = arc4random_uniform(150)
        let suffix = String.init(randomNumber)
        return prefix+suffix
    }
    
    private func headerString(className:String)->String{
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        var stringToPrint = ""
        stringToPrint += "//\n//  \(className).swift\n"
        stringToPrint += "//\n//  this file is auto create by WTKit on \(dateString).\n"
        stringToPrint += "//  site:https://github.com/swtlovewtt/WTKit\n//  Thank you for use my json model maker😜\n//\n\n"
        return stringToPrint;
    }
    private func nameReplace(with origin:String)->String{
        if commonKeywords.contains(origin){
            return keywordsVarPrefix + origin + keywordsVarSuffix
        }
        return origin
    }
    
    func QuestionMarkIfNeeded() -> String {
        if needQuestionMark{
            return "?"
        }
        return ""
    }
    func CRLF() -> String {
        return "\n"
    }
    
    /// 尝试打印出一个json对应的Model属性
    /// NSArray和NSDictionary可能需要自定义为一个model类型
    public func WTSwiftModelString(with className:String = "XXX", jsonString:String,usingHeader:Bool = false)->String{
        
        var stringToPrint:String = String()
        
        var codingKeys:String = String()
        
        if usingHeader == true {
            stringToPrint += headerString(className: className)
        }
        var subModelDict:[String:String] = [String:String]()
        stringToPrint += "public struct \(className): Codable {\n"
        codingKeys = "    enum CodingKeys: String, CodingKey {\n"
        var jsonObject:Any? = nil
        do {
            if let data = jsonString.data(using: String.Encoding.utf8){
                jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            }
        } catch {
            
        }
        if let printObject = jsonObject as? [String:AnyObject] {
            for (key,value) in printObject{
                let nameReplacedKey = nameReplace(with: key)
                var needAddCodingKey = true
                if let classForCoder = value.classForCoder {
                    var string = NSStringFromClass(classForCoder)
                    if string == "NSString" {
                        string = "String"
                        stringToPrint += "    var \(nameReplacedKey):\(string)"
                        
                    }else if string == "NSNumber"{
                        //char, short int, int, long int, long long int, float, or double or as a BOOL
                        // “c”, “C”, “s”, “S”, “i”, “I”, “l”, “L”, “q”, “Q”, “f”, and “d”.
                        //1->q    true->c     1.0->d   6766882->q   6766882.1->d   0->q   false->c
                        let number:NSNumber = value as! NSNumber
                        let objCType = number.objCType
                        let type = String.init(cString: objCType)
                        switch type{
                        case "c":
                            string = "Bool"
                            break
                        case "q":
                            string = "Int"
                            break
                        case "d":
                            string = "Double"
                            break
                        default:
                            string = "Int"
                            break
                        }
                        stringToPrint += "    var \(nameReplacedKey):\(string)"
                        
                    } else if string == "NSArray"{
                        if value is [Int]{
                            //print("int array")
                            stringToPrint += "    var \(nameReplacedKey):[Int]"
                        }else if value is [String]{
                            //print("string array")
                            stringToPrint += "    var \(nameReplacedKey):[String]"
                        }else{
                            stringToPrint += "    //var \(nameReplacedKey):[Any]"
                            needAddCodingKey = false
                        }
                        
                    }else if string == "NSDictionary"{
                        if value is [String:Int]{
                            stringToPrint += "    var \(nameReplacedKey):[String:Int]"
                        }else if value is [String:String]{
                            stringToPrint += "    var \(nameReplacedKey):[String:String]"
                        }else{
                            let tempData = try! JSONSerialization.data(withJSONObject: value, options: [])
                            let tempString = String.init(data: tempData, encoding: String.Encoding.utf8)
                            subModelDict[nameReplacedKey] = tempString
                            stringToPrint += "    var \(nameReplacedKey):\(nameReplacedKey)"
                        }
                    }
                    if needAddCodingKey{
                        codingKeys += "        case \(nameReplacedKey) = \"\(key)\""
                    }else{
                        codingKeys += "        //case \(nameReplacedKey) = \"\(key)\""
                    }
                    codingKeys += CRLF()
                }
                stringToPrint += QuestionMarkIfNeeded()
                stringToPrint += CRLF()
            }
        }
        codingKeys += "    }\n"
        stringToPrint += codingKeys
        stringToPrint += "}\n"
        for (key,value) in subModelDict{
            stringToPrint += WTSwiftModelString(with: key, jsonString: value)
        }
        return stringToPrint
//        print("\(stringToPrint)")
    }
    
    
}





























