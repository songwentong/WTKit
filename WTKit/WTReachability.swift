//
//  WTReachability.swift
//  WTKit
//
//  Created by SongWentong on 19/12/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//
#if os(iOS)
import Foundation
import SystemConfiguration
public enum WTNetworkStatus:UInt{
    //无连接
    case notReachable = 0
    //Wi-Fi
    case reachableViaWiFi = 1
    //蜂窝数据
    case reachableViaWWAN = 2
}
public let kWTReachabilityChangedNotification = "kWTReachabilityChangedNotification"

open class WTReachability:NSObject{
    
    var _reachabilityRef:SCNetworkReachability?
    
    /*!
     * Use to check the reachability of a given host name.
     */
    public class func reachabilityWithHostName(_ hostName:String)->WTReachability{
        
        var returnValue:WTReachability?
        let reachability = SCNetworkReachabilityCreateWithName(nil, hostName);
        if reachability != nil {
            returnValue = WTReachability()
            returnValue?._reachabilityRef = reachability
        }
        return returnValue!
    }
    
    /*!
     * Use to check the reachability of a given IP address.
     */
    public class func reachabilityWithAddress(_ hostAddress: UnsafePointer<sockaddr>)->WTReachability?{
        let reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
        var returnValue:WTReachability?
        if reachability != nil {
            returnValue = WTReachability()
            returnValue?._reachabilityRef = reachability
        }
        return returnValue
        
    }
    
    /*!
     * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
     */
    /*
     public class func reachabilityForInternetConnection(_ complection:(_ reachability:WTReachability)->Void) -> Void{
     var zeroAddress = sockaddr_in()
     zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
     zeroAddress.sin_family = sa_family_t(AF_INET)
     withUnsafePointer(to: &zeroAddress, {
     let reachability:WTReachability = WTReachability.reachabilityWithAddress(UnsafePointer($0))!
     complection(reachability)
     })
     }
     */
    
    public func startNotifier()->Bool{
        //            var returnValue = false
        
        var context:SCNetworkReachabilityContext = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil);
        
        context.info = Unmanaged.passUnretained(self).toOpaque()
        
        //The function to be called when the reachability of the target changes.  If NULL, the current client for the target is removed.
        let callout:SystemConfiguration.SCNetworkReachabilityCallBack = {(reachbility, flag, pointer) in
            let noteObject = Unmanaged<WTReachability>.fromOpaque(pointer!).takeUnretainedValue()
            NotificationCenter.default.post(name: Notification.Name(rawValue: kWTReachabilityChangedNotification), object: noteObject, userInfo: nil)
        }
        let callbackEnabled = SCNetworkReachabilitySetCallback(_reachabilityRef!, callout, &context)
        
        return callbackEnabled
    }
    public func stopNotifier(){
        if _reachabilityRef != nil {
            SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef!, CFRunLoopGetCurrent(), RunLoopMode.defaultRunLoopMode.rawValue as CFString)
        }
    }
    
    func networkStatusForFlags(_ flags:SCNetworkReachabilityFlags)->WTNetworkStatus{
        if !flags.contains(.reachable) {
            return .notReachable
        }
        
        var returnValue:WTNetworkStatus = .notReachable
        
        
        if !flags.contains(.connectionRequired) {
            returnValue = .reachableViaWiFi
        }
        
        if flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic) {
            if !flags.contains(.interventionRequired) {
                returnValue = .reachableViaWiFi
            }
        }
        
        
        if flags.intersection(.isWWAN) == .isWWAN {
            returnValue = .reachableViaWWAN
        }
        
        return returnValue
    }
    
    public func connectionRequired()->Bool{
        assert(_reachabilityRef != nil)
        var flags:SCNetworkReachabilityFlags = .reachable
        if SCNetworkReachabilityGetFlags(_reachabilityRef!, &flags) {
            return (flags.contains(.connectionRequired))
        }
        return false
    }
    
    /*!
     当前网络状态
     */
    public func currentReachabilityStatus()->WTNetworkStatus{
        assert(_reachabilityRef != nil)
        let returnValue:WTNetworkStatus = .notReachable
        var flags:SCNetworkReachabilityFlags = .reachable
        if SCNetworkReachabilityGetFlags(_reachabilityRef!, &flags) {
            return networkStatusForFlags(flags)
        }
        return returnValue
    }
    
    deinit {
        stopNotifier()
    }
    
}
#else
#endif
