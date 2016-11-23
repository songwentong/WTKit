//
//  ModelDemoViewController.swift
//  WTKit
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import UIKit

class ModelDemoViewController: UIViewController {
    
    var weatherModel:WeatherModel = WeatherModel()
    var segment:UISegmentedControl = UISegmentedControl(items: ["json","property","travel"])
    @IBOutlet weak var titleButton: UIButton!
    var jsonString:String = ""
    var jsonObject:AnyObject?
    var className:String? = "XXX"
    var alertControl:UIAlertController?
    @IBOutlet weak var jsonTextView: UITextView!
    @IBOutlet weak var propertyTextView: UITextView!
//    var alertController:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let data = try Data(contentsOf: Bundle.main.url(forResource: "JSONData", withExtension: nil)!)
            jsonString = String.init(data: data, encoding: .utf8)!
            jsonObject = JSONSerialization.WTJSONObject(with: data)! as AnyObject
            jsonTextView.text = jsonString
        }catch{
            
        }
        self.title = className
        
        
        weatherModel.wt(travel: jsonObject)
        
        //        let sel = #selector(ModelDemoViewController.segmentControlEvent(_:))
        //        self.segment.addTarget(self, action: sel, for: .valueChanged)
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

    func textFieldDidEdit(_ tf:UITextField)->Void{
        if let alertController = self.presentedViewController as? UIAlertController{
            if tf.text?.length == 0 {
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
    @IBAction func writeToDesktop(_ sender: Any) {
    if let obj = jsonObject as? NSObject {
        let filePath = desktopPath() + "/" + className! + ".swift"
        let modelString = obj.WTSwiftModelString(className);
        do {
            try modelString.write(toFile: filePath, atomically: true, encoding: .utf8)
        }catch{
        
        }
        }
    }

    deinit {
        print("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
