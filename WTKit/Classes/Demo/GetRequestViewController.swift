//
//  GetRequestViewController.swift
//  WTKit
//
//  Created by SongWentong on 4/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit
import Foundation
class GetRequestViewController: UIViewController,POSTParamatersVCDelegate {
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var methodSegment: UISegmentedControl!
    @IBOutlet weak var rightItem: UIBarButtonItem!
    var parameters:[String:String]?
    
    
    let lastURLKey = "lastURLKey"
    
    override func viewDidLoad() {
        //        requestButton.enabled = false
        
        var url = UserDefaults.standard.string(forKey: lastURLKey)
        if url == nil {
            url = "http://www.baidu.com"
        }
        urlTextField.text = url
        
        checkTextLength()
        super.viewDidLoad()
        
        //        self.navigationItem.hidesBackButton = true
    }
    deinit{
        WTLog("deinit")
    }
    @IBAction func EditChanged(_ sender: AnyObject) {
        
        checkTextLength()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        WTPrint(self.navigationItem.leftBarButtonItem)
    }
    
    //根据当时文本框的内容来控制按钮是否可用
    func checkTextLength(){
        let string = urlTextField.text
        let count = string?.characters.count
        //如果长度不对就不让按按钮
        if (string == nil || count==0) {
            requestButton.isEnabled = false;
        }else{
            requestButton.isEnabled = true;
        }
    }
    @IBAction func methodChanged(_ sender: AnyObject) {
        //        var enabled = true
        //        if methodSegment.selectedSegmentIndex==0 {
        //            enabled = false
        //        }
        //        rightItem.enabled = enabled
    }
    @IBAction func rightItemPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "parameters", sender: nil)
    }
    
    @IBAction func requestButtonPressed(_ sender: AnyObject) {
        let string = urlTextField.text
        if string != nil {
            //            let request = NSMutableURLRequest.request(string!)
            //            let queue = NSURLSession.sharedSession().delegateQueue
            //            WTPrint(queue)
            
            self.showLoadingView()
            requestButton.isEnabled = false
            var method = "GET"
            if methodSegment.selectedSegmentIndex == 1 {
                method = "POST"
            }
            
            UserDefaults.standard.set(urlTextField.text, forKey: lastURLKey)
            let request = URLRequest.request(string!, method: method, parameters: parameters, headers: nil)
            //            let credential = URLCredential(user: "user", password: "password", persistence: URLCredential.Persistence.permanent)
            let task = URLSession.wtDataTask(with: request, completionHandler: { (data, response, error) in
                
                self.hideLoadingView()
                self.requestButton.isEnabled = true
                
                if error == nil{
                    
                    
                    let string = data?.toUTF8String()
                    
                    
                    self.resultTextView.text = string
                    self.resultTextView.flashScrollIndicators()
                    
                    
                    
                    if (string?.length == 0){
                        self.showHudWithTip("请求成功,数据不是UTF8格式")
                    }else{
                        self.showHudWithTip("请求成功")
                    }
                    
                }else{
                    self.showHudWithTip("请求失败")
                }
                
                
            })
            task.resume()
            /*
             let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
             
             })
             task.resume()
             */
        }else{
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let paraVC = segue.destinationViewController as? POSTParamatersVC {
            paraVC.delegate = self
            if parameters != nil {
                for (key,value) in parameters!{
                    paraVC.parameters.append(key)
                    paraVC.values.append(value)
                }
            }
            
        }
    }
    
    func willDisAppear(_ vc:POSTParamatersVC, parameters:[String:String]?=[:]){
        self.parameters = parameters
    }
    
    
}
