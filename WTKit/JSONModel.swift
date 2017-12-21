//
//  JSONModel.swift
//  WTKit
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
import Foundation


public class SWTModel: NSObject{
    
}
extension NSObject {
    
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
        stringToPrint += "extension \(className){\n"
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
            let plist = class_copyPropertyList(self.classForCoder,&outCount)
            
            //遍历属性
            for i in 0..<outCount{
                let property:objc_property_t = plist![Int(i)]
                let propertygetAttributes:UnsafePointer<Int8> = property_getAttributes(property)!
                let propertygetAttributesString:String = String(cString: propertygetAttributes)//"T@\"UIWindow\",N,&,Vwindow"
                let propertygetAttributesArray:[String] = propertygetAttributesString.components(separatedBy: ",")
                var instanceVariableName = ""
                for (item) in propertygetAttributesArray{
                    
                    //name
                    if item.prefix(1) == "V"{
                        let index = item.startIndex
                        let substring = item.suffix(from: index)
                        instanceVariableName = String(substring)
                    }
                    
                    
                    
                }
                if let value = self.value(forKey: instanceVariableName) {
                    if let string = value as? String {
                        result.updateValue(string, forKey: instanceVariableName)
                    }else if let number = value as? NSNumber {
                        result.updateValue(number, forKey: instanceVariableName)
                    }else if let array = value as? [Any] {
                        var myArray = [Any]()
                        for item in array{
                            let object:AnyObject = item as AnyObject
                            myArray.append(object.WTAttempConvertToJSON())
                        }
                        result.updateValue(myArray, forKey: instanceVariableName)
                    }else{
                        
                    }
                }
            }
            return result
        }
    
}





























