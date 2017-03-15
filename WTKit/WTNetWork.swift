//
//  WTNetWork.swift
//  WTKit
//
//  Created by SongWentong on 09/12/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

// MARK: - Data Request
/// 常规data task
///
/// - Parameters:
///   - url: <#url description#>
///   - method: <#method description#>
///   - parameters: <#parameters description#>
///   - headers: <#headers description#>
/// - Returns: <#return value description#>
public func dataTask(with url:String, method:HTTPMethod = .get, parameters:[String:Any]? = nil,headers: [String: String]? = nil)->WTURLSessionDataTask
{
    if let myURL:URL = URL.init(string: url){
        var request = URLRequest(url: myURL)
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
        
    }
    return WTURLSessionDataTask(task: URLSessionTask());
}
private func aaa(){

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
