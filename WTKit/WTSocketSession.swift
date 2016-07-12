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
}
