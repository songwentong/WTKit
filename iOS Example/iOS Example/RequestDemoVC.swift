//
//  GETRequestVC.swift
//  iOS Example
//
//  Created by SongWentong on 18/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
import UIKit
import WTKit
class RequestDemoVC:UIViewController{
    var methodType:WTKit.HTTPMethod = .get
    let baseURL:String = "https://httpbin.org/"
    var url:String = ""
    var headers:[String : String] = [String : String]()
    var data:Data?
    var useTime:TimeInterval = 0
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requewWithType()
    }
    func requewWithType()->Void{
        var title = ""
        switch methodType {
        case .get:
            url = baseURL + "get"
            title = "GET " + url
            break
        case .post:
            url = baseURL + "post"
            title = "POST " + url
            break
        case .delete:
            url = baseURL + "delete"
            break
        case .put:
            url = baseURL + "put"
            break
        default: break
            
        }
        
        self.title = title
        let task:WTURLSessionDataTask = WTKit.dataTask(with: url, method: methodType)
        self.tableView.isHidden = true
        self.showLoadingView()
        let start:TimeInterval = Date.init().timeIntervalSince1970
        task.completionHandler = { [weak self](data, response, error) in
            if let httpRes:HTTPURLResponse = response as? HTTPURLResponse {
                for (field,value)in httpRes.allHeaderFields{
                    self?.headers["\(field)"] = "\(value)"
                }
            }
            self?.hideLoadingView()
            self?.data = data
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
            self?.useTime = Date.init().timeIntervalSince1970 - start
        }
    }
}
extension RequestDemoVC:UITableViewDataSource{
    @available(iOS 2.0, *)
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 2;
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return headers.count
        }
        return 1
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell:UITableViewCell
        let reuseIds:[String] = ["cell","body"];
        cell = tableView.dequeueReusableCell(withIdentifier: reuseIds[indexPath.section], for: indexPath);
        switch indexPath.section {
        case 0:
            let field = headers.keys.sorted(by: <)[indexPath.row]
            cell.textLabel?.text = field
            cell.detailTextLabel?.text = headers[field]
            break
        case 1:
            if let a:UILabel = cell.contentView.viewWithTag(1) as? UILabel {
                if let data = self.data {
                    a.text = String.init(data: data, encoding: .utf8)
                }
            }
            break
        default:
            break
        }
        return cell
    }
}
extension RequestDemoVC:UITableViewDelegate{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
        case 1:
            return 450
        default:
            return 44
        }
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? // fixed font style. use custom view (UILabel) if you want something different
    {
        switch section {
        case 0:
            return "Headers"
        default:
            return "body"
        }
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
        if section == 1 {
            return "Elapsed Time: \(self.useTime) sec"
        }
        return ""
    }
}
