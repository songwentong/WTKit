//
//  WTNetWork.swift
//  WTKit
//
//  Created by SongWentong on 09/12/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import Foundation
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
    static func queryString(from parameters:[String: Any]?=[:])->String? {
        
        //        Array
        //        Dictionary
        if parameters == nil {
            return nil
        }
        
        
        var components: [(String, Any)] = Array()
        let allkeys = parameters?.keys.sorted(by: { (s1,s2) -> Bool in
            return s1 < s2
        })
        for (key) in allkeys!{
            let value = parameters![key]!
            components.append((key, value))
        }
        
        
        let result = (components.map{ "\($0)=\($1)"} as [String]).joined(separator: "&")
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: ":#[]@!$&'()*+,;=")
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
    
    
    //    public static func wt_sharedInstance()->URLSession{
    //        let delegate = WTURLSessionManager.sharedInstance
    //        let configuration = URLSessionConfiguration.default
    //        configuration.urlCache = URLCache.wt_sharedURLCacheForRequests()
    //        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: OperationQueue())
    //        return session
    //    }
    
//    public static let wt_sharedInstance:URLSession = {
//        let delegate = WTURLSessionManager.sharedInstance
//        let configuration = URLSessionConfiguration.default
//        configuration.urlCache = URLCache.wt_sharedURLCacheForRequests
//        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: OperationQueue())
//        return session
//        
//    }()
    
    /*
     便捷的请求方法.
     */
//    public static func wt_dataTask(with url:String, method:httpMethod? = .GET,parameters:[String:String]?=[:],headers: [String: String]? = [:] ,credential:URLCredential?=nil,completionHandler:@escaping completionHandler)->WTURLSessionTask{
//        let request = URLRequest.wt_request(with: url, method: method, parameters: parameters, headers: headers)
//        return self.wt_dataTask(with: request,credential:credential, completionHandler: completionHandler)
//    }
    
    /*!
     根据请求对象,凭据来创建task
     */
//    public static func wt_dataTask(with request:URLRequest,credential:URLCredential?=nil,completionHandler:@escaping completionHandler)->WTURLSessionTask{
//        let session = self.wt_sharedInstance
//        let task = session.dataTask(with: request)
//        let myTask = WTURLSessionTask(task: task)
//        WTURLSessionManager.sharedInstance[task] = myTask
//        myTask.completionHandler = completionHandler
//        myTask.credential = credential
//        //WTURLSessionManager.sharedInstance.credential = credential
//        return myTask
//    }
    
//    public static func wt_uploadTask(with request:URLRequest,from bodyData:Data,credential:URLCredential?=nil,completionHandler:@escaping completionHandler)->WTURLSessionTask{
//        let session = self.wt_sharedInstance
//        let task = session.uploadTask(with: request, from: bodyData)
//        let myTask = WTURLSessionTask(task: task)
//        WTURLSessionManager.sharedInstance[task] = myTask
//        myTask.completionHandler = completionHandler
//        myTask.credential = credential
//        //        WTURLSessionManager.sharedInstance.credential = credential
//        return myTask
//    }
    
//    public static func wt_downloadTask(with request:URLRequest,credential:URLCredential?=nil,completionHandler:@escaping completionHandler)->WTURLSessionTask{
//        
//        let session = self.wt_sharedInstance
//        let task = session.downloadTask(with: request)
//        let myTask = WTURLSessionTask(task: task)
//        WTURLSessionManager.sharedInstance[task] = myTask
//        myTask.completionHandler = completionHandler
//        myTask.credential = credential
//        //        WTURLSessionManager.sharedInstance.credential = credential
//        return myTask
//    }
//    
    
//    public static func wt_cachedDataTask(with request:URLRequest ,credential:URLCredential?=nil, completionHandler:@escaping completionHandler)->WTURLSessionTask{
//        
//        
//        //        let configuration = URLSessionConfiguration.default
//        let session = self.wt_sharedInstance
//        var myRequest = request
//        myRequest.cachePolicy = .returnCacheDataElseLoad
//        let task = session.dataTask(with: myRequest)
//        let myTask = WTURLSessionTask(task: task)
//        WTURLSessionManager.sharedInstance[task] = myTask
//        myTask.completionHandler = completionHandler
//        myTask.credential = credential
//        //        WTURLSessionManager.sharedInstance.credential = credential
//        return myTask
//    }
    
    
}

/*
 open func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
 */

//进度获取
public typealias progressHandler = ((_ countOfBytesReceived: Int64 ,_ countOfBytesExpectedToReceive: Int64) -> Void)
//完成回调
public typealias completionHandler = ((Data?, URLResponse?, Error?) -> Swift.Void)
//json解析回调
public typealias jsonHandler = ((Any?,Error?)->Void)
//字符串回调
public typealias stringHandler = ((String?,Error?)->Void)
//凭证回调,把session和challenge传入,给出一个Disposition和URLCredential
public typealias challengeHandler = ((Foundation.URLSession, URLAuthenticationChallenge) -> (Foundation.URLSession.AuthChallengeDisposition, URLCredential?))

