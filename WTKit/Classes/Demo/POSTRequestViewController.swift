//
//  POSTRequestViewController.swift
//  WTKit
//
//  Created by SongWentong on 4/29/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class POSTRequestViewController: UIViewController,UITextFieldDelegate {

    
    var parametersVC:POSTParamatersVC?
    @IBOutlet weak var parameterButton: UIBarButtonItem!
    var parameters:[String:AnyObject]?
    
    deinit{
        WTLog("deinit")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parameters = nil
//        parametersVC = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
            WTLog("\(parametersVC?.currentParameters())")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击传参
    @IBAction func parameters(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "parameters", sender: nil);
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        segue.destinationViewController
        let destinationViewController = segue.destinationViewController
        if (destinationViewController is POSTParamatersVC) {
            parametersVC = destinationViewController as? POSTParamatersVC
        }
    }
    
    
    

}
