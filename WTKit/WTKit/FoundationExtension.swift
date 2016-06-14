//  https://github.com/swtlovewtt/WTKit
//  FoundationExtension.swift
//  WTKit
//
//  Created by SongWentong on 4/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import Foundation
#if os(iOS)
    import MobileCoreServices
    import UIKit
#elseif os(OSX)
    import CoreServices
#endif

/*
//这个方法用于注释程序内所有已有的log
public func print(
        items: Any...,
    separator: String = " ",
    terminator: String = "\n"
    ) {
 #if DEBUG
    Swift.print(items)
 #endif
}
 */

/*!
    用于DEBUG模式的log
 */
func WTPrint<T>(items:T,
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
public func WTLog(
    items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    file: String = #file,
    method: String = #function,
    line: Int = #line
    ) {
    #if DEBUG
        if UIApplication.WTKitLogMode {
            print("\((file as NSString).lastPathComponent)[\(line)], \(method)")
            print(items,separator: separator,terminator: terminator)
        }
    #endif
    
}

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

//DEBUG执行的方法
public func DEBUGBlock(block:() -> Void){
    #if DEBUG
        block()
    #else
    #endif
}

/*!
    安全的回到主线程
*/
public func safeSyncInMain(block:dispatch_block_t)->Void{
    if NSThread.currentThread().isMainThread {
        block()
    }else{
        dispatch_sync(dispatch_get_main_queue(), block)
    }
}

/*!
    延时执行的代码块
 */
public func performOperationWithBlock(block:dispatch_block_t, afterDelay:NSTimeInterval){
    //Swift 不允许数据在计算中损失,所以需要在计算的时候转换以下类型
    let time = Int64(afterDelay * Double(NSEC_PER_SEC))
    let t = dispatch_time(DISPATCH_TIME_NOW, time)
    dispatch_after(t, dispatch_get_main_queue(), block)
}


extension NSURLSession{
    
    /*!
        创建一个请求然后发送
     */
    public static func dataTaskWith(url:String, method:String?="GET", parameters:[String:String]?=[:],headers: [String: String]? = [:], completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) ->NSURLSessionDataTask{
        let request = NSMutableURLRequest.request(url,method: method,parameters: parameters,headers: headers)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            NSOperationQueue.main({ 
                completionHandler(data,response,error)
            })
        }
        task.resume()
        return task
    }
    
    /*!
        创建并执行请求
     */
    public static func dataTaskWithRequest(request:NSURLRequest , completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)->NSURLSessionDataTask{
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            NSOperationQueue.main({
                completionHandler(data,response,error)
            })
        }
        task.resume()
        return task
    }
    
    public static func cachedDataTaskWithRequest(request:NSURLRequest , completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)->Void{
        let cache = NSURLCache.sharedURLCacheForUIImage()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            NSOperationQueue.main({ 
                completionHandler(data,response,error)
            })
            
            if error != nil{
                //保存当前请求
                cache.storeCachedResponse(NSCachedURLResponse.init(response: response!, data: data!, userInfo: nil, storagePolicy: .Allowed), forRequest: request)
            }
        }
        
        let cachedResponseForRequest = cache.cachedResponseForRequest(request)
        //如果有本地保存,就直接使用
        if cachedResponseForRequest != nil {
            NSOperationQueue.main({ 
                completionHandler(cachedResponseForRequest?.data,cachedResponseForRequest?.response,nil)
            })
        }else{
            task.resume()
        }

    }
}
extension NSURLRequest{
    
    /*!
        根据url,方法,参数和header创建一个请求
        方法默认是GET,参数默认是空,请求头默认是空
     */
    public class func request(url:String, method:String?="GET", parameters:[String:String]?=[:],headers: [String: String]? = [:]) -> NSMutableURLRequest{
        
