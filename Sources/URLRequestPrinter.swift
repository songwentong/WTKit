//
//  URLRequestPrinter.swift
//  
//
//  Created by 宋文通 on 2020/3/4.
//

import Foundation
///request打印
public extension URLRequest{
    ///print URLRequest as curl command,copy and run with terminal
    var printer:URLRequestPrinter{
        let p = URLRequestPrinter()
        p.request = self
        return p
    }
}
///printer
public extension URLSessionTask{
    var printer:URLRequestPrinter{
        guard let req = self.originalRequest else{
            return URLRequestPrinter()
        }
        let result = URLRequestPrinter()
        result.request = req
        return result
    }
}
// MARK: - URLRequestPrinter
/**
 print URLRequest as curl command,copy and run with terminal
 把URLRequest的curl 命令打印出来,不需要直接用
 举个例子print(request.printer)
 会输出一个类似于
 curl -v https://www.apple.com
 -H
 -d
 -b
 的命令,放到终端里面就可以直接执行了
 */
public class URLRequestPrinter:CustomDebugStringConvertible,CustomStringConvertible {
    var request:URLRequest = URLRequest.init(url: "".urlValue)
    public var description: String{
        return debugDescription
    }
    public var debugDescription: String{
        var components = ["$ curl -v"]
        
        guard let url = request.url else {
            return "$ curl command could not be created"
        }
        guard let host = url.host else{
            return "$ curl command could not be created"
        }
        
        if let httpMethod = request.httpMethod {
            components.append("-X \(httpMethod)")
        }
        
        let configuration = URLSession.default.configuration
        if let credentialStorage = configuration.urlCredentialStorage {
            let protectionSpace = URLProtectionSpace(host: host,
                                                     port: url.port ?? 0,
                                                     protocol: url.scheme,
                                                     realm: host,
                                                     authenticationMethod: NSURLAuthenticationMethodHTTPBasic)

            if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
                for credential in credentials {
                    guard let user = credential.user, let password = credential.password else { continue }
                    components.append("-u \(user):\(password)")
                }
            } else {
//                if let credential = credential, let user = credential.user, let password = credential.password {
//                    components.append("-u \(user):\(password)")
//                }
            }
        }
        
        
        if configuration.httpShouldSetCookies{
            if let cookieStorage = configuration.httpCookieStorage,
               let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty{
               let allCookies = cookies.map { "\($0.name)=\($0.value)" }.joined(separator: ";")
               components.append("-b \"\(allCookies)\"")
            }
        }
        
        var headers: [AnyHashable: Any] = [:]
        /*
         session.configuration.httpAdditionalHeaders?.filter {  $0.0 != AnyHashable("Cookie") }
         .forEach { headers[$0.0] = $0.1 }
         */
        request.allHTTPHeaderFields?.filter { $0.0 != "Cookie" }
            .forEach { headers[$0.0] = $0.1 }
        components += headers.map {
            let escapedValue = String(describing: $0.value).replacingOccurrences(of: "\"", with: "\\\"")
            return "-H \"\($0.key): \(escapedValue)\""
        }
        
        
        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
            
            components.append("-d \"\(escapedBody)\"")
        }
        
        components.append("\"\(url.absoluteString)\"")
        
        let result = components.joined(separator: " \\\n\t")
        return result
    }
}

