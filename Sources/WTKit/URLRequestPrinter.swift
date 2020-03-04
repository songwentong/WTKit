//
//  URLRequestPrinter.swift
//  
//
//  Created by 宋文通 on 2020/3/4.
//

import Foundation
///printer
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
///print URLRequest as curl command,copy and run with terminal
public class URLRequestPrinter:CustomDebugStringConvertible,CustomStringConvertible {
    var request:URLRequest = URLRequest.init(url: "".urlValue)
    public var description: String{
        var components: [String] = []
        
        if let HTTPMethod = request.httpMethod {
            components.append(HTTPMethod)
        }
        
        if let urlString = request.url?.absoluteString {
            components.append(urlString)
        }
        let desc = components.joined(separator: " ")
        return desc
    }
    public var debugDescription: String{
        var components = ["$ curl -v"]
        
        guard let url = request.url else {
            return "$ curl command could not be created"
        }
        
        if let httpMethod = request.httpMethod {
            components.append("-X \(httpMethod)")
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

