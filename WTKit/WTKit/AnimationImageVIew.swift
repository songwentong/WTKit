//  https://github.com/swtlovewtt/WTKit
//  AnimationImageVIew.swift
//  WTKit
//
//  Created by 李能 on 16/5/30.
//  Copyright © 2016年 SongWentong. All rights reserved.
//
#if os(iOS)
import UIKit
import ImageIO

class AnimationImageVIew: UIImageView {
    
    
    private var iamgesource:CGImageSourceRef? = nil
    private var currentFrameIndex = 0
    private var allFrameCount = 0
    private var linkIsInit = true// displaylink是懒加载，避免没有初始化
    private var curFrame:UIImage?
    private var loopCount = 0
    private var duration:NSTimeInterval = 0
    private lazy var link:CADisplayLink = {
        self.linkIsInit = true
        let aLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(AnimationImageVIew.play(_:)));
        aLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        return aLink;
    }()
    
    func play(link:CADisplayLink) {
        if allFrameCount == 0{
            return 
        }
        let nextIndex = (currentFrameIndex + 1) % allFrameCount
        if image == nil {
            return
        }
        var delay:NSTimeInterval = 0
        duration += link.duration
        delay = (iamgesource?.getDurationAtIndex(currentFrameIndex))!
        if duration < delay {
            return
        }
        duration -= delay
        //TODO:LOOP
        if nextIndex == 0 {

        }
        currentFrameIndex = nextIndex
        curFrame = self.prepareFrame(currentFrameIndex)
        layer.setNeedsDisplay()
    }
    
    //MARK:override
    override internal var image: UIImage?{
        
        didSet{
            if image != oldValue {
              self.resetImage()
            }
            setNeedsLayout()
            layer.setNeedsDisplay()
        }
        
    }
    override func isAnimating() -> Bool {
        if linkIsInit {
            return !link.paused
        }
        return super.isAnimating()
       
    }
    override func displayLayer(layer: CALayer) {
        if curFrame != nil {
            layer.contents = curFrame?.CGImage
        }
    }
    
    
    override internal func startAnimating() {
    
        if self.isAnimating() {
            return
        }else{
            if linkIsInit {
               link.paused = false
            }
           
        }
        
    }
    
    override internal func stopAnimating() {
        super.stopAnimating()
        if linkIsInit {
            link.paused = true
        }
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.didMove()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.didMove()
    }
    
    //重新设置image，变量重新初始化
    private func resetImage(){
        self.stopAnimating()
        if let imageSource = (image as! WTImage).iamgeSource!.source{
            self.link.paused = true
            self.curFrame = image
            self.allFrameCount = CGImageSourceGetCount(imageSource)
            self.currentFrameIndex = 0
            self.iamgesource = imageSource
            if let properties = CGImageSourceCopyProperties(imageSource, nil),
                gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                loopCount = gifInfo[kCGImagePropertyGIFLoopCount as String] as? Int {
                self.loopCount = loopCount
            }
            if link.paused && curFrame != nil {
                link.paused = false
            }
        }
     
    }
    //MARK:private method
    private func didMove(){
        if self.superview != nil && super.window != nil {
            self.startAnimating()
        }else{
            self.stopAnimating()
        }
    
    }
    private func prepareFrame(index:Int) -> UIImage?{
        guard let imageRef = CGImageSourceCreateImageAtIndex(self.iamgesource!, index, nil) else {return nil}
//        let duration = self.iamgesource!.getDurationAtIndex(index)
        let aImage = UIImage(CGImage: imageRef)

        return aImage
    }
    
    deinit{
        if linkIsInit {
            link.invalidate() 
        }
       
    }
 
}


private var imageSourceKey:Void?

class ImageSource {
    var source:CGImageSourceRef?
    init(imageref:CGImageSourceRef){
        self.source = imageref
    }
}

//swift 不可以 as? CGImageSourceRef 类型转换，这里自定义class获取
class WTImage:UIImage{
    internal var iamgeSource:ImageSource?

    override init?(data: NSData) {
        let imageSourceRef = CGImageSourceCreateWithData(data, nil);
        self.iamgeSource = ImageSource(imageref: imageSourceRef!)
        super.init(data: data)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init(imageLiteral name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }

}

extension CGImageSourceRef{
    func gifPropertiesAtIndex(index:Int) -> [String:Double]? {
        let properties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) as Dictionary?
        return properties?[kCGImagePropertyGIFDictionary as String] as? [String: Double]
    }
    func getDurationAtIndex(index:Int) -> Double {
        guard let property = self.gifPropertiesAtIndex(index) else {return 0.1}
        let dur = property[kCGImagePropertyGIFDelayTime as String]! as NSNumber
        if dur.doubleValue < 0.011 {
            return 0.1
        }
        return dur.doubleValue
    }
    
}




#endif