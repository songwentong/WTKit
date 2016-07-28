//  https://github.com/swtlovewtt/WTKit
//  FoundationExtension.swift
//  WTKit
//
//  Created by SongWentong on 4/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import Foundation
#if os(iOS)
    import SystemConfiguration
    import CoreFoundation
    import CoreGraphics
    //    import MobileCoreServices
    import UIKit
#elseif os(OSX)
    import CoreServices
#endif

// MARK: - 用于DEBUG模式的print,强烈推荐使用
/*!
 用于DEBUG模式的log
 */
public func WTPrint<T>(_ items:T,
                    separator: String = " ",
                    terminator: String = "\n",
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method)")
        print(items,separator: separator,terminator: terminator)
    #endif
}

/*!
 用于WTKit内部log
 只有在debug下并且WTKitLogMode是true的情况下输出
 */
private let WTKitLogMode:Bool = true
public func WTLog(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    file: String = #file,
    method: String = #function,
    line: Int = #line
    ) {
    #if DEBUG
        if WTKitLogMode {
            print("\((file as NSString).lastPathComponent)[\(line)], \(method)")
            print(items,separator: separator,terminator: terminator)
        }
    #endif
    
}


// MARK: - DEBUG执行的方法
public func DEBUGBlock(_ block:() -> Void){
    #if DEBUG
        block()
    #else
    #endif
}

/*!
 安全的回到主线程
 */
public func safeSyncInMain(with block:()->Void)->Void{
    if Thread.current.isMainThread {
        block()
    }else{
        DispatchQueue.main.sync(execute: block)
    }
}


// MARK: - 延时执行的代码块
/*!
 延时执行的代码块
 */
public func performOperation(with block:()->Void, afterDelay:TimeInterval){
    //Swift 不允许数据在计算中损失,所以需要在计算的时候转换以下类型
    let time = Int64(afterDelay * Double(NSEC_PER_SEC))
    let t = DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC)
    DispatchQueue.main.after(when: t, execute: block)
}

func bridge<T : AnyObject>(obj : T) -> UnsafePointer<Void> {
    return UnsafePointer(Unmanaged.passUnretained(obj).toOpaque())
    // return unsafeAddress(of: obj) // ***
}

func bridge<T : AnyObject>(ptr : UnsafePointer<Void>) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    // return unsafeBitCast(ptr, to: T.self) // ***
}

func bridgeRetained<T : AnyObject>(obj : T) -> UnsafePointer<Void> {
    return UnsafePointer( Unmanaged.passRetained(obj).toOpaque())
}

func bridgeTransfer<T : AnyObject>(ptr : UnsafePointer<Void>) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}

public enum httpMethod:String{
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}
extension URLRequest{
    
