//
//  JSONModel.swift
//  WTKit
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
import Foundation
extension NSObject {
    
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
        stringToPrint += "//  site:https://github.com/swtlovewtt/WTKit\n//  Thank you for use my json model maker\n//\n\n"
        return stringToPrint;
    }
    
    /// 尝试打印出一个json对应的Model属性
    /// NSArray和NSDictionary可能需要自定义为一个model类型
    public func WTSwiftModelString(with className:String = "XXX", jsonString:String,usingHeader:Bool = false)->String{
        
        var stringToPrint:String = String()
        if usingHeader == true {
            stringToPrint += headerString(className: className)
        }
        var subModelDict:[String:String] = [String:String]()
        stringToPrint += "public struct \(className): Codable {\n"
        var jsonObject:Any? = nil
        do {
            if let data = jsonString.data(using: String.Encoding.utf8){
                jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            }
        } catch {
            
        }
        if let printObject = jsonObject as? [String:AnyObject] {
            for (key,value) in printObject{
                if let classForCoder = value.classForCoder {
                    var string = NSStringFromClass(classForCoder)
                    if string == "NSString" {
                        string = "String"
                        stringToPrint += "    var \(key):\(string)\n"
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
                        stringToPrint += "    var \(key):\(string)\n"
                    } else if string == "NSArray"{
                        if value is [Int]{
                            //print("int array")
                            stringToPrint += "    var \(key):[Int]\n"
                        }else if value is [String]{
                            //print("string array")
                            stringToPrint += "    var \(key):[String]\n"
                        }else{
                            stringToPrint += "    //var \(key):[Any]\n"
                            //array object
                            /*
                            let tempClassName = self.randomClassName(with: key)
                            let tempData = try! JSONSerialization.data(withJSONObject: value, options: [])
                            let tempString = String.init(data: tempData, encoding: String.Encoding.utf8)
                            subModelDict[tempClassName] = tempString
                            */
                        }
                        
                    }else if string == "NSDictionary"{
                        if value is [String:Int]{
                            stringToPrint += "    var \(key):[String:Int]\n"
                        }else if value is [String:String]{
                            stringToPrint += "    var \(key):[String:String]\n"
                        }else{
//                            stringToPrint += "    //var \(key):[String:Any]\n"
//                            let tempClassName = self.randomClassName(with: key)
                            let tempData = try! JSONSerialization.data(withJSONObject: value, options: [])
                            let tempString = String.init(data: tempData, encoding: String.Encoding.utf8)
                            subModelDict[key] = tempString
                            stringToPrint += "    var \(key):\(key)\n"
                        }
                    }
                    
                }
            }
        }
        stringToPrint += "}\n"
        for (key,value) in subModelDict{
            stringToPrint += WTSwiftModelString(with: key, jsonString: value)
        }
        return stringToPrint
//        print("\(stringToPrint)")
    }
    
    
}





























