//
//  WTModelMaker.swift
//  WTKit
//
//  Created by 宋文通 on 21/11/2016.
//  Copyright © 2016 宋文通. All rights reserved.
//  https://github.com/songwentong/WTKit
//
/*
  自动生成Codable的对象,可以处理字段和swift关键字重名的情况,能正确处理super,import,class这类字段
 可在属性添加前缀和后缀,自动解析嵌套类型,用JSONDecoder读取json数据可以直接生成一个已经赋值的类的实例.
 
 核心
 一,根据JSON生成对应数据结构的类(支持嵌套)
 二,关键字过滤重定义key,比如return
 三,支持程序输出和控制台输出 description
 四,测试功能
 
 这个类的功能目前还是有限的,有几个情况目前无法很好的处理,需要手动修改
 1.不支持特殊符号-
 
 */
import Foundation
public extension NSValue{
    func objCTypeString() -> String {
        let objCType = self.objCType
        let type = String.init(cString: objCType)
        return type
    }
    
}
class TestNameClass {
//    var @objc:Int = 1
//    var default
//    var fileprivate
    //var unowned:Int = 1
    var Int:Int = 1
    var Double:Int = 1
    var Float:Int = 1
    var Set:Int = 1
//    var subscript:Int = 1
    var get:Int = 1
//    var static:Int = 1
//    var case:Int = 1
    var print:Int = 1
    var unowned:Int = 1
    var didSet:Int = 1
    var precedence:Int = 1
    var __var:Int = 1
//    var typealias:Int = 1
//    var switch
//    var _:Int = 1
//    var "init":Int = 1
//    var operator:Int = 1
//    var internal:Int = 1
//    var else:Int = 1
//    var fallthrough:Int = 1
}
/*
 Swift Keywords used in Declarations------------------------------
 
 class    deinit    enum    extension
 func    import    init    internal
 let    operator    private    protocol
 public    static    struct    subscript
 typealias    var
 
 
 Swift Keywords used in Statements------------------------------
 
 break    case    continue    default
 do    else    fallthrough    for
 if    in    return    switch
 where    while
 
 
 Swift Keywords used in Expressions and Types------------------------------
 
 as    dynamicType    false    is
 nil    self    Self    super
 true    _COLUMN_    _FILE_    _FUNCTION_
 _LINE_
 
 Swift Keywords used in Specific Contexts------------------------------
 
 associativity    convenience    dynamic    didSet
 final    get    infix    inout
 lazy    left    mutating    none
 nonmutating    optional    override    postfix
 precedence    prefix    protocol    required
 right    set    Type    unowned
 weak    willSet
 */
public class WTModelMaker {
    public var commonKeywords:[String] = String.systemKeyWords//常用的关键字命名修改,如有需要可以添加
    public var keywordsVarPrefix = ""//关键字属性的前缀,如有需要可以添加
    public var keywordsVarSuffix = "_var"//关键字属性的后缀,默认添加的是_var
    public var needOptionalMark:Bool = true //是否需要添加问号,来处理字段不存在的情况,true+问号?,否则不用加
    public var useStruct = false //true用struct,false用class
    public var shouldHasDefaultValut = false //是否需要默认值，如果需要默认值
    public var indent:String = "    "//缩进
    ///是否使用数据兼容,可以用于Int/Double/String类型兼容,
    ///默认ture,用于兼容服务器数据异常
    public var useStringOrNumber = true
    public let crlf = "\n"//换行
    var useCodingKey = true//是否使用coding key,如果不用,关键字命名会变成`
    
    public static let `default`:WTModelMaker = {
       return WTModelMaker()
    }()
    func randomClassName(with prefix:String)->String{
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
        stringToPrint += "//  site:https://github.com/songwentong/ModelMaker\n//  Thank you for use my json model maker😜\n//\n\n"
        return stringToPrint;
    }
    private func keyTransform(with origin:String) -> String {
        return nameReplace(with: keyReplace(with: origin))
    }
    private func keyReplace(with origin:String)->String{
        if useCodingKey{
            return origin.replacingOccurrences(of: "-", with: "_")
        }else{
            return origin
        }
    }
    private func nameReplace(with origin:String)->String{
        if commonKeywords.contains(origin){
            if useCodingKey{
                return keywordsVarPrefix + origin + keywordsVarSuffix
            }else{
                return "`\(origin)`"
            }
        }else{
            
        }
        return origin
    }
    
    func optionalMarkIfNeeded() -> String {
        if needOptionalMark{
            return "?"
        }
        return ""
    }
    func getClassOrStructName() -> String {
        if useStruct {
            return "struct"
        }else{
            return "class"
        }
    }
    
