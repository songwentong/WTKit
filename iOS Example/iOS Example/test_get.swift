//
//  APIDemo.swift
//  News
//
//  Created by 宋文通 on 2018/5/2.
//  Copyright © 2018年 tempOrganization. All rights reserved.
//

import Foundation
public struct GetModel: Codable {
    
    var args: [String: Int]
    
    var headers: [String: String]
    
    var origin: String
    
    var url: String
    
    enum CodingKeys: String, CodingKey {
        
        case args = "args"
        
        case headers = "headers"
        
        case origin = "origin"
        
        case url = "url"
    }
}
extension Networking{
    class func test_get(with parameters: APIParameters? = nil,finish: @escaping (GetModel) -> Void, failed: @escaping (NetworkingErrorType) -> Void) -> Void {
        guard let url = Networking.default.url(apiName: .apiA)else {return}
        Networking.default.network_request(url, finished: finish, failed: failed)
    }
}

protocol ABC: AnyObject {
    var a:String{get set}
}
class B: Codable,ABC {
    var a:String
}
class C: Codable,ABC {
    var a:String
}
