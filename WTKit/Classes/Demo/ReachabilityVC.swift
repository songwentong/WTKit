//
//  ReachabilityVC.swift
//  WTKit
//
//  Created by SongWentong on 6/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
/*  
    这是一个Reachability的使用,非常简单,看代码就可以了
 */
import UIKit

class ReachabilityVC: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var remoteHostLabel: UITextField!
    @IBOutlet weak var remoteHostImageView: UIImageView!
    @IBOutlet weak var remoteHostStatusField: UITextField!
    @IBOutlet weak var internetConnectionImageView: UIImageView!
    
    @IBOutlet weak var internetConnectionStatusField: UITextField!
    var reachability:WTReachability = WTReachability.reachabilityWithHostName("www.apple.com")
    var internetReachability:WTReachability = WTReachability.reachabilityWithHostName("https://www.apple.com")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaryLabel.isHidden = true
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: kWTReachabilityChangedNotification), object: nil, queue: nil) { [weak self](notification) in
            
            let reachability:WTReachability = notification.object as! WTReachability
            
            
//            WTPrint("reachability : \(reachability) self?.reachability:\(self?.reachability) self?.internetReachability \(self?.internetReachability)")
            
            self?.updateInterfaceWithReachability(reachability)
            
            
            
        }
        if internetReachability.startNotifier() {
            
        }else{
            WTLog("开启失败");
        }
        if reachability.startNotifier() {
            
        }else{
            WTLog("失败")
        }
        
        updateInterfaceWithReachability(reachability)
        updateInterfaceWithReachability(internetReachability)
//        let fps = FPSLabel()
//        fps.frame = CGRect(x: 0, y: 300, width: 320, height: 20)
//        view.addSubview(fps)
    }
    
    func updateInterfaceWithReachability(_ reachability:WTReachability){
        var dict:[WTNetworkStatus:String] = [WTNetworkStatus:String]()
        dict[WTNetworkStatus.notReachable] = "无网络"
        dict[WTNetworkStatus.reachableViaWiFi] = "已连接Wi-Fi"
        dict[WTNetworkStatus.reachableViaWWAN] = "通过蜂窝数据接入网络"
        var imageNames:[WTNetworkStatus:String] = [WTNetworkStatus:String]()
        imageNames[WTNetworkStatus.notReachable] = "stop-32"
        imageNames[WTNetworkStatus.reachableViaWiFi] = "Airport"
        imageNames[WTNetworkStatus.reachableViaWWAN] = "WWAN5"
        var status:WTNetworkStatus
        if reachability == self.reachability{
            status = reachability.currentReachabilityStatus()
            self.remoteHostStatusField.text = dict[status]
            
            self.remoteHostImageView.image = UIImage(named: imageNames[status]!)
            
            self.summaryLabel.isHidden = false
            if(status != .reachableViaWWAN){
                self.summaryLabel.isHidden = true
            }
            var baseLabelText = ""
            if (reachability.connectionRequired()){
                baseLabelText = "Cellular data network is available.\nInternet traffic will be routed through it after a connection is established."
            }else{
                baseLabelText = "Cellular data network is active.\nInternet traffic will be routed through it."
            }
            self.summaryLabel.text = baseLabelText
            
//
        }else if reachability == self.internetReachability{
            status = reachability.currentReachabilityStatus()
            self.internetConnectionStatusField.text = dict[status]
            self.internetConnectionImageView.image = UIImage(named: imageNames[status]!)
        }
    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kWTReachabilityChangedNotification), object: nil)
        WTLog("deinit")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
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
