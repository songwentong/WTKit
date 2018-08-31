//
//  URLAndMethod.swift
//  
//
//  Created by 宋文通 on 2018/5/15.
//

import Foundation
//域名
enum Domain:String {
    case testURL = "https://httpbin.org"//测试的
    case releaseURL = "https://www.apple.com"
    case weixinAPI = "https://api.weixin.qq.com/sns/oauth2"//微信
    case others = "http://lalala"//其他的
}
//接口名
enum APIName:String {
    case apiA = "A"
    case apiB = "B"
}
extension Networking{
    func url( domain:Domain = .testURL, apiName:APIName) -> URL? {
        let strings:[String] = [domain.rawValue,apiName.rawValue]
        return URL.init(string: strings.joined(separator: "/"))
    }
}
