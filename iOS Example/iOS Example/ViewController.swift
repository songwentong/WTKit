//
//  ViewController.swift
//  WTKit
//
//  Created by SongWentong on 3/3/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
/*
 Demo列表,点击title进入单个demo,底部的tip可以用来区分是否是首次登陆.
 */
import UIKit
import SystemConfiguration
/*!
 todo list
 1.做一个图片上传和下载的测试
 2.做一个下拉刷新的功能,提供自定的和默认的.
 3.完成hud
 4.版本记录 参考GBVersionTracking
 5.KeyChain 做一个好用的工具,参考UICkeyChain
 6.做一个动画绘图
 
 */
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dataList:Array<[String:String]>
    
    
    
    required init?(coder aDecoder: NSCoder) {
        dataList = Array()
        dataList.append(["title":"GET/POST请求","segue":"get"])
        //        dataList.append(["title":"POST请求","segue":"post"])
        dataList.append(["title":"图片上传","segue":"uploadImage"])
        dataList.append(["title":"图片下载","segue":"imageDownload"])
        dataList.append(["title":"Gif 图","segue":"gif"])
        dataList.append(["title":"HUD","segue":"hud"])
        dataList.append(["title":"COLOR 创建","segue":"color"])
        dataList.append(["title":"下拉刷新","segue":"TableRefreshVC"])
        dataList.append(["title":"二维码扫描","segue":"QRCodeScanVC"])
        dataList.append(["title":"JSONModel","segue":"modelDemo"])
        //        dataList.append(["title":"Reachability","segue":"reachability"])
        super.init(coder: aDecoder)
    }
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.tag = 100
        self.view.setValue(100, forKey: "tag")
//        objc_setAssociatedObject(self.view, "tag", 100, .OBJC_ASSOCIATION_ASSIGN)
//        print("\(objc_getAssociatedObject(self.view, "tag"))")
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - UITableViewDataSource
extension ViewController{
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) @available(iOS 2.0, *)
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return  cell!
    }
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "Demo 列表"
    } // fixed font style. use custom view (UILabel) if you want something different
    
}
// MARK: - UITableViewDelegate
extension ViewController{
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.textLabel?.text = dataList[(indexPath as NSIndexPath).row]["title"]
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:) internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let segue = dataList[(indexPath as NSIndexPath).row]["segue"]
        self.performSegue(withIdentifier: segue!, sender: nil);
    }
}
