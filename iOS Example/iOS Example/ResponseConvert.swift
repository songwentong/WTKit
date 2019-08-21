//
//  ResponseConvert.swift
//  iOS Example
//
//  Created by 宋文通 on 2018/6/26.
//  Copyright © 2018年 songwentong. All rights reserved.
//

import Foundation
import WTKit
import Alamofire
extension WTURLSessionDataTask{
    func convert<T: Codable>(finished: @escaping (T)->Void,
                             failed: @escaping (NetworkingErrorType)->Void) -> Void {
        completionHandler =  {(data, response, error) in
            guard error == nil else{
                failed(NetworkingErrorType.networkError)//网络异常
                return
            }
            guard let responseData = data else {
                failed(NetworkingErrorType.unknown)//没有数据,未知异常
                return
            }
            do{
                let result = try JSONDecoder().decode(T.self, from: responseData)//类型转换
                finished(result)
            }catch{
                failed(NetworkingErrorType.analyzeFailed)//解析失败
                return
            }
        }
    }
    func convertBaseType<T:Codable>(finished1: @escaping (T)->Void,
                                    failed: @escaping (NetworkingErrorType)->Void) -> Void{
        convert(finished: { (obj:CommonResponse<EmptyModel>) in
            if obj.returnCode == 0{
                self.convert(finished: { (result:CommonResponse<T>) in
                    finished1(result.responseData)//解析成功
                }, failed: failed)//解析失败
            }else{
                failed(NetworkingErrorType.returnCode(obj.returnCode))//返回码
            }
        }, failed: failed)//之前的异常
    }
    
}
















