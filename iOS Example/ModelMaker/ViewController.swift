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

    @IBOutlet weak var modelTextField: NSTextField!//类名
    @IBOutlet weak var statusTextField: NSTextField!
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var statusLightView: NSView!
    @IBOutlet var effect: NSTextView!
    var modelStructName: String = "ModelName"
    
    var isJSON = false
    var jsonError:NSError? = nil;
    //var is
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setDefaultString()
        checkJSONText()
        testCodableRead()
    }
    //这是一个model创建的工具，运行看效果吧,不错吧，😜
    func testCodableRead(){
        
        if let url:URL = Bundle.main.url(forResource: "JSONData", withExtension: nil) {
            do{
                let data = try Data.init(contentsOf: url)
                let instance = try JSONDecoder().decode(ModelName.self, from: data)
                print("\(instance)")
            }catch let error as NSError{
                print("\(error)")
            }
        }
        
    }
    
    func setDefaultString(){
        var home = NSHomeDirectory()
        home = home + "/Desktop"
        pathTextField.cell?.stringValue = home
        print("\(home)")
        modelTextField.cell?.stringValue = modelStructName
        modelTextField.delegate = self
        
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
    }

    //生成
    @IBAction func createButton(_ sender: Any) {
            if let cell1 = pathTextField.cell {
                    if let cell2 = modelTextField.cell{
                        let path = cell1.stringValue
                        let className = cell2.stringValue
                        
                        let filePath = path + "/" + className + ".swift"
                        let modelString = WTSwiftModelString(with: className, jsonString: textView.string,usingHeader: true)
                        do {
                            try modelString.write(toFile: filePath, atomically: true, encoding: .utf8)
                            print("写文件成功,请在桌面查看")
                        }catch{
                            print("写文件失败")
                        }

                    }
                }
 
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
//Notification
extension ViewController{
}
extension ViewController:NSTextFieldDelegate{
    open override func controlTextDidChange(_ obj: Notification){
        if let cell = modelTextField.cell{
            modelStructName = cell.stringValue
            checkJSONText()
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
        
            if let data = textView.string.data(using: .utf8){
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    isJSON = true
                    let modelString = WTSwiftModelString(with: modelStructName, jsonString: textView.string)
                    effect.string = modelString
                    print("json:\(json)")
                } catch let error as NSError {
                    isJSON = false
                    jsonError = error
                    print("json parse error:\(error)")
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
