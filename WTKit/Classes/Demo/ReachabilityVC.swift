//
//  ReachabilityVC.swift
//  WTKit
//
//  Created by SongWentong on 6/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class ReachabilityVC: UIViewController {

    @IBOutlet weak var remoteHostLabel: UITextField!
    @IBOutlet weak var remoteHostImageView: UIImageView!
    @IBOutlet weak var remoteHostStatusField: UITextField!
    
    var reachability:WTReachability = WTReachability.reachabilityWithHostName("www.apple.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reachability.startNotifier()
        NSNotificationCenter.defaultCenter().addObserverForName(kWTReachabilityChangedNotification, object: nil, queue: nil) { [weak self](notification) in
            
            let reachability:WTReachability = notification.object as! WTReachability
            print(reachability.currentReachabilityStatus())
            if reachability == self?.reachability{
                let status = reachability.currentReachabilityStatus()
                var dict:[WTNetworkStatus:String] = [WTNetworkStatus:String]()
                dict[WTNetworkStatus.NotReachable] = "无网络"
                dict[WTNetworkStatus.ReachableViaWiFi] = "已连接Wi-Fi"
                dict[WTNetworkStatus.ReachableViaWWAN] = "通过蜂窝数据接入网络"
                
                self?.remoteHostStatusField.text = dict[status]
                var imageNames:[WTNetworkStatus:String] = [WTNetworkStatus:String]()
                imageNames[WTNetworkStatus.NotReachable] = "stop-32"
                imageNames[WTNetworkStatus.ReachableViaWiFi] = "Airport"
                imageNames[WTNetworkStatus.ReachableViaWWAN] = "WWAN5"
                self?.remoteHostImageView.image = UIImage(named: imageNames[status]!)
            }else{
                WTPrint("其他的reachability")
            }
            
        }
        
        
//        WTReachability.reachabilityForInternetConnection()
    }
    deinit{
        reachability.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kWTReachabilityChangedNotification, object: nil)
        WTLog("deinit")
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
