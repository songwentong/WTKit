//
//  DetailViewController.swift
//  Example
//
//  Created by Wentong Song on 2022/5/1.
//

import UIKit
import WTKit

class DetailViewController: UIViewController {
    var request:URLRequest?
    var headers: [String: String] = [:]
    var body: String?
    var elapsedTime: TimeInterval?
    let con = UIRefreshControl()
    @IBOutlet weak var myTableView: UITableView!
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        myTableView.refreshControl = con
        loadData()
    }

}
extension DetailViewController{
    func loadData() {
        guard let request = request else {
            return
        }
        let t1 = Date().timeIntervalSince1970
//        self.view.showLoadingView()
        con.beginRefreshing()
        WT.dataTaskWith(request: request) { (str:String) in
            self.body = str
            dprint(str)
        } completionHandler: { data, u, _ in
            self.con.endRefreshing()
            if let res = u as? HTTPURLResponse{
                res.allHeaderFields.forEach { (key: AnyHashable, value: Any) in
                    self.headers["\(key)"] = "\(value)"
                }
            }
            self.elapsedTime = Date().timeIntervalSince1970 - t1
//            self.body = data?.utf8String
            self.myTableView.reloadData()
//            self.view.hideLoadingView()
        }
    }
}
extension DetailViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0{
            return ""
        }
        return ["Headers","Body"][section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return headers.count
        }
        return body == nil ? 0 : 1
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0{
            return ""
        }
        if section == 1,let elapsedTime = elapsedTime {
            let elapsedTimeText = Self.numberFormatter.string(from: elapsedTime as NSNumber) ?? "???"
            return "Elapsed Time: \(elapsedTimeText) sec"
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let l1 = cell.viewWithTag(1) as? UILabel, let l2 = cell.viewWithTag(2) as? UILabel{
                let field = headers.keys.sorted(by: <)[indexPath.row]
                let value = headers[field]
                l1.text = field
                l2.text = value
            }
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = body
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}
extension DetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 650
        }
        return myTableView.rowHeight
    }
}
extension DetailViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if con.isRefreshing{
            loadData()
        }
    }
}
extension DetailViewController{}
extension DetailViewController{}
extension DetailViewController{}