open class WTURLSessionTask:NSObject{
    //网址凭据
    public var credential: URLCredential?
    //完成回调
    public var completionHandler:completionHandler?
    public var jsonHandler:jsonHandler?
    public var stringHandler:stringHandler?
    //进度获取
    public var progressHandler:progressHandler?
    public var response:URLResponse?
    public var challengeHandler:challengeHandler?
    public var useRequestingIfHave:Bool = false
    public var originTask:URLSessionTask{
        get{
            return task;
        }
    }
    
    /*
     这里的task和data是私有的,原因在于不允许外界修改,想要得到原始的task只需要调用otigintask就可以了
     */
    //原始的task
    open var task: URLSessionTask
    //懒加载,需要的时候创建对象
    open lazy var data:Data = Data()
    open var error: Error?
    
    
    init(task: URLSessionTask) {
        self.task = task
    }
    deinit {
        WTLog("deinit")
    }
    
    open func resume(){
        if useRequestingIfHave {
            
        }
        task.resume()
    }
    open func suspend(){
        task.suspend()
    }
    open func cancel(){
        task.cancel()
    }
    
    func finish(){
        
        OperationQueue.globalQueue {
            
            if let jsonHandler = self.jsonHandler{
                self.data.parseJSON(handler: { (object, error) in
                    OperationQueue.toMain(execute: {
                        jsonHandler(object,error)
                    })
                })
                
                
            }
            
            if let stringHandler = self.stringHandler{
                let string = String.init(data: self.data, encoding: String.Encoding.utf8)
                OperationQueue.toMain {
                    stringHandler(string,self.error)
                }
            }
            
            
        }
        DispatchQueue.main.async {
            if let completionHandler = self.completionHandler{
                completionHandler(self.data,self.response,self.error)
            }
        }
    }
    
}
extension WTURLSessionTask:URLSessionTaskDelegate{
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        var disposition: Foundation.URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential:URLCredential? = self.credential
        
        if let handler:challengeHandler = challengeHandler {
            
            (disposition, credential) = handler(session, challenge)
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            //1.认证方法是服务端信任
            
            //2.如果服务端信任存在
            if let serverTrust = challenge.protectionSpace.serverTrust {
                //3.验证服务端的信任
                if WTURLSessionManager.trustIsValid(serverTrust) {
                    //4.如果验证成功了,使用服务端的信任创建凭据
                    credential = URLCredential(trust: serverTrust)
                }
            }
        }
        //使用凭据,note:这里必须调用,否则可能会产生内存泄漏
        completionHandler(disposition,credential)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        self.error = error
        finish()
        
    }
}
open class WTURLSessionDataTask:WTURLSessionTask,URLSessionDataDelegate{
    open var dataTask:URLSessionDataTask
    //-1代表永久,0代表不缓存
    open var cacheTime:Int = 0
    override init(task: URLSessionTask) {
        dataTask = task as! URLSessionDataTask
        super.init(task: task)
    }
    deinit {
        WTLog("deinit")
    }
    open override func resume(){
        if cacheTime == -1 {
            WTURLSessionManager.default.session?.configuration.urlCache?.getCachedResponse(for: dataTask, completionHandler: {(cachedResponse) in
                if cachedResponse != nil{
                    self.data = (cachedResponse?.data)!
                    self.response = cachedResponse?.response
                    self.finish()
                }else{
                    super.resume()
                }
            })
        }else{
            super.resume()
        }
        
    }
    open override func suspend(){
        super.suspend()
    }
    open override func cancel(){
        super.cancel()
    }
    

    
    
    //URLSessionDataTaskDelegate
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
        self.response = response
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        self.data += data
        OperationQueue.toMain {
            self.progressHandler?(dataTask.countOfBytesReceived,dataTask.countOfBytesExpectedToReceive)
        }
        
        
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void){
        var shouldCache:Bool = false;
        if self.error == nil {
            if let originalRequest = dataTask.originalRequest {
                let cachePolicy:URLRequest.CachePolicy = originalRequest.cachePolicy
                
                switch cachePolicy {
                case .returnCacheDataDontLoad:
                    shouldCache = true;
                case .returnCacheDataElseLoad:
                    shouldCache = true;
                default: break
                }
                
            }
            if cacheTime == -1 {
                shouldCache = true;
            }
            
        }
        if shouldCache {
            completionHandler(proposedResponse)
        }else{
            completionHandler(nil)
        }
    }
    
}


//下载进度
public typealias downloadProgressHandler = ((URLSession,URLSessionDownloadTask,Int64,Int64,Int64)->Swift.Void)
public typealias downloadTaskDidFinishDownloadingToURL = ((URLSession, URLSessionDownloadTask, URL)->Void)