    /*!
     创建一个URLRequest实例
     */
    public static func wt_request(with url:String , method:httpMethod? = .GET, parameters:[String:String]?=nil,headers: [String: String]?=nil) -> URLRequest{
        let queryString = self.queryString(from:parameters)
        var request:URLRequest
        var urlString:String
        
        request = URLRequest(url: URL(string: url)!)
        var myMethod:httpMethod = .GET
        if let m:httpMethod = method {
            myMethod = m
            request.httpMethod = myMethod.rawValue
        }
        let allHTTPHeaderFields = URLRequest.defaultHTTPHeaders
        request.allHTTPHeaderFields = allHTTPHeaderFields
        if headers != nil {
            for (key,value) in headers!{
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if(self.methodShouldAddQuery(request.httpMethod!)){
            urlString = url
            if let query:String = queryString {
                urlString += "?"
                urlString += query
            }
            request.url = URL(string: urlString)
        }else{
            urlString = url
            if let query:String = queryString {
                request.httpBody = query.toUTF8Data()
            }
        }
        return request
    }
    
    
    /*!
     根据url,方法,参数和header创建一个请求
     方法默认是GET,参数默认是空,请求头默认是空
     */
    /*
     public static func request(with url:String, method:String?="GET", parameters:[String:String]?=nil,headers: [String: String]?=nil) -> URLRequest{
     
     let queryString = self.queryString(from:parameters)
     var request:URLRequest
     var urlString:String
     request = URLRequest(url: URL(string: url)!)
     var myMethod:String = "GET"
     if let m:String = method {
     myMethod = m
     request.httpMethod = myMethod
     }
     let allHTTPHeaderFields = URLRequest.defaultHTTPHeaders
     request.allHTTPHeaderFields = allHTTPHeaderFields
     if headers != nil {
     for (key,value) in headers!{
     request.setValue(value, forHTTPHeaderField: key)
     }
     }
     
     if(self.methodShouldAddQuery(myMethod)){
     urlString = url
     if let query:String = queryString {
     urlString += "?"
     urlString += query
     }
     request.url = URL(string: urlString)
     }else{
     urlString = url
     if let query:String = queryString {
     request.httpBody = query.toUTF8Data()
     }
     }
     return request
     }
     */
    
    public static let defaultHTTPHeaders: [String: String] = {
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                
                let osNameVersion: String = {
                    let versionString: String
                    
                    if #available(OSX 10.10, *) {
                        let version = ProcessInfo.processInfo.operatingSystemVersion
                        versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    } else {
                        versionString = "10.9"
                    }
                    
                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(OSX)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()
                    
                    return "\(osName) \(versionString)"
                }()
                
                return "\(executable)/\(bundle) (\(version); \(osNameVersion))"
            }
            
            return "WTKit"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()
    
    
    //需要拼接query 的方法
    static func methodShouldAddQuery(_ method:String)->Bool{
        let query = ["GET","HEAD","DELETE"]
        if(query.contains(method)){
            return true
        }else{
            return false
        }
    }
    
    
    //从参数转成字符串
    static func queryString(from parameters:[String: String]?=[:])->String? {
        
        //        Array
        //        Dictionary
        if parameters == nil {
            return nil
        }
        var components: [(String, String)] = Array()
        for (key) in parameters!.keys.sorted(isOrderedBefore: <){
            let value = parameters![key]!
            components.append((key, value))
        }
        let result = (components.map{ "\($0)=\($1)" } as [String]).joined(separator: "&")
        let allowedCharacterSet = CharacterSet.urlQueryAllowed
        return result.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
    
    // MARK: Multipart 请求
    /*!
     注释
     body中
     name            参数名
     filename        文件名
     contentType     内容类型
     content         内容
     
     */
    public static func upLoadFile(_ url:String, method:String,parameters:[String:String]?=[:],body:[[String:AnyObject]]?=[])->URLRequest {
        let boundary = "Boundary+1F52B974B3E5F39D"
        let theURL = URL(string: url)
        var request = URLRequest(url: theURL!)
        request.httpMethod = method
        var HTTPBody = Data()
        
        
        //加上开头
        HTTPBody.append(String(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
        
        
        
        //把相关参数加上
        if parameters != nil {
            for (key,value) in parameters!{
                let header = String(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key)
                HTTPBody.append(header.data(using: String.Encoding.utf8)!)
                HTTPBody.append(value.data(using: String.Encoding.utf8)!)
                HTTPBody.append(String(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
            }
        }
        
        
        
        //枚举把相关的数据加上
        if body != nil {
            for(part) in body!{
                
                //把字典的数值取出来
                let name = part["name"] as! String
                let filename = part["filename"] as! String
                let contentType = part["contentType"] as! String
                let content = part["content"] as! Data
                
                let disposition:String = String(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename)
                let contentTypeString:String = String(format: "Content-Type: %@\r\n\r\n", contentType)
                HTTPBody.append(disposition.data(using: String.Encoding.utf8)!)
                HTTPBody.append(contentTypeString.data(using: String.Encoding.utf8)!)
                HTTPBody.append(content)
                HTTPBody.append(String(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
            }
        }
        
        
        //加上结尾
        HTTPBody.append(String(format: "\r\n--%@--\r\n", boundary).data(using: String.Encoding.utf8)!)
        
        
        request.httpBody = HTTPBody as Data
        
        
        //告知边界的字符串
        let contentType = String(format: "multipart/form-data; boundary=%@", boundary)
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        //告知数据长度
        request.setValue(NSNumber(value: HTTPBody.count).stringValue, forHTTPHeaderField: "Content-Length")
        return request
    }
}
extension URLSession{
    
    
    public static func wt_sharedInstance()->URLSession{
        let delegate = WTURLSessionDelegate.sharedInstance
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache.wt_sharedURLCacheForRequests()
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: OperationQueue())
        return session
    }
    
    /*
     便捷的请求方法.
     */
    public static func wt_dataTask(with url:String, method:httpMethod? = .GET,parameters:[String:String]?=[:],headers: [String: String]? = [:] ,credential:URLCredential?=nil,completionHandler:completionHandler)->WTURLSessionTask{
        let request = URLRequest.wt_request(with: url, method: method, parameters: parameters, headers: headers)
        return self.wt_dataTask(with: request,credential:credential, completionHandler: completionHandler)
    }
    
    /*!
     根据请求对象,凭据来创建task
     */
    public static func wt_dataTask(with request:URLRequest,credential:URLCredential?=nil,completionHandler:completionHandler)->WTURLSessionTask{
        let session = self.wt_sharedInstance()
        let task = session.dataTask(with: request)
        let myTask = WTURLSessionTask(task: task)
        WTURLSessionDelegate.sharedInstance[task] = myTask
        myTask.completionHandler = completionHandler
        myTask.credential = credential
        WTURLSessionDelegate.sharedInstance.credential = credential
        return myTask
    }
    
    public static func wt_uploadTask(with request:URLRequest,from bodyData:Data,credential:URLCredential?=nil,completionHandler:completionHandler)->WTURLSessionTask{
        let session = self.wt_sharedInstance()
        let task = session.uploadTask(with: request, from: bodyData)
        let myTask = WTURLSessionTask(task: task)
        WTURLSessionDelegate.sharedInstance[task] = myTask
        myTask.completionHandler = completionHandler
        myTask.credential = credential
        WTURLSessionDelegate.sharedInstance.credential = credential
        return myTask
    }
    
    public static func wt_downloadTask(with request:URLRequest,credential:URLCredential?=nil,completionHandler:completionHandler)->WTURLSessionTask{
        
        let session = self.wt_sharedInstance()
        let task = session.downloadTask(with: request)
        let myTask = WTURLSessionTask(task: task)
        WTURLSessionDelegate.sharedInstance[task] = myTask
        myTask.completionHandler = completionHandler
        myTask.credential = credential
        WTURLSessionDelegate.sharedInstance.credential = credential
        return myTask
    }
    
    
    public static func wt_cachedDataTask(with request:URLRequest ,credential:URLCredential?=nil, completionHandler:completionHandler)->WTURLSessionTask{
        
        
        //        let configuration = URLSessionConfiguration.default
        let session = self.wt_sharedInstance()
        var myRequest = request
        myRequest.cachePolicy = .returnCacheDataElseLoad
        let task = session.dataTask(with: myRequest)
        let myTask = WTURLSessionTask(task: task)
        WTURLSessionDelegate.sharedInstance[task] = myTask
        myTask.completionHandler = completionHandler
        myTask.credential = credential
        WTURLSessionDelegate.sharedInstance.credential = credential
        return myTask
    }
    
    
}
public typealias progressHandler = ((countOfBytesReceived: Int64 ,countOfBytesExpectedToReceive: Int64) -> Void)
public typealias completionHandler = ((data:Data?, response:URLResponse?, error:NSError?) -> Swift.Void)
public typealias jsonHandler = (object:AnyObject?,error:NSError?)->Void
public typealias imageHandler = (image:UIImage?,error:NSError?)->Void
public typealias stringHandler = (string:String?,error:NSError?)->Void


public typealias challengeHandler = ((Foundation.URLSession, URLAuthenticationChallenge) -> (Foundation.URLSession.AuthChallengeDisposition, URLCredential?))

public class WTURLSessionTask:NSObject,URLSessionDataDelegate,URLSessionTaskDelegate{
    //网址凭据
    public var credential: URLCredential?
    public var completionHandler:completionHandler?
    public var jsonHandler:jsonHandler?
    public var imageHandler:imageHandler?
    public var stringHandler:stringHandler?
    
    
    public var progressHandler:progressHandler?
    public var response:URLResponse?
    public var challengeHandler:challengeHandler?
    
    //懒加载,需要的时候创建对象
    public lazy var data:Data = Data()
    public let task: URLSessionTask
    public var error: NSError?
    
    
    init(task: URLSessionTask) {
        self.task = task
    }
    
    public func resume(){
        task.resume()
    }
    public func suspend(){
        task.suspend()
    }
    public func cancel(){
        task.cancel()
    }
    
    private func finish(){
        
        OperationQueue.globalQueue {
            if let _ = self.imageHandler{
                let image = UIImage(data: self.data)
                OperationQueue.main({
                    self.imageHandler?(image:image,error:self.error)
                })
                
            }
            
            if let _ = self.jsonHandler{
                self.data.parseJSON(handler: { (object, error) in
                    OperationQueue.main({
                        self.jsonHandler?(object:object,error:error)
                    })
                })
                
                
            }
            
            if let _ = self.stringHandler{
                let string = String.init(data: self.data, encoding: String.Encoding.utf8)
                OperationQueue.main {
                    self.stringHandler?(string:string,error:self.error)
                }
            }
            
            
        }
        
        OperationQueue.main {
            self.completionHandler?(data:self.data,response:self.response,error:self.error)
        }
        
    }
    
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        var disposition: Foundation.URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential:URLCredential? = self.credential
        
        if let handler:challengeHandler = challengeHandler {
            
            (disposition, credential) = handler(session, challenge)
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            //1.认证方法是服务端信任
            
            //2.如果服务端信任存在
            if let serverTrust = challenge.protectionSpace.serverTrust {
                //3.验证服务端的信任
                if WTURLSessionDelegate.trustIsValid(serverTrust) {
                    //4.如果验证成功了,使用服务端的信任创建凭据
                    credential = URLCredential(trust: serverTrust)
                }
            }
        }
        //使用凭据,note:这里必须调用,否则可能会产生内存泄漏
        completionHandler(disposition,credential)
    }
    
    
    //URLSessionDataTaskDelegate
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Swift.Void){
        self.response = response
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        self.data += data
        OperationQueue.main {
            self.progressHandler?(countOfBytesReceived: dataTask.countOfBytesReceived,countOfBytesExpectedToReceive: dataTask.countOfBytesExpectedToReceive)
        }
        
        
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: (CachedURLResponse?) -> Swift.Void){
        if self.error == nil {
            let cachePolicy = dataTask.originalRequest?.cachePolicy
            if cachePolicy == .returnCacheDataElseLoad {
                completionHandler(proposedResponse)
                return
            }
        }
        completionHandler(nil)
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?){
        self.error = error
        finish()
    }
    
    
    
    //URLSessionDownloadDelegate
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        
    }
    
}


public class WTURLSessionDelegate:NSObject,URLSessionDataDelegate{
    
    
    private static let sharedInstance = {
        return WTURLSessionDelegate()
    }()
    
    //网址凭据
    var credential: URLCredential?
    
    
    
    private var taskDelegates: [Int: WTURLSessionTask] = [:]
    private let delegateQueue = OperationQueue()
    public subscript(task: URLSessionTask) -> WTURLSessionTask? {
        get{
            var result:WTURLSessionTask?
            let operation = BlockOperation {[unowned self] in
                result = self.taskDelegates[task.taskIdentifier]
            }
            delegateQueue.addOperations([operation], waitUntilFinished: true)
            return result
        }
        set{
            taskDelegates[task.taskIdentifier] = newValue
        }
    }
    
    public var challengeHandler:challengeHandler?
    
    
    // MARK: Delegate Methods
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: NSError?){
        
    }
    
    static func trustIsValid(_ trust:SecTrust) -> Bool {
        var isValid = false
        
        var result = SecTrustResultType.invalid
        //评估这个信任
        let status = SecTrustEvaluate(trust, &result)
        
        //评估成功
        if status == errSecSuccess {
            
            //用户未指定
            let unspecified = SecTrustResultType.unspecified
            //总是信任
            let proceed = SecTrustResultType.proceed
            
            isValid = result == unspecified || result == proceed
        }
        
        return isValid
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        
        var disposition: Foundation.URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential:URLCredential? = self.credential
        
        if let handler:challengeHandler = challengeHandler {
            
            (disposition, credential) = handler(session, challenge)
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            //1.认证方法是服务端信任
            
            //2.如果服务端信任存在
            if let serverTrust = challenge.protectionSpace.serverTrust {
                //3.验证服务端的信任
                if WTURLSessionDelegate.trustIsValid(serverTrust) {
                    //4.如果验证成功了,使用服务端的信任创建凭据
                    credential = URLCredential(trust: serverTrust)
                }
            }
        }
        //使用凭据,note:这里必须调用,否则可能会产生内存泄漏
        completionHandler(disposition,credential)
    }
    
    
    
    
    
    
    
    
    #if !os(OSX)
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession){
    }
    #endif
    
    
    
    // MARK: URLSessionTaskDelegate
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?){
        if let myTask = self[task] {
            myTask.urlSession(session, task: task, didCompleteWithError: error)
        }else{
            
        }
        
    }
    
    
    
    
    // MARK: URLSessionDataDelegate
    
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Swift.Void){
        if let task = self[dataTask] {
            task.urlSession(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
        }else{
            completionHandler(URLSession.ResponseDisposition.allow)
        }
        
        
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: (CachedURLResponse?) -> Swift.Void){
        if let task = self[dataTask]{
            task.urlSession(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
        }else{
            completionHandler(nil)
        }
        
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
    }
    
    @available(iOS 9.0, *)
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask){
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        if let task = self[dataTask] {
            task.urlSession(session, dataTask: dataTask, didReceive: data)
        }else{
        }
        
    }
}



extension UInt{
    
    
    /*!
     计算阶乘
     */
    public static func wt_factorial(number:UInt)->UInt{
        if number == 1 {
            return 1
        }else{
            return number * wt_factorial(number: (number - 1))
        }
        
        
    }
}
extension Int{
    
    
    
