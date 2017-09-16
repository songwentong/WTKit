//
//  JSONModel.swift
//  WTKit
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
import Foundation

/*
 我做这个方案完全是为了解决服务端的程序员数据结构错乱的情况
 比如要的是个数组,给了个字符串,要的是字符串给一个null.
 这个方案并不适合Int,Float类型
 适合的类型有String,NSNumber,[AnyObject],[String:AnyObject]
 其中的Any对应的Class需要在协议中给出指定的类
 */
@objc public protocol WTJSONModelProtocol:NSObjectProtocol {
    
    /// 对于某属性(目前是array和dictionary)的实例给出类型
    ///
    /// - Parameter property: 属性名
    /// - Returns: 给出实例
    @objc optional func WTJSONModelClass(for property:String)->AnyObject?
    
}
public class SWTModel: NSObject{
    
}
@objc extension NSObject {
    
    
    public func travelWTJSONModel(with data:Data){
        if let dict = data.parseJson(){
            self.wt(travel: dict)
        }
    }
    /// 遍历给出的JSON数据,赋值给本类(可嵌套,只要实现
    /// WTJSONModelProtocol给出字段对应的自定义类型的对象即可)
    /// null并没有读取,因为这个类型是没有意义的
    /// - Parameter inputData: 解析过的json数据
    @objc public func wt(travel inputData:Any?){
        if let dictionary = inputData as? [String:Any] {
            var outCount:UInt32 = 0;
            let plist:UnsafeMutablePointer<objc_property_t>? = class_copyPropertyList(self.classForCoder,&outCount)
            

            //遍历属性
            for i in 0..<outCount{
                let property:objc_property_t = plist![Int(i)]
                let propertygetName:UnsafePointer<Int8> = property_getName(property)
                let propertygetAttributes:UnsafePointer<Int8> = property_getAttributes(property)!
                let propertygetNameString:String = String(cString: propertygetName)
                let propertygetAttributesString:String = String(cString: propertygetAttributes)
                let propertygetAttributesArray:[String] = propertygetAttributesString.components(separatedBy: ",")
                var className = ""
                var instanceVariableName = ""
                for (item)in propertygetAttributesArray{
                    if item.prefix(1) == "T"{
                        
                    }
                    //item example:   "T@\"NSNumber\""   T->property type
                    if item.substring(to: item.index(item.startIndex, offsetBy: 1)) == "T" {
                        //类型
                        let typeString:String = item
                        let classNameindex = typeString.index(typeString.startIndex, offsetBy: 1)
                        className = typeString.substring(from: classNameindex)
                        if let _ = className.removingPercentEncoding {
                            className = className.removingPercentEncoding!
                        }
                    }
                    //item example: V + property name
                    if item.substring(to: item.index(item.startIndex, offsetBy: 1)) == "V"{
                        //字段名
                        let typeString:String = item
                        let classNameindex = typeString.index(typeString.startIndex, offsetBy: 1)
                        instanceVariableName = typeString.substring(from: classNameindex)
//                        print("\(instanceVariableName)")
                        if let _ = typeString.removingPercentEncoding {
                            instanceVariableName = instanceVariableName.removingPercentEncoding!
                        }
                    }

                    
                }
/*
                print("\(property) \(propertygetName) instanceVariableName:\(instanceVariableName) className: \(className) \(propertygetAttributes) \(propertygetNameString) propertygetAttributesString: \(propertygetAttributesString)  \n")
                
*/
                className = className.substring(from: className.startIndex)
                className = className.substring(from: className.startIndex)
                className = className.substring(to: className.endIndex)
                if(className.contains("NSString")){
                    if let string = dictionary[instanceVariableName] as? String{
                        self.setValue(string, forKey: propertygetNameString)
                    }
                }else if (className.contains("NSNumber")){
                    if let number = dictionary[instanceVariableName] as? NSNumber {
                        self.setValue(number, forKey: propertygetNameString)
                    }
                }else if(className).contains("NSArray"){
                    //array
                    if let array = dictionary[instanceVariableName] as? [AnyObject] {
                        let selector = #selector(WTJSONModelProtocol.WTJSONModelClass(for:))
                        if self.responds(to: selector){
                            var myArray = [AnyObject]()
                            for item in array{
                                if self.perform(selector, with: instanceVariableName) != nil{
                                    let instance = self.perform(selector, with: instanceVariableName).takeUnretainedValue()
                                    instance.wt(travel: item)
                                    myArray.append(instance)
                                }else{
                                    myArray.append(item)
                                }
                                
                            }
                            self.setValue(myArray, forKey: instanceVariableName)
                        }
                    }
                }else {
                    //dictionary
                    let selector = #selector(WTJSONModelProtocol.WTJSONModelClass(for:))
                    if self.responds(to: selector){
                        if self.perform(selector, with: instanceVariableName) != nil{
                            let instance = self.perform(selector, with: instanceVariableName).takeUnretainedValue()
                            instance.wt(travel: dictionary[instanceVariableName])
                            self.setValue(instance, forKey: instanceVariableName)
                        }else{
                            self.setValue(dictionary[instanceVariableName], forKey: instanceVariableName)
                            
                            //self.setValue(dictionary[instanceVariableName]), forKey: instanceVariableName)
                        }
                        
                    }
                }
                }
            }
            
        }
    
    
    /// 尝试打印出一个json对应的Model属性
    /// NSArray和NSDictionary可能需要自定义为一个model类型
    public func WTSwiftModelString(_ className:String = "XXX")->String{
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        var stringToPrint = ""
        stringToPrint += "//\n//  \(className).swift\n"
        stringToPrint += "//\n//  this file is auto create by WTKit on \(dateString).\n"
        stringToPrint += "//  site:https://github.com/swtlovewtt/WTKit\n//  Thank you for use my json model maker\n//\n\n"
        stringToPrint += "import WTKit\n"
        stringToPrint += "import UIKit\n"
        stringToPrint += "open class \(className): NSObject {\n"
        if let printObject = self as? [String:AnyObject] {
            for (key,value) in printObject{
                if let classForCoder = value.classForCoder {
                    var string = NSStringFromClass(classForCoder)
                    if string == "NSString" {
                        string = "String"
                    }else if string == "NSArray"{
                        string = "[Any]"
                    }else if string == "NSDictionary"{
                        string = "[String:Any]"
                    }
                    stringToPrint += "    var \(key):\(string)?\n"
                }
            }
        }
        stringToPrint += "}\n"
        stringToPrint += "extension \(className):WTJSONModelProtocol{\n"
        stringToPrint += "    public func WTJSONModelClass(for property:String)->AnyObject?{\n        return nil\n    }\n"
        stringToPrint += "}"
        return stringToPrint
//        print("\(stringToPrint)")
    }
    
    
    /// 尝试把一个Model转换成JSON格式,便于本地化储存
    ///
    /// - Returns: 返回一个JSON格式数据
    @objc public func WTAttempConvertToJSON()->[String:Any]{
        
            var result = [String:Any]()
            var outCount:UInt32 = 0;
            let plist:UnsafeMutablePointer<objc_property_t>? = class_copyPropertyList(self.classForCoder,&outCount)
            
            //遍历属性
            for i in 0..<outCount{
                let property:objc_property_t = plist![Int(i)]
//                let propertygetName:UnsafePointer<Int8> = property_getName(property)
                let propertygetAttributes:UnsafePointer<Int8> = property_getAttributes(property)!
//                let propertygetNameString:String = String(cString: propertygetName)
                let propertygetAttributesString:String = String(cString: propertygetAttributes)
                let propertygetAttributesArray:[String] = propertygetAttributesString.components(separatedBy: ",")
                var className = ""
                var instanceVariableName = ""
                for (item)in propertygetAttributesArray{
                    
                    //type
                    if item.substring(to: item.index(item.startIndex, offsetBy: 1)) == "T" {
                        //类型
                        let typeString:String = item
                        let classNameindex = typeString.index(typeString.startIndex, offsetBy: 1)
                        className = typeString.substring(from: classNameindex)
                        if let _ = className.removingPercentEncoding {
                            className = className.removingPercentEncoding!
                        }
                    }
                    //name
                    if item.substring(to: item.index(item.startIndex, offsetBy: 1)) == "V"{
                        //字段名
                        let typeString:String = item
                        let classNameindex = typeString.index(typeString.startIndex, offsetBy: 1)
                        instanceVariableName = typeString.substring(from: classNameindex)
                        //                        print("\(instanceVariableName)")
                        if let _ = typeString.removingPercentEncoding {
                            instanceVariableName = instanceVariableName.removingPercentEncoding!
                        }
                    }
                    
                    
                }
                /*
                 print("\(property) \(propertygetName) instanceVariableName:\(instanceVariableName) className: \(className) \(propertygetAttributes) \(propertygetNameString) propertygetAttributesString: \(propertygetAttributesString)  \n")
                 
                 */
                className = className.substring(from: className.startIndex)
                className = className.substring(from: className.startIndex)
                className = className.substring(to: className.endIndex)
                if let value = self.value(forKey: instanceVariableName) {
                    if let string = value as? String {
                        result.updateValue(string, forKey: instanceVariableName)
                    }else if let number = value as? NSNumber {
                        result.updateValue(number, forKey: instanceVariableName)
                    }else if let array = value as? [Any] {
                        var myArray = [Any]()
                        for item in array{
//                            if let itemObject:AnyObject = item as? AnyObject{
                                if let attemtJSON:AnyObject = (item as AnyObject).WTAttempConvertToJSON as AnyObject? {
                                    myArray.append(attemtJSON)
//                                }
                            }
                        }
                        result.updateValue(myArray, forKey: instanceVariableName)
                    }else{
                        
                    }
                }
            }
            return result
        }
    
}
extension JSONSerialization {
    
    
    /*
     JSON解析,去掉了null
     */
    public class func WTJSONObject(with data:Data,options opt:JSONSerialization.ReadingOptions = [])->Any?{
        do {
            var obj:Any = try jsonObject(with: data, options: opt)
            if let result = WTRemoveNull(with: obj, replaceNullWith: { () -> Any? in
                return ""
            }) {
                obj = result
            }
            return obj
        } catch {
        }
        return nil
    }
    
    
    /*
     把已知的数据结构改动一下,遍历所有的数据,找到null,然后把它替换成需要的数据
     如果穿nil,会把这个字段去掉,建议直接返回空字符串("")
     */
    public class func WTRemoveNull(with inputData:Any, replaceNullWith:(()->Any?))->Any?{
        if let _ = inputData as? NSNull {
            let c = replaceNullWith()
            return c
        }else if let array = inputData as? [Any]{
            var returnArray:[Any] = [Any]()
            for item:Any in array{
                if let result = WTRemoveNull(with: item, replaceNullWith: replaceNullWith) {
                    returnArray.append(result)
                }
            }
            return returnArray
        }else if let dictionary = inputData as? [String:Any]{
            var returnDict:[String:Any] = [String:Any]()
            for(k,v)in dictionary{
                if let result = WTRemoveNull(with: v, replaceNullWith: replaceNullWith){
                    returnDict.updateValue(result, forKey: k)
                }
            }
            return returnDict
        }
        return inputData
    }
}





























