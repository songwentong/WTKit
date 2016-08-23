//
//  ImageDownloadVC.swift
//  WTKit
//
//  Created by SongWentong on 5/20/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class ImageDownloadVC: UIViewController {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var requestButton: UIButton!
    
    deinit{
        WTLog("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    /*!
        清空缓存
     */
    @IBAction func clearCache(_ sender: AnyObject) {
        UIImageView.clearAllImageCache()
        self.showHudWithTip("缓存已清空")
    }
    @IBAction func requestPress(_ sender: AnyObject) {
        if urlTextField.text != nil {
//            imageView.setImageWith(urlTextField.text! ,placeHolder:nil,complection: )
            imageView.setImage(with: urlTextField.text!, placeHolder: nil, complection: { (image, error) in
                
            })
        }
        
    }
    
    @IBAction func cornerRaius(_ sender: AnyObject) {
            OperationQueue.userInteractive({
                let image = self.imageView.image?.imageWithRoundCornerRadius(30)
                OperationQueue.main({ 
                    self.imageView.image = image
                })
            })
    }
    
    @IBAction func blurredImage(_ sender: AnyObject) {
        if (imageView.image != nil) {
            let image = imageView.image
            var blurredImage:UIImage?
            OperationQueue.globalQueue({ 
                blurredImage = image!.imageWithFilter("CIGaussianBlur", parameters: ["inputRadius":5 as AnyObject])
                if blurredImage != nil {
                    OperationQueue.main {
                        self.imageView.image = blurredImage
                    }
                }
            })
//            DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes(rawValue: UInt64(0))).async(execute: { 
//                blurredImage = image!.imageWithFilter("CIGaussianBlur", parameters: ["inputRadius":5])
//                if (blurredImage != nil){
//                    DispatchQueue.main.async(execute: { 
//                       
//                    })
//                }
//            })
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

}