    /*!
     斐波那契数列,用递归实现的,容易出现栈溢出,推荐用颗粒化来做
     */
    public static func wt_fibonacci(number:UInt)->UInt{
        if number < 0 {
            return 0
        }
        if number <= 1 {
            return 1
        }else{
            return wt_fibonacci(number: number - 2) + wt_fibonacci(number: number - 1)
        }
    }
    
    
    
    /*
     public static func wt_fibonacciCurry(number:Int)->Int{
     var total:Int = 0
     func sum(number1:Int)->Int{
     if number1 == 1 || number1 == 0 {
     return 1
     }else{
     return sum(number1: number1 - 2) + sum(number1: number1 - 1)
     }
     }
     return sum(number1: number - 2) + sum(number1: number - 1)
     }
     */
    
    
    public func isEven() -> Bool{
        return (self%2) == 0
    }
    
    /*!
     尾递归
     */
    func tailSum(_ n: UInt) -> UInt {
        func sumInternal(_ n: UInt, current: UInt) -> UInt {
            if n == 0 {
                return current
            } else {
                return sumInternal(n - 1, current: current + n)
            }
        }
        
        return sumInternal(n, current: 0)
    }
}

extension NSObject{
    
    
    /*!
     交换实例方法
     */
    public static func exchangeInstanceImplementations(_ func1:Selector , func2:Selector){
        method_exchangeImplementations(class_getInstanceMethod(self, func1), class_getInstanceMethod(self, func2));
    }
    
