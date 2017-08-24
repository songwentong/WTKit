//
//  WTWebImage.swift
//  WTKit
//
//  Created by SongWentong on 14/03/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
import Foundation

import ImageIO
import UIKit
public enum WTImageFormat:Int{
    case Undefined
    case JPEG
    case PNG
    case GIF
    case TIFF
    case WebP
}
extension Data{
    public func imageType()->WTImageFormat{
        if self.count == 0 {
            return .Undefined
        }
        var buffer = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &buffer, count: 1)
        if buffer == [0xFF] {
        //jpg
            return .JPEG
        }else if buffer == [0x89] {
        //png
            return .PNG
        }else if buffer == [0x47]{
         //gif
            return .GIF
        }else if( buffer == [0x49] || buffer == [0x4D]){
        //tiff
            return .TIFF
        }else if buffer == [0x52]{
        //webp
            return .WebP
        }
        return .Undefined
    }
}
extension UIImage{
    
    /*!
     TODO
     public func convertToPDF()->NSData{
     
     }
     */
    
    
    /*
     TODO gif
     public class func gifImageWithData(data:NSData)->UIImage{
     
     }
     */
    
    
    /*
     Returns whether the image contains an alpha component.
     图片是否包含alpha 通道 true包含 false不包含
     */
    public var wt_containsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo
        let anyAlpha = (
            alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast
        )
        
        return anyAlpha
    }
    
    /*
     Returns whether the image is opaque.
     图片是否是不透明的 true 不透明 false透明
     */
    public var wt_isOpaque: Bool { return !wt_containsAlphaComponent }
    
    
    //如果没有alpha通道,就去掉
    public func decodedImage()->UIImage{
        if self.images != nil {
            return self
        }
        guard !wt_containsAlphaComponent else {
            return self
        }
        guard let cgImage = self.cgImage else {
            return self
        }
        guard let colorSpace = cgImage.colorSpace else {
            return self
        }
//        WTLog("decodedImage")
        let width = cgImage.width
        let height = cgImage.height
        let kBytesPerPixel = 4
        let bytesPerRow = kBytesPerPixel * width
        let bitmapInfo = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)
        let context = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        if context == nil {
            return self
        }
        context?.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: width, height: height))
        if let makeImage =  context?.makeImage(){
            let imageWithoutAlpha = UIImage.init(cgImage: makeImage)
            return imageWithoutAlpha;
        }
        return self
    }
    
    
    public func toData()->Data?{
        var data = UIImageJPEGRepresentation(self, CGFloat(1))
        if data == nil {
            data = UIImagePNGRepresentation(self)
        }
        return data
    }
    
    
    
    public class func cachedImageDataTask(with url:URLConvertible,imageHandler:imageHandler? = nil,completionHandler:completionHandler? = nil)->WTURLSessionTask{
        var request = URLRequest(url: url.asURL())
        request.cachePolicy = .returnCacheDataElseLoad
        let task = WTURLSessionManager.default.dataTask(with: request)
        task.imageHandler = imageHandler
        task.completionHandler = completionHandler
        return task
    }
    
    //创建一个带圆角的图片
    public func imageWithRoundCornerRadius(_ radius:CGFloat) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let clipPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero,size: size), cornerRadius: radius)
        
        clipPath.addClip()
        
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
    
    //TODO做成一个圆形的图
    public func imageRoundedToCircle() -> UIImage{
        let width = self.size.width
        let height = self.size.height
        let d = min(self.size.width, self.size.height)
        let r = d * 0.5
        let rect = CGRect(x: 0,y: 0,width: d,height: d)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: d,height: d), false, 0.0)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: r)
        path.addClip()
        
        var drawRect:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        if height > width {
            drawRect = CGRect(x: 0, y: (height - d)/2, width: d, height: d)
        }else{
            drawRect = CGRect(x: (width - d)/2, y: 0, width: d, height: d)
        }
        draw(in: drawRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //根据滤镜名称和参数返回新的图片对象
    public func imageWithFilter(_ filterName:String,parameters:[String:AnyObject]?=nil) ->UIImage?{
        
        var image: CoreImage.CIImage? = ciImage
        
        if image == nil, let CGImage = self.cgImage {
            image = CoreImage.CIImage(cgImage: CGImage)
        }
        guard let coreImage = image else { return nil }
        
        let context = CIContext(options: [kCIContextPriorityRequestLow: true])
        
        var parameters: [String: AnyObject] = parameters ?? [:]
        parameters[kCIInputImageKey] = coreImage
        
        guard let filter = CIFilter(name: filterName, withInputParameters: parameters) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        let cgImageRef = context.createCGImage(outputImage, from: outputImage.extent)
        
        return UIImage(cgImage: cgImageRef!, scale: scale, orientation: imageOrientation)
    }
    
    public static func gifImageWith(_ data:Data, scale:CGFloat?=UIScreen.main.scale)->UIImage?{
        var image:UIImage?
        let source = CGImageSourceCreateWithData(data as CFData, nil)
        let count = CGImageSourceGetCount(source!)
        if count <= 1 {
            image = UIImage(data: data)
        }else{
            var images:[UIImage] = Array()
            var duration = 0.0
            for i in 0...count-1{
                let cgImage = CGImageSourceCreateImageAtIndex(source!, i, nil)
                duration += (source?.getDurationAtIndex(i))!
                images.append(UIImage(cgImage: cgImage!, scale: scale!, orientation: UIImageOrientation.up))
                
                
            }
            image = UIImage.animatedImage(with: images, duration: duration)
        }
        return image
    }
    
    
}


