//
//  WTNetWork.swift
//  WTKit
//
//  Created by SongWentong on 09/12/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
import Foundation
public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() -> URL
}

extension String: URLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() -> URL {
        if let url = URL(string: self){
            return url
        }
        return URL.init(string: "")!
    }
}

extension URL: URLConvertible {
    /// Returns self.
    public func asURL() -> URL { return self }
}

// MARK: - Data Request
/// data task
///
/// - Parameters:
///   - url: <#url description#>
///   - method: <#method description#>
///   - parameters: <#parameters description#>
///   - headers: <#headers description#>
/// - Returns: <#return value description#>
public func dataTask(with url:URLConvertible, method:HTTPMethod? = .get, parameters:[String:Any]? = nil,headers: [String: String]? = nil)->WTURLSessionDataTask
{
    return WTURLSessionManager.default.dataTask(with: url, method: method, parameters: parameters, headers: headers)
}
private func aaa(){

}

//download task
public func downloadTask(with request:URLRequest)->WTURLSessionDownloadTask{
    let task = WTURLSessionManager.default.session!.downloadTask(with: request)
    let myTask = WTURLSessionDownloadTask(task:task)
    WTURLSessionManager.default[task] = myTask
    myTask.resume()
    return myTask
}
/*
public func uploadTask(with request:URLRequest)->WTURLSessionUploadTask{
    let task = WTURLSessionManager.default.session!.uploadTask(withStreamedRequest: request)
    let myTask = WTURLSessionUploadTask(task:task)
    WTURLSessionManager.default[task] = myTask
    myTask.resume()
    return myTask
}
 */

