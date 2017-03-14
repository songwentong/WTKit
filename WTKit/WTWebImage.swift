//
//  WTWebImage.swift
//  WTKit
//
//  Created by SongWentong on 14/03/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
import ImageIO
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
        
        return (
            alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast
        )
    }
    
    /*
     Returns whether the image is opaque.
     图片是否是不透明的 true 不透明 false透明
     */
    public var wt_isOpaque: Bool { return !wt_containsAlphaComponent }
    
    /*
     //如果没有alpha通道,就去掉
     public func removeAlphaIfNeeded()->UIImage{
     if self.images != nil{
     return self
     }
     if let cgImage = self.cgImage{
     switch cgImage.alphaInfo {
     case .last: fallthrough
     case .first: fallthrough
     case .premultipliedLast: fallthrough
     case .premultipliedFirst:
     return self
     
     default: break
     }
     
     
     let width = cgImage.width
     let height = cgImage.height
     if var colorSpace:CGColorSpace = cgImage.colorSpace{
     let model:CGColorSpaceModel = colorSpace.model
     var unsupportedColorSpace = true
     switch model {
     case .monochrome:
     fallthrough
     case .unknown:
     fallthrough
     case .indexed:
     unsupportedColorSpace = false
     break
     default:
     break
     }
     if unsupportedColorSpace{
     colorSpace = CGColorSpaceCreateDeviceRGB()
     }
     //                    let space = colorSpace.colors
     //                    let context:CGContext = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4*width, space: <#T##CGColorSpace#>, bitmapInfo: <#T##UInt32#>)
     
     }
     
     
     
     }
     return self
     }
     */
    
    public func toData()->Data?{
        var data = UIImageJPEGRepresentation(self, CGFloat(1))
        if data == nil {
            data = UIImagePNGRepresentation(self)
        }
        return data
    }
    
    
    
    public class func cachedImageDataTask(with url:String,completionHandler:@escaping (UIImage?,Error?)->Void)->WTURLSessionTask{
        let task = dataTask(with: url)
        task.cacheTime = -1
        
        task.imageHandler = {(image,error) in
            completionHandler(image,error)
        }
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
    public func wt_setImage(with url:String, for state:UIControlState,placeHolder:UIImage?=nil,complection:imageHandler?=nil) {
        DispatchQueue.safeSyncInMain {
            self.setImage(placeHolder, for: state)
        }
        
        
        OperationQueue.userInteractive {
            let task = UIImage.cachedImageDataTask(with: url, completionHandler: { [weak self](image,error) in
                DispatchQueue.safeSyncInMain{
                    self?.setImage(image, for: state)
                    self?.setNeedsLayout()
                    if complection != nil {
                        complection!(image,error)
                    }
                }
            })
            
            //            let task = UIImage.cachedImageDataTask(with: url, complection: { [weak self](image, error) in
            //                safeSyncInMain(with: {
            //                    self?.setImage(image, for: state)
            //                    self?.setNeedsLayout()
            //                    if complection != nil {
            //                        complection!(image,error)
            //                    }
            //                })
            //            })
            
            self.wtImageTask = task
            task.resume()
        }
    }
    
    public func setBackgroundImage(with url:String, for state:UIControlState,placeHolder:UIImage?=nil,complection:imageHandler?=nil) {
        DispatchQueue.safeSyncInMain {
            self.setBackgroundImage(placeHolder, for:state)
        }
        
        OperationQueue.userInteractive {
            let task = UIImage.cachedImageDataTask(with: url, completionHandler: { [weak self](image, error) in
                DispatchQueue.safeSyncInMain {
                    self?.setBackgroundImage(image, for:state)
                    self?.setNeedsLayout()
                    if complection != nil {
                        complection!(image,error)
                    }
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
    public func wt_setImage(with url:String ,placeHolder:UIImage? = nil,complection:imageHandler?=nil)->Void{
        DispatchQueue.safeSyncInMain {
            self.image = placeHolder
            self.setNeedsLayout()
        }
        OperationQueue.userInteractive {
            let task =  UIImage.cachedImageDataTask(with: url, completionHandler: { [weak self](image, error) in
                DispatchQueue.safeSyncInMain {
                    self?.image = image
                    self?.setNeedsLayout()
                }
                if complection != nil {
                    complection!(image,error)
                }
            })
            self.wtImageTask = task
            task.resume()
            
        }
    }
    
    /*!
     设置高亮图
     */
    public func sethighlightedImage(with url:String ,placeHolder:UIImage? = nil,complection:imageHandler?=nil)->Void{
        DispatchQueue.safeSyncInMain {
            self.highlightedImage = placeHolder
            self.setNeedsLayout()
        }
        OperationQueue.userInteractive {
            let task =  UIImage.cachedImageDataTask(with: url, completionHandler: { [weak self](image, error) in
                DispatchQueue.safeSyncInMain {
                    self?.image = image
                    self?.setNeedsLayout()
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
