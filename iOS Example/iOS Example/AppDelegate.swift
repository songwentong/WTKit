//
//  AppDelegate.swift
//  WTKit
//
//  Created by SongWentong on 3/3/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//

import UIKit
import Foundation
import WTKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?)
        -> Bool
    {
        application.track()
        application.track()
        application.isFirstLaunchForBuild { (flag) in
            print("\(flag)")
        }
        print("hello world(print)")
        print("\(String(describing: launchOptions)) \(Date())")
        WTKit.WTPrint("hello world(wtprint)")
        WTKit.WTLog("hello world(wtlog)")
        
        
//        print("\(0.1 + 0.2)")
//        let task = WTKit.dataTask(with: "http://www.aa.com");
//        print("\(String(describing: task.dataTask.originalRequest?.httpMethod))")
//        print("\(34.6-34)")
//        let a = Double.init(UIDevice.current.systemVersion)
//        print("\(String(describing: a))")
   
         /*
         member 必须是 本类的对象完全一致才行
         kind只要是本类或者子类的对象就可以了
         member必须是实例, kind不需要是实例
        print("\(self)")
        print("\(NSObject.isKind(of: NSObject.classForCoder()))")//true
        print("\(NSObject.isMember(of:NSObject.classForCoder()))")//false
        print("\(self.isMember(of: AppDelegate.classForCoder()))")//true
        print("\(self.isKind(of: AppDelegate.classForCoder()))")//true
        print("\(self.isMember(of: NSObject.classForCoder()))")//false
        print("\(self.isKind(of: NSObject.classForCoder()))")//true
         */

        return true
    }
    
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        WTKit.WTPrint("")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        WTKit.WTPrint("")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

