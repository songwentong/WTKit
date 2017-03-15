//
//  WTURLSessionTask.swift
//  WTKit
//
//  Created by SongWentong on 15/03/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
//进度获取
public typealias progressHandler = ((_ countOfBytesReceived: Int64 ,_ countOfBytesExpectedToReceive: Int64) -> Void)
//完成回调,包含成功,失败和数据,推荐使用
public typealias completionHandler = ((Data?, URLResponse?, Error?) -> Swift.Void)
//成功回调
public typealias finishHandler = (Data?,URLResponse?)->Void
//失败回调
public typealias failedHandler = (Error?)->Void
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
    public var finishHandler:finishHandler?
    public var failedHandler:failedHandler?
    public var stringHandler:stringHandler?
    #if os(iOS)
    public var imageHandler:((UIImage?,Error?)->Void)?
    #endif
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
        DispatchQueue.utilityQueue().async {
            if let jsonHandler = self.jsonHandler{
                self.data.parseJSON(handler: { (object, error) in
                    DispatchQueue.main.async {
                        jsonHandler(object,error)
                    }
                })
            }
            if let stringHandler = self.stringHandler{
                let string = String.init(data: self.data, encoding: String.Encoding.utf8)
                DispatchQueue.main.async {
                    stringHandler(string,self.error)
                }
            }
            #if os(iOS)
                if let imageHandler = self.imageHandler{
                    let image = UIImage.init(data: self.data)
                    DispatchQueue.main.async {
                        imageHandler(image,self.error)
                    }
                }
            #endif
        }
        DispatchQueue.main.async {
            if let completionHandler = self.completionHandler{
                completionHandler(self.data,self.response,self.error)
            }
            if let error = self.error{
                if let failedHandler = self.failedHandler{
                    failedHandler(error)
                }
            }else {
                if let finishHandler = self.finishHandler{
                    finishHandler(self.data,self.response)
                }
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
