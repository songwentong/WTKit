//
//  Foundation.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/7.
//  Copyright © 2019 宋文通. All rights reserved.
//  https://github.com/songwentong/WTKit

import Foundation
#if canImport(Combine)
import Combine
#endif
/// Writes the textual representations of the given items into the standard
/// output. with file,function,line(In Debug mode)
public func dprint<T>(_ items:T, separator: String = " ", terminator: String = "\n",file:String = #file, function:String = #function, line:Int = #line) -> Void {
    #if DEBUG
    cprint(items, separator: separator, terminator: terminator,file:file, function:function, line:line)
    #endif
}
/// Writes the textual representations of the given items into the standard
/// output. with file,function,line
public func cprint<T>(_ items: T,  separator: String = " ", terminator: String = "\n",file:String = #file, function:String = #function, line:Int = #line) -> Void {
    print("\((file as NSString).lastPathComponent)[\(line)], \(function): \(items)", separator: separator, terminator: terminator)
}
// MARK: - String
public extension String{
    
    ///[UInt8] Array
    var toBytes:[UInt8] {
        return Array(utf8)
    }
    
    ///get localizedString from main Bundle
    var localizedString: String{
        NSLocalizedString(self, comment: "")
    }
    ///short method
    var wtLocalString:String{
        customLocalizedString
    }
    ///get localizedString from your custom bundle
    var customLocalizedString:String{
        NSLocalizedString(self, bundle: .customBundle,  comment: "")
    }
    ///convert string to Notification.Name
    var notificationName:Notification.Name{
        Notification.Name.init(self)
    }
    ///to NSAttributedString
    var attributedString:NSAttributedString{
        NSAttributedString.init(string: self)
    }
    ///to NSMutableAttributedString
    var mutableAttributedString:NSMutableAttributedString{
        NSMutableAttributedString.init(string: self)
    }
    ///to Data
    var utf8Data:Data{
        data(using: .utf8) ?? Data()
    }
    //create URL
    var urlValue:URL{
        guard let url = URL.init(string: self) else{
            return URL.init(fileURLWithPath: "")
        }
        return url
    }
    //create URLRequest
    var urlRequest:URLRequest{
        URLRequest.init(url: self.urlValue)
    }
    
    var characterSet:CharacterSet{
        return CharacterSet.init(charactersIn: self)
    }
    var mutableCharacterSet:NSMutableCharacterSet{
        return NSMutableCharacterSet.init(charactersIn: self)
    }
    static let generalDelimitersToEncode = ":#[]@"
    static let subDelimitersToEncode = "!$&'()*+,;="
    func localized(_ lang:String) ->String {
        var bundle = Bundle.main
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj") {
            bundle = Bundle(path: path) ?? Bundle.main
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    func convertToLocalizedString(_ tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String) -> String{
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
    var fullWidthString:String{
        if #available(OSX 10.11, iOS 9.0, *) {
            return self.applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? ""
        } else {
            // Fallback on earlier versions
        }
        return ""
    }
    var halfWidthString:String {
        var dict = [String:String]()
        for (index,ele) in String.fullWidthPunctuation().enumerated(){
            for (index2,ele2) in String.halfWidthPunctuation().enumerated(){
                if index == index2{
                    dict["\(ele)"] = "\(ele2)"
                }
            }
        }
        var result = ""
        result = self
        for (k,v) in dict {
            result = result.replacingOccurrences(of: k, with: v)
        }
        return result
    }
    static func fullWidthPunctuation()->String{
        let str =
        """
“”，。：¥
"""
        return str
    }
    static func halfWidthPunctuation()->String{
        let str =
        """
"",.:$
"""
        return str
    }
//    https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html
    static let systemKeyWords:[String] = {
        ["super","class","var","let","struct","func","private","public","return","import","protocol","default","open","Type","lazy","in","for","while","do","self","inout","@objc","open","fileprivate","default","subscript","static","case","if","else","deinit","extension","continue","operator","init","_","fallthrough","internal","true","false","switch","dynamic","typealias"]
    }()
    var escapeString:String {
        addingPercentEncoding(withAllowedCharacters: CharacterSet.wtURLQueryAllowed) ?? self
    }
    
}
public extension NotificationCenter{
    
}

private let testJSON =
"""
{
"name": "Durian",
"points": 600,
"description": "A fruit with a distinctive scent."
}
"""
// MARK: - Data
public extension Data{
    ///convert data to utf8 string
    var utf8String:String{
        return String.init(data: self, encoding: .utf8) ?? "not utf8 string"
    }
    ///parse to json object
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    
    
