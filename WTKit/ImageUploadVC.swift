//
//  ImageUploadVC.swift
//  WTKit
//
//  Created by SongWentong on 6/4/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
/*
    这是一个图片上传女的demo,需要设置一下http的头,然后添加图片数据就可以了
 */
import UIKit

class ImageUploadVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://ww1.sinaimg.cn/mw690/47449485gw1f51dz245iaj20pa0fcdja.jpg"
        uploadButton.wt_setImage(with:url, for: UIControlState.normal)
        
    }
    deinit{
        WTLog("deinit")
    }
    @IBAction func selectImage(_ sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func uploadPressed(_ sender: AnyObject) {
        var request = URLRequest(url: URL(string: "https://httpbin.org/image")!)
        request.setValue("image/png", forHTTPHeaderField: "accept")
        let image = uploadButton.image(for: UIControlState.normal)
        let data = image?.toData()
//        print(data)
        let up = URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            if data != nil{
                let string = data?.toUTF8String()
//                print(string);
                if string?.length == 0{
                    //成功
                }
            }
        }
        up.resume()
//        let request = URLRequest.upLoadFile("ttp://localhost:9000/cgi-bin/PostIt.py", method: "POST", parameters: nil, body: nil);
//        URLSession.dataTaskWithRequest(request as URLRequest) { (data, response, eror) in
        
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        WTPrint(info)
        let image:UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        uploadButton.setImage(image, for: UIControlState())
        picker.dismiss(animated: true) { 
            
        }
    }
    @available(iOS 2.0, *)
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true) { 
            
        }
    }
}
