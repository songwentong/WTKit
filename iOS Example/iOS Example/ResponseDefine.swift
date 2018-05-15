//
//  Response.swift
//  WTKit
//
//  Created by 宋文通 on 2018/5/15.
//  Copyright © 2018年 songwentong. All rights reserved.
//

import Foundation
enum NetworkingErrorType: Error {
    case networkError    //网络异常
    case analyzeFailed  //model解析错误
    case serverCode(Int)   //http响应码,不需要处理,都是200
    case returnCode(Int)     //return码,未处理
    case unknown        //未知错误
}
//常规响应
struct CommonResponse<T: Codable>: Codable {
    let returnCode: Int
    let message: String
    let responseData: T?
    
    enum CodingKeys: String, CodingKey {
        case returnCode = "ret"
        case message = "msg"
        case responseData = "data"
    }
}

//空对象,用于只需要return code的请求
struct EmptyModel: Codable{
    
}