    func writeToFile( path:String)  {
        let url = URL.init(fileURLWithPath: path)
        do {
            try write(to: url)
        } catch {
            
        }
    }
    static func readDataFromPath( path:String)->Data?{
        let url = URL.init(fileURLWithPath: path)
        do {
            return try Data.init(contentsOf: url)
        } catch {
            return nil
        }
    }
    static func data(forResource name:String, ofType ext: String?) -> Data? {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else{
            return nil
        }
        do {
            let data = try Data.init(contentsOf: url)
            return data
        } catch  {
            return nil
        }
    }
    
}
///block run in debug mode
public func debugBlock(_ block:()->Void) -> Void {
    #if DEBUG
    block()
    #endif
}
///block run in non debug mode
public func releaseBlock(_ block:()->Void) -> Void{
    #if DEBUG
    #else
    block()
    #endif
}
// MARK: - Locale
public extension Locale{
    static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
    static var en_US: Locale {
        return Locale.init(identifier: "en_US")
    }
    static var zh_CN:Locale{
        return Locale.init(identifier: "zh_CN")
    }
    static var ko_kr: Locale{
        return Locale.init(identifier: "ko-Kore_KR")
    }
}
public extension BinaryInteger{
    var byteCountFormatString:String{
        return ByteCountFormatter().string(fromByteCount: Int64.init(self))
    }
    var massFormatterString:String{
        return numberObject.massFormatterString
    }
    var lengthFormatterString:String{
        return numberObject.lengthFormatterString
    }
    var numberObject:NSNumber{
        return NSNumber.init(value: Int(self))
    }
    func stringValue() -> String {
        return "\(self)"
    }
}
public extension ExpressibleByIntegerLiteral{
}
public extension FloatingPoint{
    
}
public extension BinaryFloatingPoint{
    var intValue:Int{
        return Int(self)
    }
    var byteCountFormatString:String{
        return ByteCountFormatter().string(fromByteCount: Int64.init(self))
    }
    var numberObject:NSNumber{
        return NSNumber.init(value: Double(self))
    }
    var massFormatterString:String{
        return numberObject.massFormatterString
    }
    var lengthFormatterString:String{
        return numberObject.lengthFormatterString
    }
    ///string value of self
    var stringValue:String{
        return "\(self)"
    }
}
// MARK: - Int
public extension Int{
//    var floatValue:T:BinaryFloatingPoint{
//    }
    
