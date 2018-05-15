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
    case weixinAPI = "https://api.weixin.qq.com/sns/oauth2"//微信
    case others = "http://lalala"//其他的
}
enum ServerMethod: String {
    case testGet = "get"
    case testPost = "post"
}

