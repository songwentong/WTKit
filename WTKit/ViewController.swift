//
//  ViewController.swift
//  WTKit
//
//  Created by SongWentong on 3/3/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit
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
        super.init(coder: aDecoder)
    }
// MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        WTLog(self.view.viewController())
//        aaa(UILabel().text!)
    }
//    func aaa(a:String="ccc"){
//        WTLog(a)
//    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = tableView.indexPathForSelectedRow
        if(indexPath != nil){
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    
    @available(iOS 2.0, *)
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        return  cell!
    }
    internal func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "Demo 列表"
    } // fixed font style. use custom view (UILabel) if you want something different

}
// MARK: - UITableViewDelegate
extension ViewController{

    internal func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.textLabel?.text = dataList[indexPath.row]["title"]
    }
    
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let segue = dataList[indexPath.row]["segue"]
        self.performSegueWithIdentifier(segue!, sender: nil);
    }
}
