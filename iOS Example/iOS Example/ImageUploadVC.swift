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
import WTKit
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
            
            var finish = false
            if data != nil{
                let string = data?.toUTF8String()
//                print(string);
                if string?.count == 0{
                    //成功
                    finish = true
                }
            }
            if finish == true{
                OperationQueue.main.addOperation({
                    self.showHudWithTip("上传成功")
                })
            }else{
                OperationQueue.main.addOperation({
                    self.showHudWithTip("上传失败")
                })
            }
            OperationQueue.main.addOperation({
                self.hideLoadingView()
            })
            
        }
        up.resume()
        self.showLoadingView();

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    fileprivate func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
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


