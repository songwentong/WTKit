//
//  POSTParamatersVC.swift
//  WTKit
//
//  Created by SongWentong on 4/29/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

/*!
    解决delegate 必须使用weak的办法
 方法一:协议前加上@objc
 方法二:继承:class
 方法三:继承NSObjectProtocol
 这样的目的在于只允许class遵循,不允许struce或者enum遵循
 */
protocol POSTParamatersVCDelegate:NSObjectProtocol{
    func willDisAppear(_ vc:POSTParamatersVC, parameters:[String:String]?)
}
class POSTParamatersVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    var parameters:[String] = []
    var values:[String] = []
    weak var delegate:POSTParamatersVCDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        parameters = [String]()
        values = [String]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        if parameters.count == 0 {
            addNewParameters()
        }
        
        WTLog(parameters)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.willDisAppear(self, parameters: currentParameters())
        super.viewWillDisappear(animated)
    }
    
    @IBAction func addPressed(_ sender: AnyObject) {
        addNewParameters()
    }
    
    //当前的参数
    func currentParameters()->[String:String]{
        var dict = [String:String]()
        
        for i in 0..<parameters.count{
            dict.updateValue(values[i], forKey: parameters[i])
            
            
        }
        return dict
    }
    @IBAction func showPressed(_ sender: AnyObject) {
        do{
            let data = try JSONSerialization.data(withJSONObject: self.currentParameters(), options: JSONSerialization.WritingOptions())
            let string = String.init(data: data, encoding: String.Encoding.utf8)
//            self.showAlert("parameters", message: string, duration: 1)
            let alert = UIAlertController(title: "parameters", message: string, preferredStyle: .alert)
            
                self.present(alert, animated: true) {
        
                }
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }catch let error as NSError{
            WTPrint(error)
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func addNewParameters(){
        parameters.append("")
        values.append("")
        let indexPath = IndexPath(row: parameters.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func add(_ sender:UIButton?){
        addNewParameters()
    }
    
    func remove(_ sender:UIButton){
        let cell:UITableViewCell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        if (parameters.count != 1 && indexPath != nil ){
            parameters.remove(at: (indexPath! as NSIndexPath).row)
            values.remove(at: (indexPath! as NSIndexPath).row)
            
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.endUpdates()
        }

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return parameters.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let keyTextField:UITextField = cell.viewWithTag(1) as! UITextField
        keyTextField.addtarget({ (sender) in
            let tf:UITextField = sender as! UITextField
            let cell2:UITableViewCell = sender.superview?.superview as!UITableViewCell
            let indexPath2 = self.tableView.indexPath(for: cell2)
            if ( indexPath2 != nil && tf.text != nil ) {
                if (self.parameters.count > (indexPath2 as NSIndexPath?)?.row){
                    self.parameters[(indexPath2! as NSIndexPath).row] = tf.text!
                }else{
                    self.parameters.append(tf.text!)
                }
            }
                WTLog(self.currentParameters())
            }, forControlEvents:.editingChanged)
        keyTextField.delegate = self
        let valueTf:UITextField = cell.viewWithTag(2) as! UITextField
        valueTf.addtarget({ (sender) in
            let tf:UITextField = sender as! UITextField
            let cell2:UITableViewCell = sender.superview?.superview as!UITableViewCell
            let indexPath2 = self.tableView.indexPath(for: cell2)
            if(indexPath2 != nil && tf.text != nil){
                self.values[(indexPath2! as NSIndexPath).row] = tf.text!
            }
            WTLog(self.currentParameters())
            }, forControlEvents: .editingChanged)
        valueTf.delegate = self
        
        let buttonAdd:UIButton = cell.contentView.viewWithTag(3) as! UIButton
        buttonAdd.addTarget(self, action: #selector(POSTParamatersVC.add(_:)), for: .touchUpInside)
        
        let removeButton:UIButton  = cell.contentView.viewWithTag(4) as! UIButton
        removeButton.addTarget(self, action: #selector(POSTParamatersVC.remove(_:)), for: .touchUpInside)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if (indexPath as NSIndexPath).row >= parameters.count {
            return;
        }
        let keyTextField:UITextField = cell.viewWithTag(1) as! UITextField
        let key = parameters[(indexPath as NSIndexPath).row]
        keyTextField.text = key
        let valueTextField:UITextField = cell.viewWithTag(2) as! UITextField
        valueTextField.text = values[(indexPath as NSIndexPath).row]
        
    }
}