    var floatValue: Float{
        return Float(self)
    }
    var doubleValue: Double{
        return Double(self)
    }
    var numberFormatterString:String{
        return NumberFormatter().string(from: numberObject) ?? ""
    }
    //    static let testUnit:Int = 1
    //KB, MB, GB, TB, PB, EB, ZB, YB
    static let countPerUnit:Self = 1024
    ///number of bytes in Kib
    static let KiB:Self = {
        return countPerUnit
    }()
    ///number of bytes in MiB
    static let MiB:Self = {
        return KiB * countPerUnit
    }()
    ///number of bytes in GiB
    static let GiB:Self = {
        return MiB * countPerUnit
    }()
    static let TiB:Self = {
        return GiB * countPerUnit
    }()
    static let PiB:Self = {
        return TiB * countPerUnit
    }()
    static let EiB:Self = {
        return PiB * countPerUnit
    }()
    static let ZiB:Self = EiB * countPerUnit
    static let YiB:Self = ZiB * countPerUnit
    ///one minute
    static let minuteSeconds:Self = 60
    ///60min,3600
    static let hourSeconds:Self = minuteSeconds * 60
    ///24hour,86400
    static let daySeconds:Self = hourSeconds * 24
}
public extension Float{
    var numberFormatterString:String{
        return NumberFormatter().string(from: numberObject) ?? ""
    }
}
public extension Double{
    func stringWith(fractionDigits count:Int) -> String? {
        return numberObject.stringWith(fractionDigits: count)
    }
    var numberFormatterString:String{
        return NumberFormatter().string(from: numberObject) ?? ""
    }
}
public extension SIMDScalar{
}
// MARK: - NSNumber
public extension NSNumber{
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
    func stringWith(fractionDigitsCount min:Int, max:Int) -> String? {
        let nf = NumberFormatter.init()
        nf.minimumFractionDigits = min
        nf.maximumFractionDigits = max
        return nf.string(from: self)
    }
    func stringWith(fractionDigits count:Int) -> String? {
        let nf = NumberFormatter.init()
        nf.minimumFractionDigits = count
        nf.maximumFractionDigits = count
        return nf.string(from: self)
    }
    var massFormatterString:String{
        return MassFormatter().string(fromKilograms: doubleValue)
    }
    var lengthFormatterString:String{
        return LengthFormatter().string(fromMeters: doubleValue)
    }
}
// MARK: - DispatchQueue
public extension DispatchQueue{
    static func backgroundQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }
    static func utilityQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
    }
    static func userInitiatedQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
    }
    static func userInteractiveQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    }
    ///安全同步到主线程
    static func safeSyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        let main:DispatchQueue = DispatchQueue.main
        if Thread.isMainThread {
            main.async(execute: work)
        }else{
            main.sync(execute: work)
        }
    }
    static func safeSyncInMain(with workItem:DispatchWorkItem){
        let main:DispatchQueue = DispatchQueue.main
        if Thread.isMainThread {
            workItem.perform()
        }else{
            main.sync(execute: workItem)
        }
    }
    ///异步回到主线程
    static func asyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        DispatchQueue.main.async(execute: work)
    }
    func perform( closure: @escaping () -> Void, afterDelay:Double) -> Void {
        let time = Int64(afterDelay * Double(NSEC_PER_SEC))
        let t:DispatchTime = DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC)
        self.asyncAfter(deadline: t, execute: closure)
    }
    ///delay excute work
    func asyncAfterAfter(_ delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: work)
    }
}
public extension CharacterSet{
    //    var mutableCharacterSet:NSMutableCharacterSet{
    //        return NSMutableCharacterSet.init
    //    }
    static var wtURLQueryAllowed: CharacterSet{
        let str = String.generalDelimitersToEncode + String.subDelimitersToEncode
        let encodableDelimiters = str.characterSet
        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }
}
// MARK: - URLRequest
public extension URLRequest{
    #if canImport(Combine)
    //iOS 13+
    func testCombine() -> Void {
        //        URLSession.sha
    }
    #endif
    ///create URL Request
    static func createURLRequest(with path:String, method:WTHTTPMethod = .get, parameters:[String:Any] = [:], headers:[String:String] = [:]) -> URLRequest {
        var request = URLRequest.init(url: path.urlValue)
        request.httpMethod = method.rawValue
        if !parameters.isEmpty{
            let string = URLRequest.convertParametersToString(parameters: parameters)
            if method.needUseQuery(){
                if var urlComponents = URLComponents(url: path.urlValue, resolvingAgainstBaseURL: false){
                    let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + string
                    urlComponents.percentEncodedQuery = percentEncodedQuery
                    request.url = urlComponents.url
                }
            }else{
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = string.data(using: .utf8)
            }
        }
        
        for (k,v) in headers{
            request.setValue(v, forHTTPHeaderField: k)
        }
        for (k,v) in URLSessionConfiguration.defaultHeaders{
            request.setValue(v, forHTTPHeaderField: k)
        }
        //        for (k,v) in URLSessionConfiguration.s
        return request
    }
    static func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let value = value as? NSNumber {
            if value.isBool {
                if value.boolValue{
                    components.append((key.escapeString, "1".escapeString))
                }else{
                    components.append((key.escapeString, "0".escapeString))
                }
            } else {
                components.append((key.escapeString, "\(value)".escapeString))
            }
        }else if let bool = value as? Bool {
            if bool{
                components.append((key.escapeString, "1".escapeString))
            }else{
                components.append((key.escapeString, "0".escapeString))
            }
        }else{
            components.append((key.escapeString,"\(value)".escapeString))
        }
        return components
    }
    static func convertParametersToString( parameters:[String:Any] = [:]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys.sorted(by: <){
            if let value = parameters[key]{
                components += queryComponents(fromKey: key, value: value)
            }
        }
        return components.map { "\($0)=\($1)"}.joined(separator: "&")
    }
    ///use Codable callback
    func dataTaskWith<T:Codable>(codable object:@escaping (T)->Void,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        return URLSession.shared.dataTaskWith(request: self, codable: object, completionHandler: completionHandler)
    }
    func dataTask( completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        return URLSession.shared.dataTask(with: self) { (data, res, err) in
            DispatchQueue.main.async {
                completionHandler(data,res,err)
            }
        }
    }

    ///-H "Accept-Encoding: gzip;q=1.0, compress;q=0.5"
    static var defaultAcceptEncoding:String{
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            return "br;q=1.0,gzip;q=0.9,deflate;q=0.8"
        } else {
            return "gzip;q=0.9,deflate;q=0.8"
        }
    }
}
// MARK: - URLResponse
public extension URLResponse{
    var httpURLResponse:HTTPURLResponse?{
        guard let http = self as? HTTPURLResponse else{
            return nil
        }
        return http
    }
    
