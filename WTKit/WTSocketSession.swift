//
//  WTSocketSession.swift
//  WTKit
//
//  Created by SongWentong on 7/12/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import Foundation
public protocol WTSocketSessionDelegate:NSObjectProtocol{
    func socket(socket:WTSocketSession, didReceiveMessage:AnyObject)
    func socketdidOpen(socket:WTSocketSession)
    func socket(socket:WTSocketSession, didfailWithError:NSError)
    func socket(socket:WTSocketSession, didCloseWIthCode:Int, reason:String, wasClean:Boolean)
    func socker(socket:WTSocketSession, didReceivePong:Data)
}
public class WTSocketSession:NSObject{
    weak var delegate:WTSocketSessionDelegate?
    var request:URLRequest?
    var delegateQueue:OperationQueue?
    var inputStream:InputStream?
    var outputStream:OutputStream?
    var allowsUntrustedSSLCertificates:Boolean = false
    override init(){
        delegateQueue = OperationQueue()
//        var port = 80
//        var readStream
//        var writeStream
//        CFStreamCreatePairWithSocketToHost(nil, request?.url?.host, port, brid, &writeStream)
    }
    public func open(){
    }
    public func close(){
    }
    public func send(data:AnyObject){
        
    }
}