    /*!
     交换类方法
     */
    public static func exchangeClassImplementations(_ func1:Selector , func2:Selector){
        method_exchangeImplementations(class_getClassMethod(self, func1), class_getClassMethod(self, func2));
    }
    
    
    public func performBlock(_ block: () -> Void , afterDelay:Double){
        //Swift 不允许数据在计算中损失,所以需要在计算的时候转换以下类型
        let time = Int64(afterDelay * Double(NSEC_PER_SEC))
        let t = DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC)
        DispatchQueue.main.after(when: t, execute: block)
        //        DispatchQueue.main.after(when: t, block: block)
        
    }
    
    /*!
     递归遍历:先深度
     note:必须是可用的的json对象
     */
    public static func traversal(_ obj:AnyObject){
        if JSONSerialization.isValidJSONObject(obj) {
            if let array = obj as? Array<AnyObject> {
                for item in array{
                    traversal(item)
                }
            }else if let dict = obj as? Dictionary<String,AnyObject>{
                for (_,value) in dict{
                    traversal(value)
                }
            }else {
                print(obj)
            }
        }
    }
    
    
    /*!
     非递归遍历
     */
    /*
     public static func wt_tarversal(with obj:AnyObject){
     
     func tarversalOneDepth(with objects:AnyObject)->[AnyObject]{
     
     
     var result = [AnyObject]()
     if let array:[AnyObject] = objects as? Array<AnyObject>{
     for t in array{
     if let u:[AnyObject] = t as?Array<AnyObject> {
     result.append(contentsOf: u)
     }else if let v:[String:AnyObject] = t as? Dictionary<String,AnyObject>{
     result.append(contentsOf: v.values)
     }
     }
     }
     return result
     
     }
     
     var tempArray = [AnyObject]()
     tempArray.append(obj)
     
     
     repeat{
     let r = tarversalOneDepth(with: tempArray)
     for a in r{
     print("print : \(a)")
     }
     tempArray = r
     }while (tempArray.count != 0)
     
     }
     */
    
}