    var isValidHttpStatusCode:Bool{
        return httpURLResponse?.isValidStatusCode ?? false
    }
}
public extension HTTPURLResponse{
    var isValidStatusCode:Bool{
        return (200..<400).contains(statusCode)
    }
}
public extension URLCache{
    static let `default`:URLCache = {
        let totalMemory:UInt64 = ProcessInfo.processInfo.physicalMemory
        //25% of system memory
        let memoryCapacity:Int = Int(totalMemory / 4)
        //        FileManager
        let cache = URLCache.init(memoryCapacity: memoryCapacity, diskCapacity: 1024*1024*1024, diskPath: "WTKitURLCachePath")
        return cache
    }()
}
public let WT = URLSession.default
// MARK: - URLSession
public extension URLSession{
    static let `default`: URLSession = {
        let session = URLSession.init(configuration: .wtURLSessionConfiguration)
        return session
    }()
    func dataTask(with urlString: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        return dataTask(with: urlString.urlValue, completionHandler: completionHandler)
    }
    /**
     执行请求
     testData:用于测试的数据,在debug模式生效,release模式不生效
     */
    func dataTask<T:Codable>(with path:String, method:WTHTTPMethod = .get, parameters:[String:Any] = [:], headers:[String:String] = [:], testData:Data? = nil, object:@escaping(T)->Void,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) -> URLSessionDataTask {
        var request = URLRequest.createURLRequest(with: path, method: method, parameters: parameters, headers: headers)
        //虽然默认带了,但是没有绑定到URLRequest里面,导致URLRequestPrinter无法使用,所以还是手动加上吧
        if let httpAdditionalHeaders = configuration.httpAdditionalHeaders{
            for (k,v) in httpAdditionalHeaders{
                if let ks = k as? String, let vs = v as? String{
                    request.setValue(vs, forHTTPHeaderField: ks)
                }
            }
        }
        return dataTaskWith(request: request, testData: testData, codable: object, completionHandler: completionHandler)
    }
    /**
     对于一个request对象,提供请求,测试和解析功能
     testData:用于测试的数据,只会出现在debug模式,这个方法非常实用,
     可以模拟一个想要的数据来测试功能和UI
     */
    func dataTaskWith<T:Codable>( request:URLRequest, testData:Data? = nil, codable object:@escaping (T)->Void,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        let task = self.dataTask(with: request) {  (data, response, err) in
            var errorToReturn = err
            #if DEBUG
            if let td = testData {
                do {
                    let result = try JSONDecoder().decode(T.self, from: td)//类型转换
                    DispatchQueue.main.async {
                        object(result)
                    }
                } catch {
                    errorToReturn = error
                }
                completionHandler(data,response,errorToReturn)
                return
            }
            #endif
            if let myData = data{
                do{
                    let result = try JSONDecoder().decode(T.self, from: myData)//类型转换
                    DispatchQueue.main.async {
                        object(result)
                    }
                }catch{
                    errorToReturn = error
                }
            }
            completionHandler(data,response,errorToReturn)
        }
        return task
    }
    
