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
    @IBAction func clearCache(sender: AnyObject) {
        UIImageView.clearAllImageCache()
    }
    @IBAction func requestPress(sender: AnyObject) {
        if urlTextField.text != nil {
            imageView.setImageWith(urlTextField.text!)
        }
        
    }
    
    @IBAction func cornerRaius(sender: AnyObject) {
            NSOperationQueue.userInteractive({
                let image = self.imageView.image?.imageWithRoundCornerRadius(30)
                NSOperationQueue.main({ 
                    self.imageView.image = image
                })
            })
    }
    
    @IBAction func blurredImage(sender: AnyObject) {
        if (imageView.image != nil) {
            let image = imageView.image
            var blurredImage:UIImage?
            dispatch_async(dispatch_get_global_queue(0, 0), { 
                blurredImage = image!.imageWithFilter("CIGaussianBlur", parameters: ["inputRadius":5])
                if (blurredImage != nil){
                    dispatch_async(dispatch_get_main_queue(), { 
                       self.imageView.image = blurredImage
                    })
                }
            })
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
