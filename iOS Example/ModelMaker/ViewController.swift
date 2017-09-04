//
//  ViewController.swift
//  ModelMaker
//
//  Created by SongWentong on 24/08/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Cocoa
import WTKitMacOS
class ViewController: NSViewController {

    @IBOutlet weak var modelTextField: NSTextField!
    @IBOutlet weak var statusTextField: NSTextField!
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var statusLightView: NSView!
    
    var isJSON = false
    var jsonError:NSError? = nil;
    //var is
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        var home = NSHomeDirectory()
        home = home + "/Desktop"
        pathTextField.cell?.stringValue = home
        print("\(home)")
        modelTextField.cell?.stringValue = "WTModel"
        
        
        if let url:URL = Bundle.main.url(forResource: "JSONData", withExtension: nil) {
            do{
                let data = try Data.init(contentsOf: url)
                let string = String.init(data: data, encoding: .utf8)!
                //jsonObject = JSONSerialization.WTJSONObject(with: data)! as AnyObject
                //jsonTextView.text = jsonString
                textView.string = string
            }catch let error as NSError{
                print("\(error)")
            }
        }
        textView.delegate = self;
        checkJSONText()
    }

    //生成
    @IBAction func createButton(_ sender: Any) {
        do {
            let parseJsonResult = try JSONSerialization.jsonObject(with: (textView.string?.data(using: .utf8)!)!, options: [])
            //            print("JSON 合法")
            if let obj = parseJsonResult as? NSObject {
                if let cell1 = pathTextField.cell {
                    if let cell2 = modelTextField.cell{
                        let path = cell1.stringValue
                        let className = cell2.stringValue
                        
                        let filePath = path + "/" + className + ".swift"
                        let modelString = obj.WTSwiftModelString(className);
                        do {
                            try modelString.write(toFile: filePath, atomically: true, encoding: .utf8)
                            print("写文件成功,请在桌面查看")
                        }catch{
                            print("写文件失败")
                        }

                    }
                }
                            }else{
                print("不是NSObject")
            }
        }catch{
            print("JSON 不合法")
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
extension ViewController:NSTextViewDelegate{
    
    public func textDidChange(_ notification: Notification){
        print("notification:\(notification)")
        jsonError = nil
        if let a:NSTextView = notification.object as? NSTextView {
            if a == textView {
                checkJSONText()
            }
        }
        
    }
    public func checkJSONText(){
        if let string = textView.string {
            if let data = string.data(using: .utf8){
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    isJSON = true
                    print("json:\(json)")
                } catch let error as NSError {
                    isJSON = false
                    jsonError = error
                    print(error)
                }
            }
        }
        updateLight()
    }
    public func updateLight(){
        if isJSON {
            statusLightView.layer?.backgroundColor = NSColor.green.cgColor
            statusTextField.cell?.stringValue = "合法的JSON"
        }else{
            statusLightView.layer?.backgroundColor = NSColor.red.cgColor
            if let userInfo = jsonError?.userInfo {
                statusTextField.cell?.stringValue = "error:\(userInfo))"
            }
            
        }
        statusLightView.layer?.cornerRadius = 8
    }
}
