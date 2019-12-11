//
//  WTVersionTracking.swift
//  WTKit
//
//  Created by 宋文通 on 10/04/2017.
//  Copyright © 2017 宋文通. All rights reserved.
//
#if os(iOS)
import Foundation

import UIKit

private let UIApplicationVersionsKey = "WTKit UIapplication versions key"
private let UIApplicationBuildsKey = "WTKit UIapplication builds key"
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
        if !versionArray.contains(Bundle.appVersion()) {
            versionArray.append(Bundle.appVersion())
        }
        
        var buildArray = buildHistory()
        if !buildArray.contains(Bundle.buildVersion()) {
            buildArray.append(Bundle.buildVersion())
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
#endif
