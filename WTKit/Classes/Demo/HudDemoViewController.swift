//
//  HudDemoViewController.swift
//  WTKit
//
//  Created by SongWentong on 5/9/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class HudDemoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var dataList:[String]
    @IBOutlet weak var tableView: UITableView!
    var timer:Timer?
    var progress:CGFloat = 0
    required init?(coder aDecoder: NSCoder){
        dataList = ["NormalLoadingView","text","progressLoadingView","pieProgressView"]
        super.init(coder: aDecoder)
    }
    
    deinit{
        WTLog("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.refreshHeader = RefreshHeader.headerWithRefreshing({[weak self]()in
//            WTLog("refresh")
//            self?.performBlock({
//                self?.tableView.stopLoading()
//                }, afterDelay: 2)
//        })
//        self.modalTransitionStyle
//        tableView.separatorInset = UIEdgeInsetsMake(100, 0, 0, 0);
//        tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    }

    func addProgress(){
        progress += CGFloat(arc4random()%100)/200
        let hud = WTHudView.hudViewForView(view)
        if (hud != nil) {
          let view = hud!.indicatorView as! WTPieProgressView
          view.progress = progress
        }
        if progress>=1 {
            progress = 0
            timer?.invalidate()
            timer = nil
            hud?.hideAnimated(true)
        }
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
    // MARK: - UITableViewDataSource
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    /*!
        这里只创建cell对象
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    // MARK: - UITableViewDelegate
    
    /*!
        在这里设置数据是为了保持良好的效率
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.textLabel?.text = dataList[(indexPath as NSIndexPath).row];
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch (indexPath as NSIndexPath).row {
        case 0:
            self.showLoadingView()
            self.performBlock({
                self.hideLoadingView()
                }, afterDelay: 2)
            break
        case 1:
            self.showHudWithTip("这是一段长文字长文字长文章长文章长文字长文字长文字长文字长文章长文章长文章长文章长文章长文字长文章长文字")
            break
        case 2:
            let hud = WTHudView.showHudInView(view, animatied: true)
            hud.mode = .roundProgressIndicatorView
            hud.titleText = "加载中..."
            self.performBlock({ 
                hud.hideAnimated(true)
                }, afterDelay: 10)
            
            break
        case 3:
            if (timer != nil) {
                return
            }
            let hud = WTHudView.showHudInView(view, animatied: true)
            hud.mode = .pieProgress
            timer = Timer(timeInterval: 1, target: self, selector: #selector(HudDemoViewController.addProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
            
            
            
//            RunLoop.main().add(timer!, forMode: )
            break
        default:
            break
            
        }
    }
    
    


}