    /// 尝试打印出一个json对应的Model属性
    /// NSArray和NSDictionary可能需要自定义为一个model类型
    public func WTSwiftModelString(with className:String = "XXX", jsonString:String, usingHeader:Bool = false, isRootClass:Bool = true)->String{
        
        var stringToPrint:String = String()
        var subClassString = "\n"
        var codingKeys:String = String()
        
        if usingHeader == true {
            stringToPrint += headerString(className: className)
        }
        var subModelDict:[String:String] = [String:String]()
        if isRootClass {
            stringToPrint += "import Foundation\n"
        }
        stringToPrint += "public"
        stringToPrint += " "
        stringToPrint += getClassOrStructName()
        stringToPrint += " "
        stringToPrint += "\(className):"
        let initMethod = """
                        public override init() {
                            super.init()
                        }
                    """
        if useStruct{
            stringToPrint += "Codable,CustomStringConvertible,CustomDebugStringConvertible {"
        }else{
            stringToPrint += "NSObject, Codable {"
            stringToPrint += crlf
            stringToPrint += initMethod
        }
        
        
        
        codingKeys = "    enum CodingKeys: String, CodingKey {" + crlf
//        let formatedString = jsonString.replacingOccurrences(of: "-", with: "_")
        var propertyNames = [String]()
        var jsonObject:Any? = nil
        do {
            if let data = jsonString.data(using: String.Encoding.utf8){
                jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            }
        } catch {
            
        }
        ///自定义Decodable内核
        var customDecodableStringCore = ""
        var typeString = ""
        if let printObject = jsonObject as? [String:AnyObject] {
            for (key,value) in printObject{
                //object k-v
                let nameReplacedKey = keyTransform(with: key)
                propertyNames.append(nameReplacedKey)
                stringToPrint += crlf
                stringToPrint += indent
                stringToPrint += "var \(nameReplacedKey):"
                if value is String {
                    
                    typeString = "String"
                    stringToPrint += "String"
                    
//                    typeString = "String"
                    
                    stringToPrint += optionalMarkIfNeeded()
                    if !useStruct{
                        stringToPrint += " = \"\""
                    }
                }else if let number = value as? NSNumber{
                    var defaultValue = " = false"
                        //char, short int, int, long int, long long int, float, or double or as a BOOL
                        // “c”, “C”, “s”, “S”, “i”, “I”, “l”, “L”, “q”, “Q”, “f”, and “d”.
                        //1->q    true->c     1.0->d   6766882->q   6766882.1->d   0->q   false->c
                        let objCType = number.objCType
                        let type = String.init(cString: objCType)
                        
                        switch type{
                            case "c":
                                typeString = "Bool"
                                break
                            case "q":
                                typeString = "Int"
                                defaultValue = " = -1"
                                break
                            case "d":
                                typeString = "Double"
                                defaultValue = " = -1"
                                break
                            default:
                                typeString = "Int"
                                defaultValue = " = -1"
                                break
                        }
                    
                    
                    stringToPrint += "\(typeString)"
                    stringToPrint += optionalMarkIfNeeded()
                    if !useStruct{
                        stringToPrint += defaultValue
                    }
                    
                } else if value is Array<Any>{
                    if value is [Int]{
                        //print("int array")
                        typeString = "[Int]" + optionalMarkIfNeeded()
                        stringToPrint += "\(typeString) = [Int]()"
                    }else if value is [Double]{
                        typeString = "[Double]" + optionalMarkIfNeeded()
                        stringToPrint += "\(typeString) = [Double]()"
                    }
                    else if value is [String]{
                        //print("string array")
                        typeString = "[String]" + optionalMarkIfNeeded()
                        stringToPrint += "\(typeString) = [String]()"
                    }else{
                        guard let list = value as? [Any] else{
                            return ""
                        }
                        guard let first = list.first else{
                            return ""
                        }
                        if let data = try? JSONSerialization.data(withJSONObject: first, options: []){
                            let valueString = data.utf8String
                            let subClassName = className + "_" +  nameReplacedKey
                            subClassString += self.WTSwiftModelString(with: subClassName, jsonString: valueString, usingHeader: false, isRootClass:false)
                            stringToPrint += "[\(subClassName)] = [\(subClassName)]()"
                        }
                    }
                    
                }else if value is Dictionary<AnyHashable, Any>{
                    if let tempData = try? JSONSerialization.data(withJSONObject: value, options: []){
                        let tempString = String.init(data: tempData, encoding: String.Encoding.utf8)
                        let subClassName = nameReplacedKey + "_class"
                        subModelDict[subClassName] = tempString
                        stringToPrint += "\(subClassName)"
                        if !useStruct{
                            stringToPrint += " = \(subClassName)()"
                        }
                    }
                }
                //                    codingKeys += crlf
                codingKeys += indent
                codingKeys += indent
                
                codingKeys += "case \(nameReplacedKey) = \"\(key)\""
                codingKeys += crlf
                
//                stringToPrint += crlf
                /**
                 if values.allKeys.contains(.c){
                     let cValue = try values.decode(StringOrNumber.self, forKey: .c)
                     c = cValue.doubleValue()
                 }
                 */
                if needOptionalMark{
                    customDecodableStringCore += indent
                    customDecodableStringCore += indent
                    customDecodableStringCore += "if values.allKeys.contains(.\(nameReplacedKey)){"
                    customDecodableStringCore += crlf
                }
                if needOptionalMark{
                    customDecodableStringCore += indent
                }
                customDecodableStringCore += indent
                customDecodableStringCore += indent
                if typeString == "Int"{
                    //        let str = try values.decode(StringOrNumber.self, forKey: .a)
                    //        a = str.intValue()
                    customDecodableStringCore += "let \(nameReplacedKey)Value = try values.decode(StringOrNumber.self, forKey: .\(nameReplacedKey))"
                    customDecodableStringCore += crlf
                    if needOptionalMark{
                        customDecodableStringCore += indent
                    }
                    customDecodableStringCore += indent
                    customDecodableStringCore += indent
                    customDecodableStringCore += "\(nameReplacedKey) = \(nameReplacedKey)Value.intValue()"
                }else if typeString == "Double"{
                    customDecodableStringCore += "let \(nameReplacedKey)Value = try values.decode(StringOrNumber.self, forKey: .\(nameReplacedKey))"
                    customDecodableStringCore += crlf
                    customDecodableStringCore += indent
                    customDecodableStringCore += indent
                    if needOptionalMark{
                        customDecodableStringCore += indent
                    }
                    customDecodableStringCore += "\(nameReplacedKey) = \(nameReplacedKey)Value.doubleValue()"
                }else if typeString == "String"{
                    customDecodableStringCore += "let \(nameReplacedKey)Value = try values.decode(StringOrNumber.self, forKey: .\(nameReplacedKey))"
                    customDecodableStringCore += crlf
                    customDecodableStringCore += indent
                    customDecodableStringCore += indent
                    if needOptionalMark{
                        customDecodableStringCore += indent
                    }
                    customDecodableStringCore += "\(nameReplacedKey) = \(nameReplacedKey)Value.stringValue()"
                }else{
                    customDecodableStringCore += """
        \(nameReplacedKey) = try values.decode(\(typeString).self, forKey: .\(nameReplacedKey))
        """
                }
                if needOptionalMark {
                    customDecodableStringCore += crlf
                    customDecodableStringCore += indent
                    customDecodableStringCore += indent
                    customDecodableStringCore += "}"
                }
                customDecodableStringCore += crlf
                
                
            }//end for
            codingKeys = codingKeys + indent + "}" + crlf
            stringToPrint = stringToPrint + "\n"
            //确保对象不为空,如果为空就不用加CodingKeys了
            if useCodingKey,!printObject.isEmpty {
                stringToPrint = stringToPrint + codingKeys
            }
            let customPrefix = """
                        required public init(from decoder: Decoder) throws {
                            let values = try decoder.container(keyedBy: CodingKeys.self)
                    """
            let customDecodableMethodString = customPrefix + crlf + customDecodableStringCore + indent + "}" + crlf
            if useStringOrNumber{
                stringToPrint += customDecodableMethodString
            }
            stringToPrint = stringToPrint + "}" + crlf
        }
        
        
        //start of public extension
        //Unmanaged.passUnretained(self).toOpaque()
        //<ModelMaker.ViewController: 0x600003d0c3c0>
//        let memory = Unmanaged.passUnretained(self).toOpaque()
        //TODO 包名
//        let bundleName = ""
        var debugDescription = "        return \"\"\"\n        <\(className): "
        debugDescription += "\\"
        debugDescription += "("
        debugDescription += "Unmanaged.passUnretained(self).toOpaque()"
        debugDescription += ")>\n"
        for str in propertyNames{
            debugDescription += "        \(str):"
            debugDescription += "\\"
            debugDescription += "("
            debugDescription += str
            debugDescription += ")"
            debugDescription += "\n"
        }
        debugDescription += "\"\"\""
        /*
        var debugDescription = propertyNames.reduce(into: String()) { (result, str) in
            result += "        \(str):"
            result += "\\"
            result += "("
            result += str
            result += ")"
            result += "\n"
//            result += "n"
        }
        debugDescription = "        return \"\"\"\n        debugDescription of \(className):\n" + debugDescription + "\"\"\""
        */
        stringToPrint.append("public extension \(className){\n")
        if !useStruct{
            stringToPrint.append("\(indent)override ")
        }
        stringToPrint.append("var description: String{\n        return debugDescription\n    }\n")
        if !useStruct{
        stringToPrint.append("\(indent)override ")
        }
        stringToPrint.append("var debugDescription: String{\n")
        stringToPrint += debugDescription + "\n"
        stringToPrint.append("    }\n")
        stringToPrint.append("}")
        stringToPrint += subClassString
        for (key,value) in subModelDict{
            stringToPrint += WTSwiftModelString(with: key, jsonString: value,usingHeader: false,isRootClass: false)
        }//end of class
        return stringToPrint
    }
}
