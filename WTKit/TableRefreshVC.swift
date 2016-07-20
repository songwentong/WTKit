//
//  TableRefreshVC.swift
//  WTKit
//
//  Created by SongWentong on 6/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
/*
    这是一个下拉刷新的demo
    只需要设置一下刷新头就可以了,然后在需要停止刷新的时候调用停止就可以了
 */
import UIKit

class TableRefreshVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    var dataList:Array<String> = []
    
    deinit{
        WTLog("deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...10{
        dataList.append("pull down to refresh")
        }
        
        tableView.refreshHeader = RefreshHeader.headerWithRefreshing({  [weak self]()in
            performOperation(with: {[weak self]()in
                if self != nil{
                    self?.dataList.insert("refresh one time", at: 0)
                    self?.tableView.stopLoading()
                    self?.tableView.beginUpdates()
                    let indexPath = IndexPath(row: 0, section: 0)
                    WTPrint(self?.dataList)
                    self?.tableView.insertRows(at: [indexPath], with: .none)
                    self?.tableView.endUpdates()
                }
                }, afterDelay: 2.0)
            
        })
        tableView.refreshHeader?.setTitle("加载中...", forState: .loading)
        tableView.refreshHeader?.setTitle("下拉刷新", forState: .pullDownToRefresh)
        tableView.refreshHeader?.setTitle("松开刷新", forState: .releaseToRefresh)
//        tableView.refreshHeader?.dateStyle = ""
        tableView.refreshHeader?.lastUpdateText = "上次刷新时间"
//        tableView.refreshHeader?.dateStyle = ""
 
//        tableView.refreshHeader?.arrowImageURL = "http://ww4.sinaimg.cn/mw690/47449485jw1f4wq45lqu6j201i02gq2p.jpg"
        // Do any additional setup after loading the view.
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
    //----------datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.startRefresh()
    }
    
    
    //----------delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.textLabel!.text = dataList[(indexPath as NSIndexPath).row]
    }

}
