//
//  WTVersionTracking.swift
//  WTKit
//
//  Created by SongWentong on 10/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation

import UIKit

private let UIApplicationVersionsKey = "WTKit UIapplication versions key"
private let UIApplicationBuildsKey = "WTKit UIapplication builds key"
public extension UIApplication{
    //bundle name eg.com.xxx.xxx
    class func appBundleName()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    //bundleid  eg.2345678
    class func appBundleID()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
    //build version eg.1234
    class func buildVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
    //app version eg. 1.2.1
    static func appVersion()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
public extension UIApplication{
    /*!
     track each launch,Repeat safety
     not you should track at app launch method
     @available(iOS 3.0, *)
     optional func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
     */
    func track(){
        if VersionTracker.shared.launchTrakced {
            return
        }
        var versionArray:[String] = self.versionHistory()
        if !versionArray.contains(UIApplication.appVersion()) {
            versionArray.append(UIApplication.appVersion())
        }
        
        var buildArray = buildHistory()
        if !buildArray.contains(UIApplication.buildVersion()) {
            buildArray.append(UIApplication.buildVersion())
             VersionTracker.shared.isFirstLaunchForBuild = true
        }else{
            VersionTracker.shared.isFirstLaunchForBuild = false
        }
        UserDefaults.standard.setValue(versionArray, forKey: UIApplicationVersionsKey)
        UserDefaults.standard.setValue(buildArray, forKey: UIApplicationBuildsKey)
        //        WTLog(versionArray)
        //        WTLog(buildArray)
        UserDefaults.standard.synchronize()
        VersionTracker.shared.launchTrakced = true
    }
    /*!
     check current is first lunch for this build
     note don't call this method before track()
     */
    func isFirstLaunchForBuild(_ block:(_ isFirstLaunchForBuild:Bool)->Void){
        block(VersionTracker.shared.isFirstLaunchForBuild)
    }
    //version history,if no history,return empty string array
    func versionHistory()->[String]{
        if let versionHistory = UserDefaults.standard.array(forKey: UIApplicationVersionsKey) as? [String]{
            return versionHistory
        }
        return [String]()
    }
    //build history,if no history,return empty string array
    func buildHistory()->[String]{
        if let versionHistory = UserDefaults.standard.array(forKey: UIApplicationBuildsKey) as? [String]{
            return versionHistory
        }
        return [String]()
    }
}
class VersionTracker: NSObject {
    var launchTrakced:Bool = false
    var isFirstLaunchForBuild:Bool = false
    static let shared:VersionTracker = {
        return VersionTracker()
    }()
}
