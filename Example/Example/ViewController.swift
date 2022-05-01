//
//  ViewController.swift
//  Example
//
//  Created by Wentong Song on 2022/5/1.
//

import UIKit
import WTKit
class ViewController: UIViewController {
    var section1 = ["GET Request","POST Request","PUT Request","DELETE Request"]

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "WTKit"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let ind = myTableView.indexPathForSelectedRow{
            myTableView.deselectRow(at: ind, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let indexpath:IndexPath = sender as? IndexPath{
            if indexpath.section == 0{
                if let vc = segue.destination as? DetailViewController{
                    dprint(sender)
                    func requestForIndexPath( indexPath:IndexPath) -> URLRequest{
                        switch indexpath.row{
                        case 0:
                            return WT.createURLRequest(with: "https://httpbin.org/get", method: .get)
                        case 1:
                            return WT.createURLRequest(with: "https://httpbin.org/post", method: .post)
                        case 2:
                            return WT.createURLRequest(with: "https://httpbin.org/put", method: .put)
                        case 3:
                            return WT.createURLRequest(with: "https://httpbin.org/delete", method: .delete)
                        default:
                            return WT.createURLRequest(with: "https://httpbin.org/get", method: .get)
                        }
                    }
                    vc.request = requestForIndexPath(indexPath: indexpath)
                    vc.title = vc.request?.url?.absoluteString
                }
            }
        }
        
    }


}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let label = cell.viewWithTag(999) as? UILabel{
            label.text = section1[indexPath.row]
        }
        return cell
    }
}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
}

extension ViewController{}
extension ViewController{}
extension ViewController{}
extension ViewController{}
extension ViewController{}
extension ViewController{}
extension ViewController{}