    @discardableResult
    func useCacheElseLoadURLData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest.init(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        let task = dataTask(with: request, completionHandler: { (data,res,err) in
            DispatchQueue.main.async {
                completionHandler(data,res,err)
            }
        })
        task.resume()
        return task
    }
    #if canImport(Combine)
    /**
     这是一个函数式的模式
     1.map  数据map,例如把Data变成一个Codable的数据
     2.receive 交付线程.
     3.sink 处理error
     3.receiveValue 处理正常数据
     */
    private func testCombine() {
        if #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            _ = URLSession.shared.dataTaskPublisher(for: "https://www.apple.com".urlRequest).map { (arg0) -> Int in
                let (data, res) = arg0
                print("\(res)")
                do{
                    let obj = try JSONDecoder().decode(Int.self, from: data)
                    return obj
                }catch{
                    return 1
                }
            }.receive(on: RunLoop.main).sink(receiveCompletion: { (err) in
                print("\(err)")
                }) { (value) in
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    #endif
}

public class WTURLSessionDelegate:NSObject,URLSessionDelegate{
    var cerNames:[String] = []{
        didSet{
            cerPaths = cerNames.map { (str) -> URL in
                return (Bundle.main.url(forResource: str, withExtension: nil) ?? "".urlValue)
            }
        }
    }
    var cerPaths:[URL] = []{
        didSet{
            cerDatas = cerPaths.compactMap { (url) -> Data? in
                do{
                    let data = try Data.init(contentsOf: url)
                    return data
                }catch{
                    
                }
                return nil
            }
        }
    }
    var cerDatas:[Data] = []
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
            // Adapted from OWASP https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning#iOS
            
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                if let serverTrust = challenge.protectionSpace.serverTrust {
                    if #available(iOS 12.0,OSX 10.14, tvOS 12.0,watchOS 5.0, *) {
                        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
                        if(isServerTrusted) {
                            if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                                let serverCertificateData = SecCertificateCopyData(serverCertificate)
                                guard let data = CFDataGetBytePtr(serverCertificateData) else{
                                    return
                                }
                                let size = CFDataGetLength(serverCertificateData);
                                let cert1 = Data.init(bytes: data , count: size)
                                guard let file = Bundle.main.url(forResource: "certificateFile", withExtension: "der") else{
                                    return
                                }
                                guard let cert2 = try? Data.init(contentsOf: file) else{
                                    return
                                }
                                if cert1 == cert2{
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                }
            }
            
            // Pinning failed
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        
    }
    
}

public extension URL{
    var request:URLRequest{
        return URLRequest.init(url: self)
    }
}
/*
 POST /upload
 Host: example.com
 Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryqzByvokjOTfF9UwD
 Content-Length: 332
 ------WebKitFormBoundaryqzByvokjOTfF9UwD
 Content-Disposition: form-data; name="upfile"; filename="example.txt"
 Content-Type: text/plain
 File contents go here.
 ------WebKitFormBoundarysKk4Z8KcYfU3u6Cs
 Content-Disposition: form-data; name="note"
 Uploading a file named "example.txt"
 ------WebKitFormBoundaryqzByvokjOTfF9UwD--
 */
open class MultipartBody{
    var boundry:String = "--qweasdzxc"
    var contentLength:Int = 0
    var parts:[MultipartBodyObject] = []
    func buildBody() -> Data {
        let result = Data()
        
        return result
    }
}
open class MultipartBodyObject{
    var name:String = ""
    var filename:String?
    var contentType:String?
    var data:Data = Data()
}

public extension URLSessionTask{
    
}
public extension URLSessionDataTask{
    
}
public extension URLSessionConfiguration{
    static let wtURLSessionConfiguration:URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = defaultHeaders
        return config
    }()
    static var defaultHeaders:[String:String]{
        var defaultHeaders:[String:String] = [:]
        defaultHeaders["Accept-Encoding"] = URLSessionConfiguration.defaulAcceptEncoding
        defaultHeaders["Accept-Language"] = URLSessionConfiguration.defaultLanguage
        defaultHeaders["User-Agent"] = URLSessionConfiguration.defaultUserAgent
        return defaultHeaders
    }
    /// Accept-Encoding
    static var defaulAcceptEncoding:String{
        
        let encodings: [String]
        #if DEBUG
        return "compress;q=1.0"
        #else
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            encodings = ["br", "gzip", "deflate"]
        } else {
            encodings = ["gzip", "deflate"]
        }
        return encodings.qualityEncoded()
        #endif
    }
    ///"Accept-Language"
    static var defaultLanguage:String{
        
        return Locale.preferredLanguages.prefix(6).qualityEncoded()
    }
    ///"User-Agent"
    static var defaultUserAgent:String{
        guard let info = Bundle.main.infoDictionary else{
            return "Unknown User-Agent"
        }
        let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
        
        let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
        
        let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
        
        let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
        
        let osNameVersion: String = {
            let operatingSystemVersionString = ProcessInfo.processInfo.operatingSystemVersionString
            // swiftformat:disable indent
            let osName: String = {
                #if os(iOS)
                return "iOS"
                #elseif os(watchOS)
                return "watchOS"
                #elseif os(tvOS)
                return "tvOS"
                #elseif os(macOS)
                return "macOS"
                #elseif os(Linux)
                return "Linux"
                #else
                return "Unknown"
                #endif
            }()
            // swiftformat:enable indent
            
            return "\(osName) \(operatingSystemVersionString)"
        }()
        
        let WTKit = "WTKit"
        let result = "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(WTKit)"
        return result
    }
}
public extension Date{
    func localDescString() -> String {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: self)
    }
}
public extension TimeZone{
    
}
public extension DateFormatter{
    //https://nsdateformatter.com
    static let globalFormatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    static func string(from date:Date, dateFormat:String) -> String {
        let df = DateFormatter()
        df.dateFormat = dateFormat
        return df.string(from: date)
    }
}
// MARK: - Bundle
public extension Bundle{
    class func appBundleName()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName")  as? String ?? "Unknown"
    }
    //bundleid  eg.2345678
    class func appBundleID()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? "Unknown"
    }
    //build version eg.1234
    class func buildVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
    }
    //app version eg. 1.2.1
    static func appVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    }
    static var enUS:Bundle = {
        let path:String = Bundle.main.path(forResource: "zh_CN", ofType: "lproj") ?? ""
        let bundle:Bundle = Bundle.init(path: path) ?? Bundle.main
        return bundle
    }()
    static var zhCN:Bundle = {
        let path:String = Bundle.main.path(forResource: "zh_CN", ofType: "lproj") ?? ""
        let bundle:Bundle = Bundle.init(path: path) ?? Bundle.main
        return bundle
    }()
    static var customBundle:Bundle = Bundle.main
}
public func NSLibraryDirectory() -> String{
    return NSHomeDirectory() + "/Library"
}
public func NSLibraryCachesDirectory() -> String{
    return NSLibraryDirectory() + "/Caches"
}
public extension FileManager{
}

