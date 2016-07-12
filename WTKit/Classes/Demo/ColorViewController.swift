//
//  ColorViewController.swift
//  WTKit
//
//  Created by SongWentong on 5/20/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var mySlider: UISlider!
    deinit{
        WTLog("deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        reSetColors()
    }
    private func reSetColors(){
        if textView.text != nil{
            colorView.backgroundColor = UIColor.colorWithHexString(textView.text!)
            self.view.backgroundColor = colorView.backgroundColor?.antiColor();
        }
        
    }
    
    @IBAction func editChanged(_ sender: AnyObject) {
        reSetColors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        let color = UIColor.wtStatusColor(with: mySlider.value)
        WTLog("myColor \(color)")
        colorView.backgroundColor = color
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
