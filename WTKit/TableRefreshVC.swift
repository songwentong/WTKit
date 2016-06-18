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
        tableView.refreshHeader = RefreshHeader.headerWithRefreshing({  ()in
            self.dataList.insert("refresh one time", atIndex: 0)
            performOperationWithBlock({ [weak self]()in
                self?.tableView.finishRefresh()
                self?.tableView.beginUpdates()
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self?.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self?.tableView.endUpdates()
                }, afterDelay: 2.0)
            
        })
        dataList.append("pull down to refresh")
        // Do any additional setup after loading the view.
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
