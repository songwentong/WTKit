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

open class AnimationImageVIew: UIImageView {
    
    
    private var iamgesource:CGImageSource? = nil
    private var currentFrameIndex = 0
    private var allFrameCount = 0
    private var linkIsInit = true// displaylink是懒加载，避免没有初始化
    private var curFrame:UIImage?
    private var loopCount = 0
    private var duration:TimeInterval = 0
    private lazy var link:CADisplayLink = {
        self.linkIsInit = true
        let aLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(AnimationImageVIew.play(_:)));
        aLink.add(to: RunLoop.main, forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
        return aLink;
    }()
    
    func play(_ link:CADisplayLink) {
        if allFrameCount == 0{
            return 
        }
        let nextIndex = (currentFrameIndex + 1) % allFrameCount
        if image == nil {
            return
        }
        var delay:TimeInterval = 0
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
    override open var image: UIImage?{
        
        didSet{
            if image != oldValue {
              self.resetImage()
            }
            setNeedsLayout()
            layer.setNeedsDisplay()
        }
        
    }
    override open var isAnimating:Bool {
        if linkIsInit {
            return !link.isPaused
        }
        return super.isAnimating
       
    }
    override open func display(_ layer: CALayer) {
        if curFrame != nil {
            layer.contents = curFrame?.cgImage
        }
    }
    
    
    override open func startAnimating() {
    
        if self.isAnimating {
            return
        }else{
            if linkIsInit {
               link.isPaused = false
            }
           
        }
        
    }
    
    override open func stopAnimating() {
        super.stopAnimating()
        if linkIsInit {
            link.isPaused = true
        }
        
    }
    
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        self.didMove()
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.didMove()
    }
    
    //重新设置image，变量重新初始化
    private func resetImage(){
        self.stopAnimating()
        if let imageSource = (image as! WTImage).iamgeSource!.source{
            self.link.isPaused = true
            self.curFrame = image
            self.allFrameCount = CGImageSourceGetCount(imageSource)
            self.currentFrameIndex = 0
            self.iamgesource = imageSource
            if let properties = CGImageSourceCopyProperties(imageSource, nil),
                let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                let loopCount = gifInfo[kCGImagePropertyGIFLoopCount as String] as? Int {
                self.loopCount = loopCount
            }
            if link.isPaused && curFrame != nil {
                link.isPaused = false
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
    private func prepareFrame(_ index:Int) -> UIImage?{
        guard let imageRef = CGImageSourceCreateImageAtIndex(self.iamgesource!, index, nil) else {return nil}
//        let duration = self.iamgesource!.getDurationAtIndex(index)
        let aImage = UIImage(cgImage: imageRef)

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
    var source:CGImageSource?
    init(imageref:CGImageSource){
        self.source = imageref
    }
}

//swift 不可以 as? CGImageSourceRef 类型转换，这里自定义class获取
public class WTImage:UIImage{
    internal var iamgeSource:ImageSource?

    public override init?(data: Data) {
        let imageSourceRef = CGImageSourceCreateWithData(data as CFData, nil);
        self.iamgeSource = ImageSource(imageref: imageSourceRef!)
        super.init(data: data)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience public init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }

}

extension CGImageSource{
    func gifPropertiesAtIndex(_ index:Int) -> [String:Double]? {
        let properties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) as Dictionary?
        return properties?[kCGImagePropertyGIFDictionary] as? [String: Double]
    }
    func getDurationAtIndex(_ index:Int) -> Double {
        guard let property = self.gifPropertiesAtIndex(index) else {return 0.1}
        let dur = property[kCGImagePropertyGIFDelayTime as String]! as NSNumber
        if dur.doubleValue < 0.011 {
            return 0.1
        }
        return dur.doubleValue
    }
    
}




#endif
