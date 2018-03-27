//
//  DispatchExtension.swift
//  WTKit
//
//  Created by Wentong Song on 2018/1/4.
//  Copyright © 2018年 songwentong. All rights reserved.
//

import Foundation
import Dispatch

extension DispatchQueue{
    public static func backgroundQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }
    public static func utilityQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
    }
    public static func userInitiatedQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
    }
    public static func userInteractiveQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    }
    
    public static func globalQueue()->DispatchQueue{
        return DispatchQueue(label: "globalQueue");
    }
    
    //安全同步到主线程
    public static func safeSyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        let main:DispatchQueue = DispatchQueue.main
        if Thread.isMainThread {
            main.async(execute: work)
        }else{
            main.sync(execute: work)
        }
        //        print("425 wt test")
    }
    
    //异步回到主线程
    public static func asyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        DispatchQueue.main.async(execute: work)
    }
    
    //到分线程中
    public static func asyncGlobalQueue(execute work: @escaping @convention(block) () -> Swift.Void){
        DispatchQueue.global().async(execute: work)
    }
    
}

extension OperationQueue{
    
    
    
    /*!
     到默认的全局队列做事情
     优先级是默认的
     */
    public static func globalQueue(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        globalQueue(qos: .default,execute: work)
    }
    
    
    /*!
     优先级:交互级的
     */
    public static func userInteractive(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        globalQueue(qos: .userInteractive, execute: work)
    }
    
    /*!
     后台执行
     */
    public static func background(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        globalQueue(qos: .background, execute: work)
    }
    
    
    /*!
     进入一个全局的队列来做事情,可以设定优先级
     */
    public static func globalQueue(qos:DispatchQoS.QoSClass,execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        
        DispatchQueue.global(qos: qos).async(execute: work);
        //        DispatchQueue.global(qos: qos).async {
        //            work()
        //        }
        //        DispatchQueue.global(attributes: priority).async(execute: block)
    }
    
    /*!
     回到主线程做事情
     */
    public static func toMain(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        DispatchQueue.main.async(execute: work)
        //        OperationQueue.main.addOperation {
        //            block()
        //        }
    }
}
