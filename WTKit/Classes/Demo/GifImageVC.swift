//
//  GifImageVC.swift
//  WTKit
//
//  Created by SongWentong on 5/26/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit

class GifImageVC: UIViewController {
  
    
    @IBOutlet weak var imageView: AnimationImageVIew!
    required init?(coder aDecoder: NSCoder) {
        imageView = nil

        super.init(coder: aDecoder)
        
    }
    deinit{
        WTLog("deinit")
    }
    
    //http://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=gif&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&cs=1608871163,3223894477&os=3118387444,1750686340&simid=4233628155,738094048&pn=5&rn=1&di=199807664760&ln=1000&fr=&fmq=1465700905698_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&is=&istype=0&ist=&jit=&bdtype=0&gsm=0&objurl=http%3A%2F%2Ff.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F1e30e924b899a901f13830bc1f950a7b0208f52f.jpg&rpstart=0&rpnum=0
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        //http://ww1.sinaimg.cn/bmiddle/006ajVGQgw1f4s8n25m5hg30b4081u0z.gif
        self.showLoadingView()
        NSURLSession.cachedDataTaskWithRequest(NSURLRequest.request("http://ww1.sinaimg.cn/mw690/47449485jw1f4shxfge7lg208w04rkjn.gif")) { (data, response, error) in
            if data != nil {
                
                NSOperationQueue.main({
                    self.hideLoadingView()
                    self.imageView = self.view.viewWithTag(1) as! AnimationImageVIew
                    self.imageView.backgroundColor = UIColor.whiteColor()
                    let image = WTImage(data:data!)
                    self.imageView.image = image
                    self.imageView.userInteractionEnabled = true
                    self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GifImageVC.imageTap(_:))))
                })
            }
            
        }
       
//
//        imageView!.image = UIImage.gitImageWith(data,scale: 1)
////        imageView.layer.pauseAnimation()
//        WTLog("\(imageView!.layer.animationKeys())")
//        for key in imageView!.layer.animationKeys()!{
//            let animation = imageView.layer.animationForKey(key)
//            WTLog("\(animation)")
//        }
//        
    }
    func imageTap(geture:UITapGestureRecognizer) {
        if imageView.isAnimating() {
            imageView.stopAnimating()
        }else{
            imageView.startAnimating()
        }
        
    }

    
//    override func viewWillDisappear(animated: Bool) {
////        imageView.layer.pauseAnimation()
//        imageView.image = imageView.snapShot()
//        super.viewWillDisappear(animated)
//    }
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
////        imageView.layer.resumeAnimation()
//        let path = NSBundle.mainBundle().pathForResource("gif", ofType: "gif")
//        let data:NSData = NSData(contentsOfFile: path!)!
//        imageView!.image = UIImage.gitImageWith(data,scale: 1)
//    }
}
