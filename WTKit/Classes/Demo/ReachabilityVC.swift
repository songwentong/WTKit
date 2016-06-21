//
//  ReachabilityVC.swift
//  WTKit
//
//  Created by SongWentong on 6/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class ReachabilityVC: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var remoteHostLabel: UITextField!
    @IBOutlet weak var remoteHostImageView: UIImageView!
    @IBOutlet weak var remoteHostStatusField: UITextField!
    @IBOutlet weak var internetConnectionImageView: UIImageView!
    
    @IBOutlet weak var internetConnectionStatusField: UITextField!
    var reachability:WTReachability = WTReachability.reachabilityWithHostName("www.apple.com")
    var internetReachability:WTReachability?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaryLabel.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserverForName(kWTReachabilityChangedNotification, object: nil, queue: nil) { [weak self](notification) in
            
            let reachability:WTReachability = notification.object as! WTReachability
            
            
//            WTPrint("reachability : \(reachability) self?.reachability:\(self?.reachability) self?.internetReachability \(self?.internetReachability)")
            
            self?.updateInterfaceWithReachability(reachability)
            
        }
        
        WTReachability.reachabilityForInternetConnection { [weak self](reachability) in
            self?.internetReachability = reachability
            reachability.startNotifier()
            self?.updateInterfaceWithReachability(reachability)
        }
        reachability.startNotifier()
        updateInterfaceWithReachability(reachability)

    }
    
    func updateInterfaceWithReachability(reachability:WTReachability){
        var dict:[WTNetworkStatus:String] = [WTNetworkStatus:String]()
        dict[WTNetworkStatus.NotReachable] = "无网络"
        dict[WTNetworkStatus.ReachableViaWiFi] = "已连接Wi-Fi"
        dict[WTNetworkStatus.ReachableViaWWAN] = "通过蜂窝数据接入网络"
        var imageNames:[WTNetworkStatus:String] = [WTNetworkStatus:String]()
        imageNames[WTNetworkStatus.NotReachable] = "stop-32"
        imageNames[WTNetworkStatus.ReachableViaWiFi] = "Airport"
        imageNames[WTNetworkStatus.ReachableViaWWAN] = "WWAN5"
        if reachability == self.reachability{
            let status = reachability.currentReachabilityStatus()
            self.remoteHostStatusField.text = dict[status]
            
            self.remoteHostImageView.image = UIImage(named: imageNames[status]!)
            
            self.summaryLabel.hidden = false
            if(status != .ReachableViaWWAN){
                self.summaryLabel.hidden = true
            }
            var baseLabelText = ""
            if (reachability.connectionRequired()){
                baseLabelText = "Cellular data network is available.\nInternet traffic will be routed through it after a connection is established."
            }else{
                baseLabelText = "Cellular data network is active.\nInternet traffic will be routed through it."
            }
            self.summaryLabel.text = baseLabelText
        }else if reachability == self.internetReachability{
            let status = reachability.currentReachabilityStatus()
            self.internetConnectionStatusField.text = dict[status]
            self.internetConnectionImageView.image = UIImage(named: imageNames[status]!)
        }
    }
    deinit{
        reachability.stopNotifier()
        internetReachability?.stopNotifier()
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
