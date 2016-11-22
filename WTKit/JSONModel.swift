//
//  JSONModel.swift
//  WTKit
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import Foundation

/*
 我做这个方案完全是为了解决服务端的程序员数据结构错乱的情况
 比如要的是个数组,给了个字符串,要的是字符串给一个null.
 这个方案并不适合Int,Float类型
 适合的类型有String,NSNumber,[Any],[String:Any]
 其中的Any对应的Class需要在协议中给出指定的类
 */
@objc public protocol WTJSONModelProtocol:NSObjectProtocol {
    
    
    /// 数据为null时候的处理
    ///
    /// - Returns: 返回nil去掉此字段,通常建议返回空字符串("")
    @objc optional func WTJSONModelValueForNull()->Any?
    
    /// 对于某属性(目前是array和dictionary)的实例给出类型
    ///
    /// - Parameter property: 属性名
    /// - Returns: 给出实例
    @objc optional func WTJSONModelClass(for property:String)->AnyObject?
}
extension NSObject{
    
    public func wt(travel inputData:Any?){
        if let dictionary = inputData as? [String:Any] {
            var outCount:UInt32 = 0;
            let plist:UnsafeMutablePointer<objc_property_t?> = class_copyPropertyList(self.classForCoder,&outCount)
            
            //遍历属性
            for i in 0..<outCount{
                let property:objc_property_t = plist[Int(i)]!
                let propertygetName:UnsafePointer<Int8> = property_getName(property)
                let propertygetAttributes:UnsafePointer<Int8> = property_getAttributes(property)
                let propertygetNameString:String = String(cString: propertygetName)
                let propertygetAttributesString:String = String(cString: propertygetAttributes)
                let propertygetAttributesArray:[String] = propertygetAttributesString.components(separatedBy: ",")
                var className = ""
                var instanceVariableName = ""
                for (item)in propertygetAttributesArray{
                    if item.substring(to: item.index(item.startIndex, offsetBy: 1)) == "T" {
                        //类型
                        let typeString:String = item
                        let classNameindex = typeString.index(typeString.startIndex, offsetBy: 1)
                        className = typeString.substring(from: classNameindex)
                        if let _ = className.removingPercentEncoding {
                            className = className.removingPercentEncoding!
                        }
                    }
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
                    
                    if let array = dictionary[instanceVariableName] as? NSArray {
                        let selector = #selector(WTJSONModelProtocol.WTJSONModelClass(for:))
                        if self.responds(to: selector){
                            var myArray = [Any]()
                            for item in array{
                                let instance = self.perform(selector, with: instanceVariableName).takeUnretainedValue()
                                instance.wt(travel: item)
                                myArray.append(instance)
                            }
                            self.setValue(myArray, forKey: instanceVariableName)
                        }
                    }
                }else {
                    let selector = #selector(WTJSONModelProtocol.WTJSONModelClass(for:))
                    if self.responds(to: selector){
                        let instance = self.perform(selector, with: instanceVariableName).takeUnretainedValue()
                        instance.wt(travel: dictionary[instanceVariableName])
                        self.setValue(instance, forKey: instanceVariableName)
                    }
                }
                }
                
                
            }
            
        }
    }
    





