extension UIView{
    private static var WTUIViewIndicatorKey:Void?
    public func wt_addActivityIndicator()->Void{
        DispatchQueue.main.async {
            let indicate = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
            self.addSubview(indicate)
            indicate.isHidden = false
            indicate.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint.init(item: indicate, attribute: .centerX, relatedBy:.equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: indicate, attribute: .centerY, relatedBy:.equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            indicate.startAnimating()
            indicate.hidesWhenStopped = true
//            indicate.backgroundColor = UIColor.red
            objc_setAssociatedObject(self, &UIView.WTUIViewIndicatorKey, indicate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func wt_removeActivityIndicator(){
        DispatchQueue.main.async {
            if let myIndicate = objc_getAssociatedObject(self, &UIView.WTUIViewIndicatorKey) as? UIActivityIndicatorView{
                myIndicate.removeFromSuperview()
            }
        }
    }
}

//图片下载的key
private var WTUIButtonImageDownloadTaskKey:Void?
private var WTUIButtonBackgroundImageDownloadTaskKey:Void?
extension UIButton{
    internal var wtImageTask:WTURLSessionTask?{
        get{
            let task = objc_getAssociatedObject(self, &WTUIButtonImageDownloadTaskKey)
            return task as? WTURLSessionTask
        }
        set{
            if let task:WTURLSessionTask = objc_getAssociatedObject(self, &WTUIButtonImageDownloadTaskKey) as? WTURLSessionTask{
                task.cancel()
            }
            objc_setAssociatedObject(self, &WTUIButtonImageDownloadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    internal var wtBackgroundImageTask:WTURLSessionTask?{
        get{
            let task = objc_getAssociatedObject(self, &WTUIButtonBackgroundImageDownloadTaskKey)
            return task as? WTURLSessionTask
        }
        set{
            let task = objc_getAssociatedObject(self, &WTUIButtonBackgroundImageDownloadTaskKey)
            if task != nil {
                if task is WTURLSessionTask {
                    let myTask:WTURLSessionTask = task as! WTURLSessionTask
                    myTask.cancel()
                }
            }
            objc_setAssociatedObject(self, &WTUIButtonBackgroundImageDownloadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    // MARK: - 设置一张网络图片,并缓存下来
    public func wt_setImage(with url:String, for state:UIControlState,placeHolder:UIImage? = nil,complection:imageHandler?=nil) {
        DispatchQueue.safeSyncInMain {
            self.setImage(placeHolder, for: state)
        }
        
        
        OperationQueue.userInteractive {
            let task = UIImage.cachedImageDataTask(with: url, imageHandler: { [weak self](image,error) in
                if image != nil{
                    DispatchQueue.safeSyncInMain{
                        self?.setImage(image, for: state)
                        self?.setNeedsLayout()
                    }
                }
                
                if complection != nil {
                        complection!(image,error)
                }
                
                
            })
            
            self.wtImageTask = task
            task.resume()
        }
    }
    
    public func setBackgroundImage(with url:String, for state:UIControlState,placeHolder:UIImage? = nil,complection:imageHandler? = nil) {
        DispatchQueue.safeSyncInMain {
            self.setBackgroundImage(placeHolder, for:state)
        }
        
        OperationQueue.userInteractive {
            let task = UIImage.cachedImageDataTask(with: url, imageHandler: { [weak self](image, error) in
                if image != nil{
                    
                        DispatchQueue.safeSyncInMain {
                            self?.setBackgroundImage(image, for:state)
                            self?.setNeedsLayout()
                        }
                    
                }
                if complection != nil {
                    complection!(image,error)
                }
            })
            self.wtImageTask = task
            task.resume()
        }
    }
    
}
//图片下载的键值对
//private var UIImageViewImageDownloadKey:Void?
//private var UIImageViewHighLightedImageDownloadKey:Void?
private var WTUIImageViewImageDataTaskKey:Void?
private var WTUIImageViewHighLightedImageDataTaskKey:Void?
extension UIImageView{
    
    
    internal var wtImageTask:WTURLSessionTask?{
        get{
            let task = objc_getAssociatedObject(self, &WTUIImageViewImageDataTaskKey)
            return task as? WTURLSessionTask
        }
        set{
            let task = objc_getAssociatedObject(self, &WTUIImageViewImageDataTaskKey)
            if task != nil {
                if task is WTURLSessionTask {
                    let myTask:WTURLSessionTask = task as! WTURLSessionTask
                    myTask.cancel()
                }
            }
            objc_setAssociatedObject(self, &WTUIImageViewImageDataTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var wtHighLightedImageTask:WTURLSessionTask?{
        get{
            let task = objc_getAssociatedObject(self, &WTUIImageViewHighLightedImageDataTaskKey)
            return task as? WTURLSessionTask
        }
        set{
            let task = objc_getAssociatedObject(self, &WTUIImageViewHighLightedImageDataTaskKey)
            if task != nil {
                if task is WTURLSessionTask {
                    let myTask:WTURLSessionTask = task as! WTURLSessionTask
                    myTask.cancel()
                }
            }
            objc_setAssociatedObject(self, &WTUIImageViewHighLightedImageDataTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    // MARK: - 设置一张网络图片,并缓存下来
    /*!
     给出URL来请求图片
     swift 中对于方法做了优化,无需写多个方法来设置不同参数,写一个全的,然后需要填几个参数就填几个
     不想填的就填一个不加逗号就可以了.
     */
    public func wt_setImage(with url:String ,placeHolder:UIImage? = nil,imageHandler:imageHandler? = nil,completionHandler:completionHandler? = nil)->Void{
        
//        if placeHolder == nil {
            self.wt_addActivityIndicator()
//        }
        DispatchQueue.safeSyncInMain {
            self.image = placeHolder
            self.setNeedsLayout()
        }
        
        OperationQueue.userInteractive {
            let task =  UIImage.cachedImageDataTask(with: url, imageHandler: { [weak self](image, error) in
                if error != nil {
//                    print("\(String(describing: error))")
                }
                //如果取到图片了,设置一下,否则就返回错误
                if let getImage = image{
 
                    DispatchQueue.safeSyncInMain {
                            self?.image = getImage
                            self?.setNeedsLayout()
                            self?.wt_removeActivityIndicator()
                    }
                    
                }
                
                if imageHandler != nil {
                    imageHandler!(image,error)
                }
                
                
            }, completionHandler: completionHandler)
            self.wtImageTask = task
            task.resume()
            
        }
    }
    
    /*!
     设置高亮图
     */
    public func wt_sethighlightedImage(with url:String ,placeHolder:UIImage? = nil,complection:imageHandler?=nil)->Void{
        DispatchQueue.safeSyncInMain {
            self.highlightedImage = placeHolder
            self.setNeedsLayout()
        }
        OperationQueue.userInteractive {
            let task =  UIImage.cachedImageDataTask(with: url, imageHandler: { [weak self](image, error) in
                if image != nil{

       
                        DispatchQueue.safeSyncInMain {
                            self?.image = image
                            self?.setNeedsLayout()
                        }
                    
                }
                if complection != nil {
                    complection!(image,error)
                }
            })
            self.wtHighLightedImageTask = task
            task.resume()
        }
    }
    
    
    
    
}
//TODO UIImageView WebP支持
