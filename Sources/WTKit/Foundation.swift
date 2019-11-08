//
//  Foundation.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/7.
//  Copyright © 2019 newsdog. All rights reserved.
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

public extension Double{
    func numberObject() -> NSNumber {
        return NSNumber.init(value: self)
    }
    func string(with fractionDigits:Int) -> String? {
        return numberObject().string(with: fractionDigits)
    }
}
public extension NSNumber{
    func string(with fractionDigits:Int) -> String? {
        let nf = NumberFormatter.init()
        nf.minimumFractionDigits = 8
        nf.maximumFractionDigits = 8
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
}
enum URLSessionError:Error {
    case noURL
    case nodata
    case parseEror
    case none
    case ok
}
public extension URLSession{
    @discardableResult
    func dataTask<T:Codable>(withPath urlPath:String,complectionHandler: @escaping (T?,Error?) -> Void) -> URLSessionDataTask?{
        guard let url = URL.init(string: urlPath) else {
            DispatchQueue.main.async {
                complectionHandler(nil,URLSessionError.noURL)
            }
            return nil
        }
        return dataTask(with: url, completionHandler: complectionHandler)
    }
    @discardableResult
    func dataTask<T:Codable>(with url: URL, completionHandler: @escaping (T?,Error?) -> Void ) -> URLSessionDataTask{
        return dataTask(with: URLRequest.init(url: url), completionHandler: completionHandler)
    }
    @discardableResult
    func dataTask<T:Codable>(with request: URLRequest, completionHandler: @escaping (T?,Error?) -> Void) -> URLSessionDataTask{
        let task = dataTask(with: request) { (data, urlres, err) in
            if err != nil{
                completionHandler(nil,err)
            }
            guard let data = data else{
                DispatchQueue.main.async {
                    completionHandler(nil,URLSessionError.nodata)
                }
                return
            }
            do{
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(obj,.none)
                }
                
            }catch{
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    static func useCacheElseLoadURLData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest.init(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data,res,err) in
            DispatchQueue.main.async {
                completionHandler(data,res,err)
            }
        })
        task.resume()
        return task
    }
    
}
public struct URLRequestPrinter:CustomDebugStringConvertible,CustomStringConvertible {
    var request:URLRequest
    public var description: String{
        var components: [String] = []
        
        if let HTTPMethod = request.httpMethod {
            components.append(HTTPMethod)
        }
        
        if let urlString = request.url?.absoluteString {
            components.append(urlString)
        }
        return components.joined(separator: " ")
    }
    public var debugDescription: String{
        var components = ["$ curl -v"]
        
        guard let url = request.url else {
            return "$ curl command could not be created"
        }
        
        if let httpMethod = request.httpMethod, httpMethod != "GET" {
            components.append("-X \(httpMethod)")
        }
        /*
         if let credentialStorage = self.session.configuration.urlCredentialStorage {
         let protectionSpace = URLProtectionSpace(
         host: host,
         port: url.port ?? 0,
         protocol: url.scheme,
         realm: host,
         authenticationMethod: NSURLAuthenticationMethodHTTPBasic
         )
         
         if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
         for credential in credentials {
         guard let user = credential.user, let password = credential.password else { continue }
         components.append("-u \(user):\(password)")
         }
         } else {
         if let credential = delegate.credential, let user = credential.user, let password = credential.password {
         components.append("-u \(user):\(password)")
         }
         }
         }
         
         if session.configuration.httpShouldSetCookies {
         if
         let cookieStorage = session.configuration.httpCookieStorage,
         let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty
         {
         let string = cookies.reduce("") { $0 + "\($1.name)=\($1.value);" }
         
         #if swift(>=3.2)
         components.append("-b \"\(string[..<string.index(before: string.endIndex)])\"")
         #else
         components.append("-b \"\(string.substring(to: string.characters.index(before: string.endIndex)))\"")
         #endif
         }
         }*/
        
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
        
        return components.joined(separator: " \\\n\t")
    }
}
public extension URL{
    func convertToRequest() -> URLRequest {
        return URLRequest.init(url: self)
    }
}
public extension URLRequest{
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        return URLSession.shared.dataTask(with: self, completionHandler: completionHandler)
    }
    func converToPrinter() -> URLRequestPrinter {
        return URLRequestPrinter.init(request: self)
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
}

public extension URLSessionTask{
    func converToPrinter() -> URLRequestPrinter? {
        guard let req = self.originalRequest else{
            return nil
        }
        return URLRequestPrinter.init(request: req)
    }
}
public extension URLSessionDataTask{
    
}
public extension Date{
    
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
}
public extension Bundle{
    func appName() -> String {
        let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        return appName
    }
    static var customBundle:Bundle = Bundle.main
    static func setCustomBundle(with newBundle:Bundle){
    }
    static func getCustomBundle() -> Bundle {
        return Bundle.main
    }
}
public extension String{
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

