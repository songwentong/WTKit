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
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func requewWithType()->Void{
        
        switch methodType {
        case .get:
        url = baseURL + "get"
            break
        case .post:
            url = baseURL + "post"
        default: break
            
        }
        let task:WTURLSessionDataTask = WTKit.dataTask(with: url, method: methodType)
        task.completionHandler = { [weak self](data, response, error) in
            if let httpRes:HTTPURLResponse = response as? HTTPURLResponse {
                for (field,value)in httpRes.allHeaderFields{
                    self?.headers["\(field)"] = "\(value)"
                }
            }
            self?.data = data
            self?.tableView.reloadData()
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
        return 0
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
