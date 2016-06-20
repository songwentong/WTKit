//
//  TableRefreshVC.swift
//  WTKit
//
//  Created by SongWentong on 6/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class TableRefreshVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    var dataList:Array<String> = []
    
    deinit{
        WTLog("deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList.append("pull down to refresh")
        tableView.refreshHeader = RefreshHeader.headerWithRefreshing({  [weak self]()in
            
            performOperationWithBlock({ [weak self]()in
                if self != nil{
                    self?.dataList.insert("refresh one time", atIndex: 0)
                    self?.tableView.stopLoading()
                    self?.tableView.beginUpdates()
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    WTPrint(self?.dataList)
                    self?.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    self?.tableView.endUpdates()
                }
                
                }, afterDelay: 2.0)
            
        })
        tableView.refreshHeader?.setTitle("加载中...", forState: .Loading)
        tableView.refreshHeader?.setTitle("下拉刷新", forState: .PullDownToRefresh)
        tableView.refreshHeader?.setTitle("松开刷新", forState: .ReleaseToRefresh)
//        tableView.refreshHeader?.dateStyle = ""
        tableView.refreshHeader?.lastUpdateText = "上次刷新时间"
//        tableView.refreshHeader?.dateStyle = ""
 
//        tableView.refreshHeader?.arrowImageURL = "http://ww4.sinaimg.cn/mw690/47449485jw1f4wq45lqu6j201i02gq2p.jpg"
        // Do any additional setup after loading the view.
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
    //----------datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.startRefresh()
    }
    
    
    //----------delegate
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.textLabel!.text = dataList[indexPath.row]
    }

}
