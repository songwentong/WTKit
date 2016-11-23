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
    var jsonString:String = ""
    var jsonObject:AnyObject?
    
    @IBOutlet weak var jsonTextView: UITextView!
    @IBOutlet weak var propertyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let data = try Data(contentsOf: Bundle.main.url(forResource: "JSONData", withExtension: nil)!)
            jsonString = String.init(data: data, encoding: .utf8)!
            jsonObject = JSONSerialization.WTJSONObject(with: data)! as AnyObject
            jsonTextView.text = jsonString
        }catch{
        
        }
        

        
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
    
    @IBAction func printProperty(_ sender: Any) {
        if let obj = jsonObject as? NSObject {
            obj.printModel()
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
