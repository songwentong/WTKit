//
//  ViewController.swift
//  WTKit
//
//  Created by SongWentong on 3/3/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
/*
 Demo列表,点击title进入单个demo,底部的tip可以用来区分是否是首次登陆.
 */
import UIKit
import SystemConfiguration
import WTKit
/*!
 todo list
 1.做一个图片上传和下载的测试
 2.做一个下拉刷新的功能,提供自定的和默认的.
 3.完成hud
 4.版本记录 参考GBVersionTracking
 5.KeyChain 做一个好用的工具,参考UICkeyChain
 6.做一个动画绘图
 
 */
class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var dataList:[[String:String]] = [[String:String]]()
    var underDevelopmentList:[[String:String]] = [[String:String]]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configModel()
        print("model name:\(UIDevice.current.modelName)");
        
    }
    func configModel(){
        dataList.append(["title":"GET","segue":"requestDemo"])
        dataList.append(["title":"POST","segue":"requestDemo"])
        dataList.append(["title":"GET/POST request","segue":"get"])
        //        dataList.append(["title":"POST请求","segue":"post"])
        //        dataList.append(["title":"Image upload","segue":"uploadImage"])
        dataList.append(["title":"Image download","segue":"imageDownload"])
        dataList.append(["title":"Image batch download","segue":"imageListVC"]);
        dataList.append(["title":"Gif Demo","segue":"gif"])
        dataList.append(["title":"HUD Demo","segue":"hud"])
        dataList.append(["title":"COLOR create","segue":"color"])
        dataList.append(["title":"Pull To Refresh","segue":"TableRefreshVC"])
        //        dataList.append(["title":"二维码扫描","segue":"QRCodeScanVC"])
        dataList.append(["title":"JSONModel","segue":"modelDemo"])
//        dataList.append(["title":"ChartView Demo (under development)","segue":"chart"])
        //        dataList.append(["title":"Reachability","segue":"reachability"])
        
        underDevelopmentList.append(["title":"ChartView Demo (under development)","segue":"chart"])
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.tag = 100
//        self.view.setValue(100, forKey: "tag")
//        objc_setAssociatedObject(self.view, "tag", 100, .OBJC_ASSOCIATION_ASSIGN)
//        print("\(objc_getAssociatedObject(self.view, "tag"))")
        WTKit.WTPrint("");
        DispatchQueue.safeSyncInMain {
            
        }
        
        /*
         UIApplication.firstLaunchForBuild { [weak self](isFirstLaunchEver) in
         if isFirstLaunchEver{
         self?.showHudWithTip("热烈欢迎")
         }else{
         self?.showHudWithTip("欢迎回来")
         }
         }
         */
        //        print(self.view.recursiveDescription);
        
        
    }
    //    func aaa(a:String="ccc"){
    //        WTLog(a)
    //    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = tableView.indexPathForSelectedRow
        if(indexPath != nil){
            tableView.deselectRow(at: indexPath!, animated: true)
        }
        
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //        segue.destinationViewController
        
        if let indexPath:NSIndexPath = sender as? NSIndexPath {
            if let vc:RequestDemoVC = segue.destination as? RequestDemoVC {
                
            
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                vc.methodType = .get
                }
                if indexPath.row == 1 {
                    vc.methodType = .post
                }
            }
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - UITableViewDataSource
extension ViewController:UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return dataList.count
        case 1:
            return underDevelopmentList.count
        default:
            break
        }
        return 0
    }
    
    @objc(tableView:cellForRowAtIndexPath:) @available(iOS 2.0, *)
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return  cell!
    }
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        var list = [String]()
        list.append("Demo list")
        list.append("under develpment")
        return list[section]
    } // fixed font style. use custom view (UILabel) if you want something different
    
}
// MARK: - UITableViewDelegate
extension ViewController:UITableViewDelegate{
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = dataList[(indexPath as NSIndexPath).row]["title"]
        case 1:
            cell.textLabel?.text = underDevelopmentList[(indexPath as NSIndexPath).row]["title"]
        default:
            break
        }
        
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:) internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.section {
        case 0:
            let segue = dataList[(indexPath as NSIndexPath).row]["segue"]
            self.performSegue(withIdentifier: segue!, sender: indexPath);
        case 1:
            let segue = underDevelopmentList[(indexPath as NSIndexPath).row]["segue"]
            self.performSegue(withIdentifier: segue!, sender: nil);
        default:
            break
        }
        
    }
}
