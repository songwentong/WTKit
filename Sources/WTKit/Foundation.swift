//
//  Foundation.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/7.
//  Copyright © 2019 宋文通. All rights reserved.
//  https://github.com/songwentong/WTKit

import Foundation

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
public extension String{
    ///get localizedString from main Bundle
    var localizedString:String{
        return NSLocalizedString(self, comment: "")
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
        return "“”，。：¥"
    }
    static func halfWidthPunctuation()->String{
        return "\"\",.:¥"
    }
    static let systemKeyWords:[String] = {
        ["super","class","var","let","struct","func","private","public","return","import","protocol","default","open","Type","lazy","in","for","while","do","self","inout","@objc","open","fileprivate","default","subscript","static","case","if","else","deinit","extension","continue","operator","init","_","fallthrough","internal","true","false","switch","dynamic","typealias"]
    }()
    var escapeString:String {
        addingPercentEncoding(withAllowedCharacters: CharacterSet.wtURLQueryAllowed) ?? self
    }
    
}
private let testJSON =
"""
{
"name": "Durian",
"points": 600,
"description": "A fruit with a distinctive scent."
}
"""
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
public extension Locale{
    static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
    static func en_US() -> Locale {
        return Locale.init(identifier: "en_US")
    }
    static func korea() -> Locale{
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
public extension Int{
    var numberFormatterString:String{
        return NumberFormatter().string(from: numberObject) ?? ""
    }
//    static let testUnit:Int = 1
    
    //KB, MB, GB, TB, PB, EB, ZB, YB
    static let CountPerUnit:Int = 1024
    
    ///number of bytes in one Kib
    static let KiB:Int = {
        return CountPerUnit
    }()
    static let MiB:Int = {
        return KiB * CountPerUnit
    }()
    static let GiB:Int = {
        return MiB * CountPerUnit
    }()
    static let TiB:Int = {
        return GiB * CountPerUnit
    }()
    static let PiB:Int = {
        return TiB * CountPerUnit
    }()
    static let EiB:Int = {
        return PiB * CountPerUnit
    }()
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
    static var wtURLQueryAllowed: CharacterSet{
        let encodableDelimiters = CharacterSet(charactersIn: "\(String.generalDelimitersToEncode)\(String.subDelimitersToEncode)")
        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }
}
public extension URLRequest{
    ///create URL Request
    static func createURLRequest(with path:String, method:WTHTTPMethod = .get, parameters:[String:Any] = [:], headers:[String:String] = [:]) -> URLRequest {
        var request = URLRequest.init(url: path.urlValue)
        request.httpMethod = method.rawValue
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
    ///print URLRequest as curl command,copy and run with terminal
    var printer:URLRequestPrinter{
        let p = URLRequestPrinter()
        p.request = self
        return p
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

public extension URLSession{
    static let `default`: URLSession = {
        let session = URLSession.init(configuration: .wtURLSessionConfiguration)
        return session
    }()
    func dataTask<T:Codable>(with path:String, method:WTHTTPMethod = .get, parameters:[String:Any] = [:], headers:[String:String] = [:], object:@escaping(T)->Void,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) -> URLSessionDataTask {
        var request = URLRequest.createURLRequest(with: path, method: method, parameters: parameters, headers: headers)
        //虽然默认带了,但是没有绑定到URLRequest里面,导致URLRequestPrinter无法使用,所以还是手动加上吧
        if let httpAdditionalHeaders = configuration.httpAdditionalHeaders{
            for (k,v) in httpAdditionalHeaders{
                if let ks = k as? String, let vs = v as? String{
                    request.setValue(vs, forHTTPHeaderField: ks)
                }
            }
        }
        return dataTaskWith(request: request, codable: object, completionHandler: completionHandler)
    }
    
    func dataTaskWith<T:Codable>( request:URLRequest, codable object:@escaping (T)->Void,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        let task = self.dataTask(with: request) {  (data, response, err) in
            var errorToReturn = err
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
}
///print URLRequest as curl command,copy and run with terminal
public class URLRequestPrinter:CustomDebugStringConvertible,CustomStringConvertible {
    var request:URLRequest = URLRequest.init(url: "".urlValue)
    public var description: String{
        var components: [String] = []
        
        if let HTTPMethod = request.httpMethod {
            components.append(HTTPMethod)
        }
        
        if let urlString = request.url?.absoluteString {
            components.append(urlString)
        }
        let desc = components.joined(separator: " ")
        return desc
    }
    public var debugDescription: String{
        var components = ["$ curl -v"]
        
        guard let url = request.url else {
            return "$ curl command could not be created"
        }
        
        if let httpMethod = request.httpMethod {
            components.append("-X \(httpMethod)")
        }
        
        var headers: [AnyHashable: Any] = [:]
        /*
         session.configuration.httpAdditionalHeaders?.filter {  $0.0 != AnyHashable("Cookie") }
         .forEach { headers[$0.0] = $0.1 }
         */
        request.allHTTPHeaderFields?.filter { $0.0 != "Cookie" }
            .forEach { headers[$0.0] = $0.1 }
        
        components += headers.map {
            let escapedValue = String(describing: $0.value).replacingOccurrences(of: "\"", with: "\\\"")
            
            return "-H \"\($0.key): \(escapedValue)\""
        }
        
        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
            
            components.append("-d \"\(escapedBody)\"")
        }
        
        components.append("\"\(url.absoluteString)\"")
        
        let result = components.joined(separator: " \\\n\t")
        return result
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
    var printer:URLRequestPrinter{
        guard let req = self.originalRequest else{
            return URLRequestPrinter()
        }
        let result = URLRequestPrinter()
        result.request = req
        return result
    }
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
    
    static var defaulAcceptEncoding:String{
        //Accept-Encoding
        let encodings: [String]
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            encodings = ["br", "gzip", "deflate"]
        } else {
            encodings = ["gzip", "deflate"]
        }
        return encodings.qualityEncoded()
    }
    static var defaultLanguage:String{
        //"Accept-Language"
        return Locale.preferredLanguages.prefix(6).qualityEncoded()
    }
    static var defaultUserAgent:String{
        //        "User-Agent"
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
public extension NSObject{
    
}
public extension Calendar{
    func numberOfDaysInMonth(for date: Date) -> Int {
        if let range = range(of: .day, in: .month, for: date){
            return range.count
        }
        return 0
    }
}
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
public extension Encodable{
    ///convert self to json string (recommand use print,not lldb)
    var jsonString:String{
        let encoder = JSONEncoder()
        if #available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *){
            encoder.outputFormatting = [.withoutEscapingSlashes,.prettyPrinted,.sortedKeys]
        }else if #available(OSX 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *) {
            encoder.outputFormatting = [.prettyPrinted,.sortedKeys]
        } else {
            encoder.outputFormatting = [.prettyPrinted]
        }
        if let data = try? encoder.encode(self){
            return data.utf8String
        }else{
            return "not a json string"
        }
    }
    #if DEBUG
    ///use in lldb to print jsonstring,like(lldb) po obj.printJSONString()
    ///this method is only recommanded use in lldb,so it's in debug mode
    func lldbPrint() {
        print("\(jsonString)")
    }
    #endif
}
//"dsadas".printJSONString()
public extension Decodable{
}
public extension Collection where Element == String {
    func qualityEncoded() -> String {
        return enumerated().map { index, encoding in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(encoding);q=\(quality)"
        }.joined(separator: ", ")
    }
}
