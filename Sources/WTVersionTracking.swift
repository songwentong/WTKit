//
//  WTVersionTracking.swift
//  WTKit
//
//  Created by 宋文通 on 10/04/2017.
//  Copyright © 2017 宋文通. All rights reserved.
//
import Foundation
#if os(macOS)
import AppKit
public typealias WTApplication = NSApplication
#endif
#if os(iOS)
import UIKit
public typealias WTApplication = UIApplication
#endif
fileprivate let WTApplicationVersionsKey = "WTKit VersionTracker versions key"
fileprivate let WTApplicationBuildsKey = "WTKit VersionTracker builds key"
#if os(iOS) || os(macOS)
public extension WTApplication{
    /// make a track, it is time safe ,track twice = one time 
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
        UserDefaults.standard.setValue(versionArray, forKey: WTApplicationVersionsKey)
        UserDefaults.standard.setValue(buildArray, forKey: WTApplicationBuildsKey)
        UserDefaults.standard.synchronize()
        VersionTracker.shared.launchTrakced = true
    }
    /*
     check current is first lunch for this build
     note don't call this method before track()
     */
    func isFirstLaunchForBuild()->Bool{
        VersionTracker.shared.isFirstLaunchForBuild
    }
    /// version history,if no history,return empty string array
    func versionHistory()->[String]{
        if let versionHistory = UserDefaults.standard.array(forKey: WTApplicationVersionsKey) as? [String]{
            return versionHistory
        }
        return [String]()
    }
    /// build history,if no history,return empty string array
    func buildHistory()->[String]{
        if let versionHistory = UserDefaults.standard.array(forKey: WTApplicationBuildsKey) as? [String]{
            return versionHistory
        }
        return [String]()
    }
}
#endif

class VersionTracker: NSObject {
    var launchTrakced:Bool = false
    var isFirstLaunchForBuild:Bool = false
    static let shared:VersionTracker = {
        return VersionTracker()
    }()
}