//数据缓存
private var wt_sharedURLCacheForRequestsKey:Void?
extension URLCache{
    
    /*!
     数据缓存
     */
    public static func wt_sharedURLCacheForRequests()->URLCache{
        var cache = objc_getAssociatedObject(OperationQueue.main, &wt_sharedURLCacheForRequestsKey)
        if cache is URLCache {
            
        }else{
            //0M memory, 1G Disk
            //            let diskCapacity:Int = 4 * 1024 * 1024 * 1024
            cache = URLCache(memoryCapacity: 0, diskCapacity: 1*1024*1024*1024, diskPath: "wt_sharedURLCacheForRequestsKey")
            objc_setAssociatedObject(OperationQueue.main, &wt_sharedURLCacheForRequestsKey, cache, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
        return cache as! URLCache
        
    }
    
    
    
}
extension Array{
    
    /*!
     排序方法,这个方法的效率很垃圾,不要尝试使用,想优化的帮我优化一下吧.
     mutating 代表该方法将会改变该对象的内部结构,比如排序什么的.
     */
    /*
     public mutating func wtSort( _ isOrderedBefore: @noescape(Array.Iterator.Element, Array.Iterator.Element) -> Bool)->Array!{
     //        let result = self;
     let count = self.count-1
     for i in 0..<count{
     var obj1 = self[i]
     var obj2 = self[i+1]
     if(isOrderedBefore(obj1,obj2) == true){
     swap(&obj1, &obj2)
     }
     }
     for i in 0..<count{
     let obj1 = self[i]
     let obj2 = self[i+1]
     if(isOrderedBefore(obj1,obj2) == true){
     self.wtSort(isOrderedBefore)
     }
     }
     
     return self
     }
     */
    
    
    
    
}
extension OperationQueue{
    
    
    // MARK: - 快捷线程切换
    /*!
     到默认的全局队列做事情
     优先级是默认的
     */
    public static func globalQueue(_ block: () -> Void)->Void{
        globalQueue(.qosDefault,block: block)
    }
    
    
    /*!
     优先级:交互级的
     */
    public static func userInteractive(_ block:()->Void)->Void{
        globalQueue(.qosUserInteractive, block: block)
    }
    
    /*!
     后台执行
     */
    public static func background(_ block:()->Void)->Void{
        globalQueue(.qosBackground, block: block)
    }
    
    
    /*!
     进入一个全局的队列来做事情,可以设定优先级
     */
    public static func globalQueue(_ priority:DispatchQueue.GlobalAttributes,block:()->Void)->Void{
        DispatchQueue.global(attributes: priority).async(execute: block)
    }
    
    /*!
     回到主线程做事情
     */
    public static func main(_ block: () -> Swift.Void)->Void{
        OperationQueue.main.addOperation(block)
    }
}
extension Operation{
    
}

extension Dictionary{
    
}
extension Data{
    
    /*!
     utf-8 string
     */
    public func toUTF8String()->String{
        let string = String.init(data: self, encoding: String.Encoding.utf8)
        if string == nil {
            return ""
        }
        return string!
    }
    
    /*!
     Create a Foundation object from JSON data.
     */
    public func parseJson()->AnyObject?{
        var obj:AnyObject? = nil
        do{
            try obj = JSONSerialization.jsonObject(with: self, options: [])
        } catch _{
        }
        return obj
    }
    
    /*!
     Create a Foundation object from JSON data.
     */
    public func parseJSON(handler block:(AnyObject?,NSError?)->Void){
        var obj:AnyObject = "not a json"
        var theError:NSError?
        do{
            try obj = JSONSerialization.jsonObject(with: self, options: .mutableLeaves)
        }catch let error as NSError{
            theError = error
        }
        block(obj,theError)
    }
    //public func +(lhs: Date, rhs: TimeInterval) -> Date
    
    
}
//public func +(lhs: [String],rhs: [String]) -> [String]{

//}

public func +(lhs: Data, rhs: Data) -> Data{
    var data = lhs
    data.append(rhs)
    return data
}
public func +=(lhs: inout Data, rhs: Data){
    lhs.append(rhs)
}
extension Date{
    public func numberFor(component unit:Calendar.Unit)->Int{
        return Calendar.current.component(unit, from: self)
    }
    public var year:Int{
        get{
            return numberFor(component: .year)
        }
    }
    public var month:Int{
        get{
            return numberFor(component:.month)
        }
    }
    public var day:Int{
        get{
            return numberFor(component:.day)
        }
    }
    public var hour:Int{
        get{
            return numberFor(component:.hour)
        }
    }
    public var weekOfYear:Int{
        get{
            return numberFor(component: .weekOfYear)
        }
    }
    public var minute:Int{
        get{
            return numberFor(component:.minute)
        }
    }
    public var second:Int{
        get{
            return numberFor(component:.second)
        }
    }
    public func stringWithDateFormat(_ format:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    
}
extension Predicate{
}

extension RegularExpression{
    
    public static func wt_englishWord()->RegularExpression{
        var r:RegularExpression?
        do{
            try r = RegularExpression(pattern: "^\\w+$", options: [])
        } catch _{
        }
        
        return r!
    }
    public static func wt_eMail()->RegularExpression{
        var r:RegularExpression?
        do{
            try r = RegularExpression(pattern: "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?", options: [])
        } catch _{
        }
        
        return r!
    }
    public static func wt_phoneNumber()->RegularExpression{
        var r:RegularExpression?
        do{
            try r = RegularExpression(pattern: "^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$", options: [])
        } catch _{
        }
        
        return r!
    }
    
    public static func wt_ipv4()->RegularExpression{
        var r:RegularExpression?
        do{
            try r = RegularExpression(pattern: "\\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b", options: [])
        } catch _{
        }
        return r!
    }
    public static func wt_ipv6()->RegularExpression{
        var r:RegularExpression?
        do{
            try r = RegularExpression(pattern: "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))", options: [])
        } catch _{
        }
        return r!
    }
}

extension String{
    
    //TODO MD5
    
    //"$＄¥￥231"
    /*!
     半角的RMB符号，加删除线的时候比较方便,不会和数字看起来不同
     Half-width
     注意:如果是全角的和数字放在一起加删除线不会连接在一起
     
     ¥ 全角 ￥半角
     */
    public static func RMBSymbol()->String{
        return "¥"
    }
    
    /*!
     half-width dollar
     $ 半角   ＄全角
     */
    public static func DollarSymbol()->String{
        return "$"
    }
    
    subscript(range:Range<Int>)->String{
        get{
            let startIndex = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = self.characters.index(self.startIndex, offsetBy: range.upperBound);
            return self[Range(startIndex..<endIndex)]
        }
    }
    public var length:Int{
        return self.characters.count
    }
    //将十六进制字符串转换成十进制
    public static func changeToInt(_ num:String) -> Int{
        
        let str = num.uppercased();
        var result = 0
        for i in str.utf8{
            result = result*16 + Int(i) - 48   //0-9   48开始
            if  i >= 65 {     // A-Z   65开始
                result -= 7
            }
        }
        return result;
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var intValue:Int{
        return (self as NSString).integerValue
    }
    
    public func parseJSON(handler block:jsonHandler)->Void{
        let data = self.data(using: String.Encoding.utf8)
        data?.parseJSON(handler: block)
    }
    
    public func toUTF8Data()->Data{
        var data = self.data(using: String.Encoding.utf8)
        if data == nil {
            data = Data()
        }
        return data!
    }
    
    
    #if os(iOS)
    /*!
     *  用于计算文字高度
     */
    public func boundingRectWithSize(_ size: CGSize, options: NSStringDrawingOptions, attributes: [String : AnyObject]?, context: NSStringDrawingContext?) -> CGRect{
        let string:NSString = self
        return string.boundingRect(with: size, options: options, attributes: attributes, context: context)
    }
    #endif
}


#if os(iOS)
    // MARK: - Reachbility
    public enum WTNetworkStatus:UInt{
        //无连接
        case notReachable = 0
        //Wi-Fi
        case reachableViaWiFi = 1
        //蜂窝数据
        case reachableViaWWAN = 2
    }
    public let kWTReachabilityChangedNotification = "kWTReachabilityChangedNotification"
    func ReachabilityCallback(_ reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutablePointer<Void>?) {
        assert(info != nil)
        let noteObject = Unmanaged<WTReachability>.fromOpaque(info!).takeUnretainedValue()
        NotificationCenter.default.post(name: Notification.Name(rawValue: kWTReachabilityChangedNotification), object: noteObject, userInfo: nil)
    }
    public class WTReachability:NSObject{
        
        var _reachabilityRef:SCNetworkReachability?
        
        /*!
         * Use to check the reachability of a given host name.
         */
        public class func reachabilityWithHostName(_ hostName:String)->WTReachability{
            
            var returnValue:WTReachability?
            let reachability = SCNetworkReachabilityCreateWithName(nil, hostName);
            if reachability != nil {
                returnValue = WTReachability()
                returnValue?._reachabilityRef = reachability
            }
            return returnValue!
        }
        
        /*!
         * Use to check the reachability of a given IP address.
         */
        public class func reachabilityWithAddress(_ hostAddress: UnsafePointer<sockaddr>)->WTReachability?{
            let reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
            var returnValue:WTReachability?
            if reachability != nil {
                returnValue = WTReachability()
                returnValue?._reachabilityRef = reachability
            }
            return returnValue
            
        }
        
        /*!
         * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
         */
        public class func reachabilityForInternetConnection(_ complection:(reachability:WTReachability)->Void) -> Void{
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            withUnsafePointer(&zeroAddress, {
                let reachability:WTReachability = WTReachability.reachabilityWithAddress(UnsafePointer($0))!
                complection(reachability:reachability)
            })
        }
        
        public func startNotifier()->Bool{
            var returnValue = false
            
            var context:SCNetworkReachabilityContext = SCNetworkReachabilityContext()
            //public var info: UnsafeMutablePointer<Swift.Void>?
            //public init(_ from: OpaquePointer)
            
            context.info = UnsafeMutablePointer(bridge(obj: self))
            
            if SCNetworkReachabilitySetCallback(_reachabilityRef!, ReachabilityCallback, &context) {
                if SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef!, CFRunLoopGetCurrent(), RunLoopMode.defaultRunLoopMode.rawValue) {
                    returnValue = true
                }
            }
            return returnValue
        }
        public func stopNotifier(){
            if _reachabilityRef != nil {
                SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef!, CFRunLoopGetCurrent(), RunLoopMode.defaultRunLoopMode.rawValue)
            }
        }
        
        func networkStatusForFlags(_ flags:SCNetworkReachabilityFlags)->WTNetworkStatus{
            if !flags.contains(.reachable) {
                return .notReachable
            }
            
            var returnValue:WTNetworkStatus = .notReachable
            
            
            if !flags.contains(.connectionRequired) {
                returnValue = .reachableViaWiFi
            }
            
            if flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic) {
                if !flags.contains(.interventionRequired) {
                    returnValue = .reachableViaWiFi
                }
            }
            
            
            if flags.intersection(.isWWAN) == .isWWAN {
                returnValue = .reachableViaWWAN
            }
            
            return returnValue
        }
        
        func connectionRequired()->Bool{
            assert(_reachabilityRef != nil)
            var flags:SCNetworkReachabilityFlags = .reachable
            if SCNetworkReachabilityGetFlags(_reachabilityRef!, &flags) {
                return (flags.contains(.connectionRequired))
            }
            return false
        }
        
        /*!
         当前网络状态
         */
        public func currentReachabilityStatus()->WTNetworkStatus{
            assert(_reachabilityRef != nil)
            let returnValue:WTNetworkStatus = .notReachable
            var flags:SCNetworkReachabilityFlags = .reachable
            if SCNetworkReachabilityGetFlags(_reachabilityRef!, &flags) {
                return networkStatusForFlags(flags)
            }
            return returnValue
        }
        
        deinit {
            stopNotifier()
        }
        
    }
#endif
/*
 print 的源码
 @inline(never)
 @_semantics("stdlib_binary_only")
 public func print(
 _ items: Any...,
 separator: String = " ",
 terminator: String = "\n"
 ) {
 if let hook = _playgroundPrintHook {
 var output = _TeeStream(left: "", right: _Stdout())
 _print(
 items, separator: separator, terminator: terminator, to: &output)
 hook(output.left)
 }
 else {
 var output = _Stdout()
 _print(
 items, separator: separator, terminator: terminator, to: &output)
 }
 }
 */


