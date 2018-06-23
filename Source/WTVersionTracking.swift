//
//  WTVersionTracking.swift
//  WTKit
//
//  Created by SongWentong on 10/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit

private let UIApplicationVersionsKey = "WTKit UIapplication versions key"
private let UIApplicationBuildsKey = "WTKit UIapplication builds key"
private var UIApplicationIsFirstEver:Void?
private var UIApplicationLaunchTrackedKey:Void?
extension UIApplication{
    //bundle name eg.com.xxx.xxx
    public class func appBundleName()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    //bundleid  eg.2345678
    public class func appBundleID()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
    //build version eg.1234
    public class func buildVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    //app version eg. 1.2.1
    public static func appVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
extension UIApplication{
    /*!
     track each launch,Repeat safety
     not you should track at app launch method
     @available(iOS 3.0, *)
     optional public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
     */
    public func track(){
        if launchTrakced {
            return
        }
        var versionArray:[String] = self.versionHistory()
        if !versionArray.contains(UIApplication.appVersion()) {
            versionArray.append(UIApplication.appVersion())
        }
        
        var buildArray = buildHistory()
        if !buildArray.contains(UIApplication.buildVersion()) {
            buildArray.append(UIApplication.buildVersion())
             self.isFirstLaunchForBuild = true
        }else{
            self.isFirstLaunchForBuild = false
        }
        UserDefaults.standard.setValue(versionArray, forKey: UIApplicationVersionsKey)
        UserDefaults.standard.setValue(buildArray, forKey: UIApplicationBuildsKey)
        //        WTLog(versionArray)
        //        WTLog(buildArray)
        UserDefaults.standard.synchronize()
        launchTrakced = true
    }
    /*!
     check current is first lunch for this build
     note don't call this method before track()
     */
    public func isFirstLaunchForBuild(_ block:(_ isFirstLaunchForBuild:Bool)->Void){
        block(self.isFirstLaunchForBuild)
    }
    //version history,if no history,return empty string array
    public func versionHistory()->[String]{
        if let versionHistory = UserDefaults.standard.array(forKey: UIApplicationVersionsKey) as? [String]{
            return versionHistory
        }
        return [String]()
    }
    //build history,if no history,return empty string array
    public func buildHistory()->[String]{
        if let versionHistory = UserDefaults.standard.array(forKey: UIApplicationBuildsKey) as? [String]{
            return versionHistory
        }
        return [String]()
    }
    private var launchTrakced:Bool{
        get{
            if let trakced = objc_getAssociatedObject(self, &UIApplicationLaunchTrackedKey) as? Bool{
                return trakced
            }
            return false
        }
        set{
            objc_setAssociatedObject(self, &UIApplicationLaunchTrackedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /*!
     
     */
    private var isFirstLaunchForBuild:Bool{
        get{
            if let isFirst = objc_getAssociatedObject(self, &UIApplicationIsFirstEver) as? Bool{
                return isFirst
            }
            return true
        }
        set{
            objc_setAssociatedObject(UIApplication.shared, &UIApplicationIsFirstEver, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
#endif
