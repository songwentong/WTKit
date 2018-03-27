//
//  ModelDemoViewController.swift
//  WTKit
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import UIKit
import Social
class ModelDemoViewController: UIViewController,UITextViewDelegate {
    
    var segment:UISegmentedControl = UISegmentedControl(items: ["json","property","travel"])
    @IBOutlet weak var titleButton: UIButton!
    var jsonString:String = ""
    var jsonObject:Any?
    var className:String? = "ClassName"
    var alertControl:UIAlertController?
    @IBOutlet weak var jsonTextView: UITextView!
    @IBOutlet weak var propertyTextView: UITextView!
//    var alertController:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url:URL = Bundle.main.url(forResource: "JSONData", withExtension: nil) {
            do{
                let data = try Data.init(contentsOf: url)
                jsonString = String.init(data: data, encoding: .utf8)!
                jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                jsonTextView.text = jsonString

            }catch let error as NSError{
                print("\(error)")
            }
        }
        
        self.title = className
        
        
        //        let sel = #selector(ModelDemoViewController.segmentControlEvent(_:))
        //        self.segment.addTarget(self, action: sel, for: .valueChanged)
    }
    @IBAction func sharePressed(_ sender: Any) {
        /*
        let ss = SLComposeViewController.init(forServiceType: SLServiceTypeSinaWeibo)
        ss?.setInitialText("asdasdsada")
        present(ss?, animated: true) {
            
        }
         */
//        let ac =  UIActivityViewController.init(activityItems: ["qweasd"], applicationActivities: nil)
//        present(ac, animated: true) {
        
//        }
    }
    public func segmentControlEvent(_ sender:UISegmentedControl){
        
        switch (segment.selectedSegmentIndex){
        case 0:
            self.jsonTextView.isHidden = false
            propertyTextView.isHidden = true
            break
        case 1:
            jsonTextView.isHidden = true
            propertyTextView.isHidden = false
            break
        default:
            break
        }
        print("\(self)")
        
    }
    
    @IBAction func changeClassName(_ sender: Any) {
        let alertController = UIAlertController(title: "hello", message: "请修改类名", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] (action) in
            self?.className = alertController.textFields?[0].text
            self?.title = self?.className
        }))
        alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) in

        }))
        
        alertController.addTextField { [weak self](textfield) in
            textfield.text = self?.className
            textfield.placeholder = "请输入类名"
            textfield.addTarget(self, action: #selector(ModelDemoViewController.textFieldDidEdit(_:)), for: .editingChanged)
        }

        present(alertController, animated: true, completion: (() -> Void)?{
                
        })
        
        
    }

    @objc func textFieldDidEdit(_ tf:UITextField)->Void{
        if let alertController = self.presentedViewController as? UIAlertController{
            if tf.text?.count == 0 {
                alertController.actions[0].isEnabled = false
            }else{
                alertController.actions[0].isEnabled = true
            }
        }
    }
    
    
    @IBAction func titlePressed(_ sender: Any) {
        
    }
    
    func desktopPath()->String{
        let fileManager = FileManager()
        do{
            let contentsOfDirectory:[String] = try fileManager.contentsOfDirectory(atPath: "/Users")
            let homePath = NSHomeDirectory()
            for item in contentsOfDirectory{
                //                print("\(item)")
                //                print("\(homePath)")
                if homePath.contains(item) {
                    let desktopPath = "/Users/\(item)/Desktop"
                    return desktopPath
                }
            }
        }catch{
            
        }
        
        return ""
    }
    //写到桌面
    @IBAction func writeToDisk(_ sender: Any) {


  
    }
    

    deinit {
        print("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
