//
//  UsageDemo.swift
//  
//
//  Created by Wentong Song on 2022/4/14.
//

import Foundation
///default model
public struct DefaultModel<T:Codable>:Codable{
    var code:Int?
    var data:T
    var error:String?
    var msg:String?
}
///inner model
public struct API2Model:Codable{
    var a:Int
    var b:String
}
/**
    this manager will be your api requester
 这里是常规使用的Demo,你可以简单的把这份代码拷贝到项目中
 修改一下类命,或者继承一下,修改domain就可以使用了
 */
open class DemoNetWorkManager{
    var domain = "https://apple.com"
    var defaultParas = [String:String]()
    /**
        服务器的接口对应的请求与解析方法
     */
    func api1(finish object:@escaping (DefaultModel<Int>)->Void) {
        WT.dataTask(with: domain + "/api1", method: .get, parameters: defaultParas, object: object) { d, u, e in
        }
    }
    func api2(with para:[String:String],finish object:@escaping (DefaultModel<API2Model>)->Void) {
        var cp = para
        defaultParas.forEach { (key: String, value: String) in
            cp[key] = value
        }
        WT.dataTask(with: domain + "/api2", method: .post, parameters:cp, object: object) { d, u, e in
        }
    }
    /**
        使用Demo
     */
    func usageDemo() {
        DemoNetWorkManager().api1 { num in
            print(num)
        }
        //["abc" : "123"]
        DemoNetWorkManager().api2(with: ["a" : "111","b":"222"]) { (model:DefaultModel<API2Model>) in
            //a = 111
            print(model.data.a)
            //b = 222
            print(model.data.b)
        }
    }
    
}