open class WTURLSessionDownloadTask:WTURLSessionTask,URLSessionDownloadDelegate{
    var downloadTaskFinishHandler:downloadTaskDidFinishDownloadingToURL?
    var downloadProgressHandler:downloadProgressHandler?
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        if let handler = downloadTaskFinishHandler {
            handler(session,downloadTask,location)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        if let handler = downloadProgressHandler {
            handler(session,downloadTask,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64)
    {
        
    }
}
open class WTURLSessionUploadTask:WTURLSessionTask{

}

open class WTURLSessionManager:NSObject{
    
    
    static let sharedInstance = {
        return WTURLSessionManager()
    }()
    
    //网址凭据
    var credential: URLCredential?
    
    open static let `default`: WTURLSessionManager = {
        let configuration = URLSessionConfiguration.default
        return WTURLSessionManager(configuration: configuration)
    }()
    //
    private var taskDelegates: [Int: WTURLSessionTask] = [:]
    private let delegateQueue:OperationQueue
    private let taskSubscriptQueue:OperationQueue
    private let lock = NSLock()
    open var session: URLSession?
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        delegateQueue = OperationQueue()
        taskSubscriptQueue = OperationQueue()
        taskSubscriptQueue.maxConcurrentOperationCount = 1;
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: delegateQueue)
    }
    
    open subscript(task: URLSessionTask) -> WTURLSessionTask? {
        get{
            var result:WTURLSessionTask?
            let operation = BlockOperation.init { [weak self] in
                result = self?.taskDelegates[task.taskIdentifier]
            }
            taskSubscriptQueue.addOperations([operation], waitUntilFinished: true)
            return result
        }
        set(newValue){
            let operation = BlockOperation.init { [weak self] in
                self?.taskDelegates[task.taskIdentifier] = newValue
            }
            taskSubscriptQueue.addOperations([operation], waitUntilFinished: false)
        }
    }
    
    public var challengeHandler:challengeHandler?
    
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
    
    
}
// MARK: - URLSessionDelegate
extension WTURLSessionManager:URLSessionDelegate{
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?){
        
    }
    
    /*!
     
     参考:https://developer.apple.com/library/ios/technotes/tn2232/_index.html#//apple_ref/doc/uid/DTS40012884
     */
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        
        var disposition: Foundation.URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential:URLCredential? = self.credential
        
        if let handler:challengeHandler = challengeHandler {
            
            (disposition, credential) = handler(session, challenge)
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            //1.认证方法是服务端信任
            
            //2.如果服务端信任存在
            if let serverTrust = challenge.protectionSpace.serverTrust {
                //3.验证服务端的信任
                if WTURLSessionManager.trustIsValid(serverTrust) {
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
}
// MARK: - URLSessionTaskDelegate
extension WTURLSessionManager:URLSessionTaskDelegate{
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if let myTask = self[task] {
            myTask.urlSession(session, task: task, didCompleteWithError: error)
        }else{
            
        }
        self[task] = nil
    }
}
// MARK: - URLSessionDataDelegate
extension WTURLSessionManager:URLSessionDataDelegate{
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
        if let task = self[dataTask] as? WTURLSessionDataTask {
            task.urlSession(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
        }else{
            completionHandler(URLSession.ResponseDisposition.allow)
        }
        
        
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void){
        if let task = self[dataTask] as? WTURLSessionDataTask{
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
        if let task = self[dataTask] as? WTURLSessionDataTask {
            task.urlSession(session, dataTask: dataTask, didReceive: data)
        }else{
        }
        
    }
}
// MARK: - URLSessionDataDelegate
extension WTURLSessionManager:URLSessionDownloadDelegate{
    /* Sent when a download task that has completed a download.  The delegate should
     * copy or move the file at the given location to a new location as it will be
     * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
     * still be called.
     */
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
    }
    
    
    /* Sent periodically to notify the delegate of download progress. */

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
    }
    
    
    /* Sent when a download has been resumed. If a download failed with an
     * error, the -userInfo dictionary of the error will contain an
     * NSURLSessionDownloadTaskResumeData key, whose value is the resume
     * data.
     */

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        
    }
}

public func dataTask(with url:String, method:httpMethod? = .GET, parameters:[String:String]?=nil,headers: [String: String]?=nil) -> WTURLSessionDataTask{
    let queryString = URLRequest.queryString(from:parameters)
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
    
    if(URLRequest.methodShouldAddQuery(request.httpMethod!)){
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
    return dataTask(with: request)
}
//data task
public func dataTask(with request:URLRequest)->WTURLSessionDataTask{
    let task = WTURLSessionManager.default.session!.dataTask(with: request)
    let myTask = WTURLSessionDataTask(task: task)
    WTURLSessionManager.default[task] = myTask
    myTask.resume()
    return myTask
}
//下载的task
public func downloadTask(with request:URLRequest)->WTURLSessionDownloadTask{
    let task = WTURLSessionManager.default.session!.downloadTask(with: request)
    let myTask = WTURLSessionDownloadTask(task:task)
    WTURLSessionManager.default[task] = myTask
    myTask.resume()
    return myTask
}
public func uploadTask(with request:URLRequest)->WTURLSessionUploadTask{
    let task = WTURLSessionManager.default.session!.uploadTask(withStreamedRequest: request)
    let myTask = WTURLSessionUploadTask(task:task)
    WTURLSessionManager.default[task] = myTask
    myTask.resume()
    return myTask
}
open class WTURLSessionDelegate:NSObject{
    
}
extension WTURLSessionDelegate:URLSessionDelegate{

}
