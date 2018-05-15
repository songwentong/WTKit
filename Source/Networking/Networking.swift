//
//  Networking.swift
//  WTKit
//
//  Created by 宋文通 on 2018/5/15.
//  Copyright © 2018年 songwentong. All rights reserved.
//

import Foundation
typealias APIParameters = [String: Any]//参数

final class Networking {
    
}

extension Networking{
    open static let `default`: Networking = {
        return Networking()
    }()
    func url(with domain:Domain = .testURL,apiName:ServerMethod, appendString: String? = nil) -> URL {
        //        let urlString = domain.rawValue + "/" + apiName.rawValue + "/" + appendString
        var strings = [domain.rawValue,apiName.rawValue]
        if let temp = appendString{
            strings.append(temp)
        }
        let urlString = strings.joined(separator: "/")
        let url = URL.init(string: urlString)
        return url!
    }
}
extension Networking {
    @discardableResult
    func network_request<T: Codable>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: APIParameters? = nil,
        encoding: [String:Any],
        headers: HTTPHeaders? = nil,
        finished: @escaping (T)->Void,
        failed: @escaping (NetworkingErrorType)->Void)  -> WTURLSessionDataTask
    {
        
        return network_request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, finished: { (data, response) in
            do{
                let code = try JSONDecoder().decode(CommonResponse<EmptyModel>.self, from: data)//校验响应码
                if code.returnCode == 0{
                    let detailResponseModel = try JSONDecoder().decode(CommonResponse<T>.self, from: data)//解析数据
                    if let responseData = detailResponseModel.responseData{
                        finished(responseData)//正确解析
                    }else{
                        failed(NetworkingErrorType.analyzeFailed)//解析失败
                    }
                    
                }else{
                    failed(NetworkingErrorType.returnCode(code.returnCode))//retun不等于0
                }
            }catch{
                failed(NetworkingErrorType.analyzeFailed)//解析失败
            }
        }) { (error) in
            failed(NetworkingErrorType.networkError)//网络异常
        }
    }
}
extension Networking{
    @discardableResult
    func network_request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: APIParameters? = nil,
        encoding: [String:Any],
        headers: HTTPHeaders? = nil,
        finished: @escaping (Data,URLResponse)->Void,
        failed: @escaping (Error)->Void) -> WTURLSessionDataTask
    {
        let task = dataTask(with: url, method: method, parameters: parameters, headers: headers)
        task.completionHandler = {(data, response, error) in
            guard error == nil else{
                failed(NetworkingErrorType.networkError)//网络异常
                return
            }
            if let data1 = data,let res1 = response{
                finished(data1,res1)
            }
            failed(NetworkingErrorType.unknown)
        }
        return task
    }
}
extension Networking{
}

