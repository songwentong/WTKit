//
//  WTURLSessionManager.swift
//  WTKit
//
//  Created by SongWentong on 15/03/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#endif
/// HTTP method definitions.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
public enum HTTPMethod:String{
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}


open class WTURLSessionManager:NSObject{
    
    
    open static let sharedInstance = {
        return WTURLSessionManager()
    }()
    
    open var startRequestsImmediately: Bool = true
    
    //网址凭据
    var credential: URLCredential?
    
    open static let `default`: WTURLSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHTTPHeaders
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
    
    
    public func dataTask(with url:URLConvertible, method:HTTPMethod = .get, parameters:[String:Any]? = nil,headers: [String: String]? = nil)->WTURLSessionDataTask
    {
        var request = URLRequest(url: url.asURL())
        request.httpMethod = method.rawValue
        if let headers = headers{
            for (key,value) in headers{
                request.setValue(value , forHTTPHeaderField: key)
            }
        }
        do{
            let encodedURLRequest = try WTURLSessionManager.sharedInstance.encode(request, with: parameters)
            return WTURLSessionManager.sharedInstance.dataTask(with: encodedURLRequest)
        }catch{
        }
        return WTURLSessionDataTask(task: URLSessionTask());
    }
    
    //data task
    public func dataTask(with request:URLRequest)->WTURLSessionDataTask{
        let task = WTURLSessionManager.default.session!.dataTask(with: request)
        let myTask = WTURLSessionDataTask(task: task)
        WTURLSessionManager.default[task] = myTask
        if startRequestsImmediately {
            myTask.resume()
        }
        return myTask
    }
    
}
extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}


// MARK: - encode and query
extension WTURLSessionManager{
    
    /*!
     创建一个URLRequest实例
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
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    public func encode(_ urlRequest: URLRequest, with parameters:[String:Any]?) throws -> URLRequest{
        var urlRequest = urlRequest
        guard let parameters = parameters else { return urlRequest }
        if let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                return urlRequest
            }
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                var percentEncodedQuery = urlComponents.percentEncodedQuery.map{ $0 + "&" } ?? ""
                percentEncodedQuery += query(parameters)
                urlRequest.url = urlComponents.url
            }
        }
        return urlRequest
    }
    private func encodesParametersInURL(with method: HTTPMethod) -> Bool {
        switch method {
        case .get, .head, .delete:
            return true
        default:
            return false
        }
    }
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        }else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        }else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        }
        return components
    }
    
    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
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


