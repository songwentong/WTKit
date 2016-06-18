//
//  ImageUploadVC.swift
//  WTKit
//
//  Created by SongWentong on 6/4/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class ImageUploadVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"
        uploadButton.setImageWith(url, forState: .Normal)
        
    }
    deinit{
        WTLog("deinit")
    }
    @IBAction func selectImage(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func uploadPressed(sender: AnyObject) {
        let request = NSURLRequest.upLoadFile("ttp://localhost:9000/cgi-bin/PostIt.py", method: "POST", parameters: nil, body: nil);
        NSURLSession.dataTaskWithRequest(request) { (data, response, eror) in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        WTPrint(info)
        let image:UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        uploadButton.setImage(image, forState: .Normal)
        picker.dismissViewControllerAnimated(true) { 
            
        }
    }
    @available(iOS 2.0, *)
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true) { 
            
        }
    }
}
