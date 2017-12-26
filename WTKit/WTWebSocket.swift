//
//  WTSocket.swift
//  WTKit
//
//  Created by Wentong Song on 2017/12/26.
//  Copyright © 2017年 songwentong. All rights reserved.
//

import Foundation
//socket 状态
public enum WTWebSocketReadyState{
    case connecting
    case open
    case closing
    case closed
}
public class WTWebSocket:NSObject{
//    var inputStream:InputStream = InputStream()
    var url:URL?
    var originRequest:URLRequest
    var delegateDispatchQueue:DispatchQueue?
    var delegateOperationQueue:OperationQueue?
    var readyState:WTWebSocketReadyState
    var workQueue:OperationQueue
    var readBuffer:DispatchData = DispatchData.empty
    var writeBuffer:DispatchData = DispatchData.empty
//    var inputStream:InputStream?
//    var outp
    var currentFrameData:Data = Data()
    //var consumers:
    init(request:URLRequest) {
        originRequest = request
        url = request.url
        readyState = .connecting
        workQueue = OperationQueue.init()
        if url != nil{
//            inputStream = InputStream.init(url: url!)
        }
        super.init()
    }
    public func open(){
        guard readyState == .connecting else {
            return
        }
        if(originRequest.timeoutInterval > 0){
            let popTime = DispatchTime.init(uptimeNanoseconds: UInt64(originRequest.timeoutInterval) * NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
                if self.readyState == .connecting{
                    //return error
                }
            })
        }
        configStream()
    }
    public func configStream(){
//        inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    public func close(){}
    public func sendData(){}
    public func sendString(){}
}
/*
extension WTWebSocket:StreamDelegate{
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event){
        
    }
}
*/
public protocol WTWebSocketDelegate:NSObjectProtocol{
    func webSocketDidOpen(with socket:WTWebSocket)
}
extension WTWebSocketDelegate{
    public func webSocketDidOpen(with socket:WTWebSocket){
        
    }
}
