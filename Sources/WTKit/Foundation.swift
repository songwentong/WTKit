//
//  Foundation.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/7.
//  Copyright © 2019 宋文通. All rights reserved.
//

import Foundation

//public func
public func dprint<T>(_ items:T, separator: String = " ", terminator: String = "\n",file:String = #file, function:String = #function, line:Int = #line) -> Void {
    
    #if DEBUG
    cprint(items, separator: separator, terminator: terminator,file:file, function:function, line:line)
    #endif
}
public func cprint<T>(_ items: T,  separator: String = " ", terminator: String = "\n",file:String = #file, function:String = #function, line:Int = #line) -> Void {
    print("\((file as NSString).lastPathComponent)[\(line)], \(function): \(items)", separator: separator, terminator: terminator)
}

public extension Data{
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
    func utf8String() -> String {
        return String.init(data: self, encoding: .utf8) ?? "not utf8 string"
    }
    
}
public func debugBlock(_ block:()->Void) -> Void {
    #if DEBUG
    block()
    #endif
}
public extension Locale{
    static func en_US() -> Locale {
        return Locale.init(identifier: "en_US")
    }
    static func korea() -> Locale{
        return Locale.init(identifier: "ko-Kore_KR")
    }
}
public typealias BinaryNumber = BinaryInteger & BinaryFloatingPoint
public extension BinaryInteger{
    var byteCountFormatString:String{
        return ByteCountFormatter().string(fromByteCount: Int64.init(self))
    }
}
public extension BinaryFloatingPoint{
    var byteCountFormatString:String{
        return ByteCountFormatter().string(fromByteCount: Int64.init(self))
    }
}
public extension Int{
    var numberObject:NSNumber{
         return NSNumber.init(value: self)
    }
    var numberFormatterString:String{
        return NumberFormatter().string(from: numberObject) ?? ""
    }
}
public extension Float{
    var numberObject:NSNumber{
        return NSNumber.init(value: self)
    }
    var numberFormatterString:String{
        return NumberFormatter().string(from: numberObject) ?? ""
    }
}
public extension Double{
    func stringValue() -> String {
        return "\(self)"
    }
    var numberObject:NSNumber{
        return NSNumber.init(value: self)
    }
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
    //安全同步到主线程
    static func safeSyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        let main:DispatchQueue = DispatchQueue.main
        if Thread.isMainThread {
            main.async(execute: work)
        }else{
            main.sync(execute: work)
        }
        //        print("425 wt test")
    }
    static func safeSyncInMain(with workItem:DispatchWorkItem){
        let main:DispatchQueue = DispatchQueue.main
        if Thread.isMainThread {
            workItem.perform()
        }else{
            main.sync(execute: workItem)
        }
    }
    //异步回到主线程
    static func asyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        DispatchQueue.main.async(execute: work)
    }
    func perform( closure: @escaping () -> Void, afterDelay:Double) -> Void {
        let time = Int64(afterDelay * Double(NSEC_PER_SEC))
        let t:DispatchTime = DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC)
        self.asyncAfter(deadline: t, execute: closure)
    }
    /*
     public func asyncAfter(deadline: DispatchTime, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void)
     */
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
    
    static func createURLRequest(with path:String, method:WTHTTPMethod = .get, parameters:[String:Any] = [:], headers:[String:String] = [:]) -> URLRequest {
        var request = URLRequest.init(url: path.urlValue())
        request.httpMethod = method.rawValue
        let string = URLRequest.convertParametersToString(parameters: parameters)
        if method.needUseQuery(){
            if var urlComponents = URLComponents(url: path.urlValue(), resolvingAgainstBaseURL: false){
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
        request.setValue(URLSession.defaulAcceptEncoding, forHTTPHeaderField: "Accept-Encoding")
        request.setValue(URLSession.defaultLanguage, forHTTPHeaderField: "Accept-Language")
        request.setValue(URLSession.defaultUserAgent, forHTTPHeaderField: "User-Agent")
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
    func converToPrinter() -> URLRequestPrinter {
        let reu = URLRequestPrinter()
        reu.request = self
        return reu
    }
    var curlString: String {
        // Logging URL requests in whole may expose sensitive data,
        // or open up possibility for getting access to your user data,
        // so make sure to disable this feature for production builds!
        #if !DEBUG
        return ""
        #else
        var result = "curl -k "
        
        if let method = httpMethod {
            result += "-X \(method) \\\n"
        }
        
        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += "-H \"\(header): \(value)\" \\\n"
            }
        }
        
        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "-d '\(string)' \\\n"
        }
        
        if let url = url {
            result += url.absoluteString
        }
        
        return result
        #endif
    }
    //-H "Accept-Encoding: gzip;q=1.0, compress;q=0.5"
    static var defaultAcceptEncoding:String{
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            return "br;q=1.0,gzip;q=0.9,deflate;q=0.8"
        } else {
            return "gzip;q=0.9,deflate;q=0.8"
        }
    }
}
public extension URLResponse{
    
}
public extension HTTPURLResponse{
    var isValidStatusCode:Bool{
        return (200..<400).contains(statusCode)
    }
}
public extension URLCache{
    static let `default`:URLCache = {
        let totalMemory:UInt64 = ProcessInfo.processInfo.physicalMemory
        let memoryCapacity:Int = Int(totalMemory / 4)
//        FileManager
        //30M
        let cache = URLCache.init(memoryCapacity: memoryCapacity, diskCapacity: 1024*1024*1024, diskPath: "WTKitURLCachePath")
        return cache
    }()
}
public extension URLSession{
    static let `default`: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache.default
        let session = URLSession.init(configuration: config)
        return session
    }()
    
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
    static var defaultUserAgent: String {
//        "User-Agent"
        guard let info = Bundle.main.infoDictionary else{
            return "Unknown User-Agent"
        }
        let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
        let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
        let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
        let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
        
        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
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
            
            return "\(osName) \(versionString)"
        }()
        
        let WTKit = "WTKit"
        
        return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(WTKit)"
    }
    func dataTask<T:Codable>(with path:String, method:WTHTTPMethod = .get, parameters:[String:Any] = [:], headers:[String:String] = [:], object:@escaping(T)->Void,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) -> URLSessionDataTask {
        let request = URLRequest.createURLRequest(with: path, method: method, parameters: parameters, headers: headers)
//        for(k,v) in configuration.httpAdditionalHeaders{
//            request.addValue(v, forHTTPHeaderField: k)
//        }
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
public class URLRequestPrinter:CustomDebugStringConvertible,CustomStringConvertible {
    var request:URLRequest = URLRequest.init(url: "".urlValue())
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
        
        if let httpMethod = request.httpMethod, httpMethod != "GET" {
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
    func convertToRequest() -> URLRequest {
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
    func converToPrinter() -> URLRequestPrinter {
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
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    //bundleid  eg.2345678
    class func appBundleID()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
    //build version eg.1234
    class func buildVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    //app version eg. 1.2.1
    static func appVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    static var customBundle:Bundle = Bundle.main
    static func setCustomBundle(with newBundle:Bundle){
    }
    static func getCustomBundle() -> Bundle {
        return Bundle.main
    }
}
public func NSLibraryDirectory() -> String{
    return NSHomeDirectory() + "/Library"
}
public func NSLibraryCachesDirectory() -> String{
    return NSLibraryDirectory() + "/Caches"
}
public extension FileManager{
    func cachePath() {
        //        NSHomeDirectory()
        //        NSHomeDirectory()
        //        Data().write
    }
}
public extension String{
    //    func numberObject() -> NSNumber {
    //
    //    }
    static let generalDelimitersToEncode = ":#[]@"
    static let subDelimitersToEncode = "!$&'()*+,;="
    func urlValue() -> URL {
        guard let url = URL.init(string: self) else{
            return URL.init(fileURLWithPath: "")
        }
        return url
    }
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
    func convertTextToFullWidth()->String{
        
        if #available(OSX 10.11, iOS 9.0, *) {
            return self.applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? ""
        } else {
            // Fallback on earlier versions
        }
        return ""
    }
    func converToHalfWidth() -> String {
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
    static func systemKeyWords()->[String]{
        return ["super","class","var","let","struct","func","private","public","return","import","protocol","default","open","Type","lazy","in","for","while","do","self","inout","@objc","open","fileprivate","default","subscript","static","case","if","else","deinit","extension","continue","operator","init","_","fallthrough","internal","true","false","switch","dynamic","typealias"]
    }
    var escapeString:String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.wtURLQueryAllowed) ?? self
    }
}
public extension JSONDecoder{
    //open func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    func decode<T>(with type:T.Type, from data:Data) -> T? where T : Decodable {
        do {
            let obj:T = try decode(type, from: data)
            return obj
        } catch  {
            
        }
        return nil
    }
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
extension NSObject{
    func readFromData(_ data:Data) {
        do {
            guard let dict:[String:Any] = try JSONSerialization.jsonObject(with: data) as? [String:Any] else{
                return
            }
            var outCount:UInt32 = 0
            guard let properties:UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(object_getClass(self), &outCount) else{
                return
            }
            for i in 0...outCount {
                guard let property = property_getAttributes(properties[Int(i)]) else { return }
                let propertyString = String.init(cString: property, encoding: .utf8)
                let plist = propertyString?.components(separatedBy: ",")
                guard let last = plist?.last else{
                    return
                }
                guard let value = dict[last] else{
                    return
                }
                self.setValue(value, forKey: last)
            }
        } catch {
            
        }
        
        return
    }
}
public extension Calendar{
    func numberOfDaysInMonth(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}
public extension NSAttributedString{
    func attributedString(with attrs:[NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString.init(attributedString: self)
        result.applyAttributes(attrs)
        return result
    }
}
public extension NSMutableAttributedString{
    func applyAttributes(_ name: NSAttributedString.Key, value: Any) {
        let range = NSRange.init(location: 0, length: self.length)
        self.addAttribute(name, value: value, range: range)
    }
    func applyAttributes(_ attrs:[NSAttributedString.Key : Any] ) {
        for (k,v) in attrs{
            applyAttributes(k, value: v)
        }
    }
}
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
extension Collection where Element == String {
    func qualityEncoded() -> String {
        return enumerated().map { index, encoding in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(encoding);q=\(quality)"
        }.joined(separator: ", ")
    }
}
public extension Timer{
    
}
public extension RunLoop{
    
}

