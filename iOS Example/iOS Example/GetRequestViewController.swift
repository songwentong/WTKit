//
//  GetRequestViewController.swift
//  WTKit
//
//  Created by SongWentong on 4/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
/*
    这是一个基本的请求例子,可以执行GET和POST请求,提供参数可填写(在新页面)
    在填写完URL之后点击请求即可开始请求
    请求完成后如果是utf-8的字符串的话可以返回显示出来,不是的话就只能提示数据无法解析
    请求完成/失败会在底部使用tip提示
 
 */
import UIKit
import Foundation
import WTKit
class GetRequestViewController: UIViewController,POSTParamatersVCDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var methodSegment: UISegmentedControl!
    @IBOutlet weak var rightItem: UIBarButtonItem!
    var parameters:[String:String]?
    
    
    let lastURLKey = "lastURLKey"
    
    override func viewDidLoad() {
        //        requestButton.enabled = false
        
        if let url:String = UserDefaults.standard.string(forKey: lastURLKey){
            urlTextField.text = url
        }
        
        
        
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
            //            WTPrint(queue)
            
//            self.showLoadingView()
            
            
            DispatchQueue.global().async {
                self.requestButton.isEnabled = false
                var method:HTTPMethod = .get
                if self.methodSegment.selectedSegmentIndex == 1 {
                    method = .post
                }
                //            string = "https://httpbin.org"
                UserDefaults.standard.set(string, forKey: self.lastURLKey)
//                let request = URLRequest.wt_request(with: string!, method: method, parameters: self.parameters)
                let task = WTKit.dataTask(with: string!, method: method, parameters: nil, headers: nil)
                task.stringHandler = {(string,error)in
                    WTLog("\(string)")
                }
                task.jsonHandler = {(json,error)in
                    WTLog("\(json)")
                }
                task.completionHandler = { [weak self](data, response, error) in
                    
//                    self?.hideLoadingView()
                    self?.requestButton.isEnabled = true
                    
                    if error == nil{
                        
                        self?.webView.loadHTMLString((data?.toUTF8String())!, baseURL: nil);
                        let string = data?.toUTF8String()
                        self?.webView.isHidden = true
                        //                    self.resultTextView.isHidden = true
                        
                        self?.resultTextView.text = string
                        self?.resultTextView.flashScrollIndicators()
                        
                        
                        
                        if (string?.length == 0){
                            self?.showHudWithTip("请求成功,数据不是UTF8格式")
                        }else{
                            self?.showHudWithTip("请求成功")
                        }
                        
                    }else{
                        self?.showHudWithTip("请求失败")
                    }
                    
                    
                }


            }
            
        }else{
            
        }
        
        
    }
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let paraVC = segue.destination as? POSTParamatersVC {
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