public extension JSONDecoder{
}
func convertCodableTypeToParameters<T:Codable,B>(_ t:T) -> B? {
    do{
        let data = try JSONEncoder().encode(t)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let j = json as? B{
            return j
        }
    }catch{
        return nil
    }
    return nil
}
public extension Calendar{
    func numberOfDaysInMonth(for date: Date) -> Int {
        if let range = range(of: .day, in: .month, for: date){
            return range.count
        }
        return 0
    }
}
// MARK: - NSAttributedString
public extension NSAttributedString{
    func attributedString(with attrs:[NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString.init(attributedString: self)
        result.applyAttributes(attrs)
        return result
    }
    var mutableAttributedString:NSMutableAttributedString{
        return NSMutableAttributedString.init(attributedString: self)
    }
}
public extension NSMutableAttributedString{
    func applyAttribute(_ name: NSAttributedString.Key, value: Any) {
        let range = NSRange.init(location: 0, length: self.length)
        self.addAttribute(name, value: value, range: range)
    }
    func applyAttributes(_ attrs:[NSAttributedString.Key : Any] ) {
        for (k,v) in attrs{
            applyAttribute(k, value: v)
        }
    }
}
// MARK: - WTHTTPMethod
/// Type representing HTTP methods.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
public enum WTHTTPMethod: String {
    /// `CONNECT` method.
    case connect = "CONNECT"
    /// `DELETE` method.
    case delete = "DELETE"
    /// `GET` method.
    case get = "GET"
    /// `HEAD` method.
    case head = "HEAD"
    /// `OPTIONS` method.
    case options = "OPTIONS"
    /// `PATCH` method.
    case patch = "PATCH"
    /// `POST` method.
    case post = "POST"
    /// `PUT` method.
    case put = "PUT"
    /// `TRACE` method.
    case trace = "TRACE"
    func needUseQuery() -> Bool {
        switch self {
            case .get,.head,.delete:
                return true
            default:
                return false
        }
    }
}
public extension Timer{
    
}
public extension RunLoop{
    
}
public extension Thread{
    
}
public extension OperationQueue{
    
}
public extension Operation{
    
}
public extension ProcessInfo{
    // print (long)[[NSClassFromString(@"NSProcessInfo") processInfo] _suddenTerminationDisablingCount]
    #if DEBUG
    static func print_suddenTerminationDisablingCount() {
        
    }
    #endif
}
///为了解决对象之间想copy的方案,可以新建一个对象把旧数据拷贝过去
public protocol CodableObject:Encodable,Decodable{
}
///为了解决对象之间想copy的方案,可以新建一个对象把旧数据拷贝过去
public extension CodableObject where Self:NSObject{
    var copyOfSelf:Self?{
        guard let tmpClass:CodableObject.Type = self.classForCoder as? CodableObject.Type else{
            return nil
        }
        let obj:Self? = tmpClass.readFromObject(with: self)
        return obj
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
    ///use in lldb to print jsonstring,like(lldb) po obj.printJSONString()
    ///this method is only recommanded use in lldb,so it's in debug mode
    func lldbPrint() {

        
        
        print("\(jsonString)")
    }
    #endif
    
}
// MARK: - Decodable
public extension Decodable{
    static func readFromData<T:Decodable>(with data:Data) -> T?{
        return try? JSONDecoder().decode(T.self, from: data)
    }
    static func readFromObject<T:Decodable>(with obj:Encodable) -> T?{
        return try? JSONDecoder().decode(T.self, from: obj.jsonData)
    }
    #if canImport(Combine)
    
    #endif
}
public extension Collection where Element == String {
    func qualityEncoded() -> String {
        return enumerated().map { index, encoding in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(encoding);q=\(quality)"
        }.joined(separator: ", ")
    }
}

private class BaseModel<T:Codable>:Codable{
    var code:Int = 0
    var msg:String = ""
    var obj:T?
}

private class SubModel: Codable {
    var state:Int = 0
}
/*
do{
    _ = try JSONDecoder().decode(BaseModel<SubModel>.self, from: "dasd".utf8Data)
}catch{
    
}
*/
