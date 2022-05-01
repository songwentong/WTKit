//
//  MyTabBarController.swift
//  Example
//
//  Created by Wentong Song on 2022/5/1.
//

import UIKit
import WTKit
class MyTabBarController: VVTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setCustomAction(action: DispatchWorkItem.init(block: {
            print("custom action")
        }), with: 1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
