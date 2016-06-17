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
        
        var url = NSUserDefaults.standardUserDefaults().stringForKey(lastURLKey)
        if url == nil {
            url = "http://www.baidu.com"
        }
        urlTextField.text = url
        
        checkTextLength()
        super.viewDidLoad()
        
//        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func EditChanged(sender: AnyObject) {
        
        checkTextLength()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        WTPrint(self.navigationItem.leftBarButtonItem)
    }
    
    //根据当时文本框的内容来控制按钮是否可用
    func checkTextLength(){
        let string = urlTextField.text
        let count = string?.characters.count
        //如果长度不对就不让按按钮
        if (string == nil || count==0) {
            requestButton.enabled = false;
        }else{
            requestButton.enabled = true;
        }
    }
    @IBAction func methodChanged(sender: AnyObject) {
//        var enabled = true
//        if methodSegment.selectedSegmentIndex==0 {
//            enabled = false
//        }
//        rightItem.enabled = enabled
    }
    @IBAction func rightItemPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("parameters", sender: nil)
    }
    
    @IBAction func requestButtonPressed(sender: AnyObject) {
        let string = urlTextField.text
        if string != nil {
//            let request = NSMutableURLRequest.request(string!)
//            let queue = NSURLSession.sharedSession().delegateQueue
//            WTPrint(queue)
            
            self.showLoadingView()
            requestButton.enabled = false
            var method = "GET"
            if methodSegment.selectedSegmentIndex == 1 {
                method = "POST"
            }
            NSUserDefaults.standardUserDefaults().setObject(urlTextField.text, forKey: lastURLKey)
            NSURLSession.dataTaskWith(string!,method:method,parameters:parameters, completionHandler: { (data, response, error) in
                self.hideLoadingView()
                self.requestButton.enabled = true
                
                if error == nil{
                    

                    let string = data?.toUTF8String()
                        
                    
                    self.resultTextView.text = string;
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

        }else{
            
        }
        
        
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
    
    func willDisAppear(vc:POSTParamatersVC, parameters:[String:String]?=[:]){
        self.parameters = parameters
    }
    
    
}