        let queryStringFromParameters = self.queryStringFromParameters(parameters)!
        var request:NSMutableURLRequest
        var urlString:String
        request = NSMutableURLRequest()
        request.HTTPMethod = method!
        if(self.methodShouldAddQuery(method!)){
            urlString = String(format: "%@?%@", url,queryStringFromParameters)
        }else{
            urlString = url
            request.HTTPBody = queryStringFromParameters.dataUsingEncoding(NSUTF8StringEncoding)
        }
        request.URL = NSURL(string: urlString)
        request.allHTTPHeaderFields = headers
 
      
        return request
    }
    
    
    //需要拼接query 的方法
    class func methodShouldAddQuery(method:String)->Bool{
        let query = ["GET","HEAD","DELETE"]
        if(query.contains(method)){
            return true
        }else{
            return false
        }
    }
    
    
    //从参数转成字符串
    class func queryStringFromParameters(parameters:[String: String]?=[:])->String? {
        
        //        Array
        //        Dictionary
        if parameters == nil {
            return ""
        }
        var components: [(String, String)] = Array()
        for (key) in parameters!.keys.sort(<){
            let value = parameters![key]!
            components.append((key, value))
        }
        let result = (components.map{ "\($0)=\($1)" } as [String]).joinWithSeparator("&")
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        return result.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
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
    public class func upLoadFile(url:String, method:String,parameters:[String:String]?=[:],body:[[String:AnyObject]]?=[])->NSMutableURLRequest {
        let boundary = "Boundary+1F52B974B3E5F39D"
        let theURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: theURL!)
        request.HTTPMethod = method
        let HTTPBody = NSMutableData()
        
        
        //加上开头
        HTTPBody.appendData(String(format: "--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        //把相关参数加上
        if parameters != nil {
            for (key,value) in parameters!{
                let header = String(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key)
                HTTPBody.appendData(header.dataUsingEncoding(NSUTF8StringEncoding)!)
                HTTPBody.appendData(value.dataUsingEncoding(NSUTF8StringEncoding)!)
                HTTPBody.appendData(String(format: "--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        
        
        
        //枚举把相关的数据加上
        if body != nil {
            for(part) in body!{
                
                //把字典的数值取出来
                let name = part["name"] as! String
                let filename = part["filename"] as! String
                let contentType = part["contentType"] as! String
                let content = part["content"] as! NSData
                
                let disposition:String = String(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename)
                let contentTypeString:String = String(format: "Content-Type: %@\r\n\r\n", contentType)
                HTTPBody.appendData(disposition.dataUsingEncoding(NSUTF8StringEncoding)!)
                HTTPBody.appendData(contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)!)
                HTTPBody.appendData(content)
                HTTPBody.appendData(String(format: "--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        
        
        //加上结尾
        HTTPBody.appendData(String(format: "\r\n--%@--\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        request.HTTPBody = HTTPBody
        
        
        //告知边界的字符串
        let contentType = String(format: "multipart/form-data; boundary=%@", boundary)
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        //告知数据长度
        request.setValue(NSNumber(integer: HTTPBody.length).stringValue, forHTTPHeaderField: "Content-Length")
        return request
    }
}


extension Int{
    public static func random(min:Int,max:Int) -> Int{
         return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }

    public func isEven() -> Bool{
        return (self%2) == 0
    }
    
    /*!
     尾递归
     */
    func tailSum(n: UInt) -> UInt {
        func sumInternal(n: UInt, current: UInt) -> UInt {
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
    public static func exchangeInstanceImplementations(func1:Selector , func2:Selector){
        method_exchangeImplementations(class_getInstanceMethod(self, func1), class_getInstanceMethod(self, func2));
    }
    
    /*!
        交换类方法
     */
    public static func exchangeClassImplementations(func1:Selector , func2:Selector){
        method_exchangeImplementations(class_getClassMethod(self, func1), class_getClassMethod(self, func2));
    }
    
    
    public func performBlock(block: () -> Void , afterDelay:Double){
        //Swift 不允许数据在计算中损失,所以需要在计算的时候转换以下类型
        let time = Int64(afterDelay * Double(NSEC_PER_SEC))
        let t = dispatch_time(DISPATCH_TIME_NOW, time)
        dispatch_after(t, dispatch_get_main_queue(), block)
    
    }
    
    /*!
        递归遍历:先深度
        note:必须是可用的的json对象
     */
    public static func traversal(obj:AnyObject){
        if NSJSONSerialization.isValidJSONObject(obj) {
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
    
    
}


//图片下载的key
private var sharedURLCacheForUIImageKey:Void?
extension NSURLCache{
    
    /*!
        图片缓存
     */
    public static func sharedURLCacheForUIImage()->NSURLCache{
        var cache =  objc_getAssociatedObject(NSOperationQueue.mainQueue(), &sharedURLCacheForUIImageKey)
        if cache is NSURLCache {
            return cache as! NSURLCache
        }else{
            cache = NSURLCache(memoryCapacity: 4*1024, diskCapacity: 1024*10242, diskPath: "cacheForImage")
            objc_setAssociatedObject(NSOperationQueue.mainQueue(), &sharedURLCacheForUIImageKey, cache, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return cache as! NSURLCache
        }
    }
}
extension Array{
    
    /*!
        排序方法,这个方法的效率很垃圾,不要尝试使用,想优化的帮我优化一下吧.
        mutating 代表该方法将会改变该对象的内部结构,比如排序什么的.
     */
    public mutating func wtSort(@noescape isOrderedBefore: (Array.Generator.Element, Array.Generator.Element) -> Bool)->Array!{
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
    

    

}
extension NSOperationQueue{
    
    /*!
     到默认的全局队列做事情
     优先级是默认的
     */
    public static func globalQueue(block: () -> Void)->Void{
        globalQueue(QOS_CLASS_DEFAULT,block: block)
    }
    
    
    /*!
        优先级:交互级的
     */
    public static func userInteractive(block:()->Void)->Void{
        globalQueue(QOS_CLASS_USER_INTERACTIVE, block: block)
    }
    
    /*!
        后台执行
     */
    public static func background(block:()->Void)->Void{
        globalQueue(QOS_CLASS_BACKGROUND, block: block)
    }
    
    
    /*!
        进入一个全局的队列来做事情,可以设定优先级
     */
    public static func globalQueue(priority:qos_class_t,block:()->Void)->Void{
        dispatch_async(dispatch_get_global_queue(priority, 0), block)
    }
    
    /*!
     回到主线程做事情
     */
    public static func main(block: () -> Void)->Void{
        NSOperationQueue.mainQueue().addOperationWithBlock(block)
    }
}
extension Array{
    
}
extension NSOperation{

}

extension Dictionary{
    
}
extension NSData{
    
    
    /*!
        Create a Foundation object from JSON data.
     */
    public func jsonValue()->(AnyObject,NSError?){
        var obj:AnyObject = "not a json"
        var theError:NSError?
        do{
            try obj = NSJSONSerialization.JSONObjectWithData(self, options: .MutableLeaves)
        }catch let error as NSError{
            theError = error
        }
        return (obj,theError)
    }
    
    /*!
        Create a Foundation object from JSON data.
     */
    public func parseJSON(block:(AnyObject,NSError?)->Void){
        var obj:AnyObject = "not a json"
        var theError:NSError?
        do{
            try obj = NSJSONSerialization.JSONObjectWithData(self, options: .MutableLeaves)
        }catch let error as NSError{
            theError = error
        }
        block(obj,theError)
    }
}
extension NSDate{
    public func numberFor(unit:NSCalendarUnit)->Int{
        return NSCalendar.currentCalendar().component(unit, fromDate: self)
    }
}
extension String{

    //TODO MD5
    
    
    subscript(range:Range<Int>)->String{
        get{
            let startIndex = self.startIndex.advancedBy(range.startIndex)
            let endIndex = self.startIndex.advancedBy(range.endIndex);
            return self[Range(startIndex..<endIndex)]
        }
    }
    public var length:Int{
        return self.characters.count
    }
    //将十六进制字符串转换成十进制
    public static func changeToInt(num:String) -> Int{
        
        let str = num.uppercaseString;
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
    
    public func parseJSON(block: (AnyObject,NSError?)->Void)->Void{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        
        data?.parseJSON(block)
    }
 
}
extension CGRect{
    public var centerPoint:CGPoint{
        return CGPointMake(CGRectGetMidX(self), CGRectGetMinY(self))
    }
}