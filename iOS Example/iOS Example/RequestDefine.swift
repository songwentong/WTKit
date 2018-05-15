//
//  RequestDefine.swift
//  WTKit
//
//  Created by 宋文通 on 2018/5/15.
//  Copyright © 2018年 songwentong. All rights reserved.
//

import Foundation
//public typealias HTTPHeaders = [String: String]
extension Networking {
    func url(with domain:Domain = .testURL,apiName:ServerMethod, appendString: String? = nil) -> URL {
        var strings = [domain.rawValue,apiName.rawValue]
        if let temp = appendString{
            strings.append(temp)
        }
        let urlString = strings.joined(separator: "/")
        let url = URL.init(string: urlString)
        return url!
    }
}
