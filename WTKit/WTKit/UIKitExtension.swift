//  https://github.com/swtlovewtt/WTKit
//  UIKitExtension.swift
//  WTKit
//
//  Created by SongWentong on 4/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit
import ImageIO



// MARK: - 官方类扩展
extension UIColor{
    
    /*!
     根据字符串和alpha给出颜色
     如果给出的是一个不正常的字符串,会返回红色
     */
    public class func colorWithHexString(string:String,alpha:CGFloat?=1.0) -> UIColor{
        //        let s = NSScanner(string: string)
        let mutableCharSet = NSMutableCharacterSet()
        mutableCharSet.addCharactersInString("#")
        mutableCharSet.formUnionWithCharacterSet(NSCharacterSet.whitespaceCharacterSet());
        
        
        let hString = string.stringByTrimmingCharactersInSet(mutableCharSet)
        DEBUGBlock {
            //            NSLog("%@", hString)
        }
        
        
        switch hString.length {
        case 0:
            return UIColor.redColor();
        case 1:
            return UIColor.colorWithHexString(hString+hString);
        case 2:
            return UIColor.colorWithHexString(hString+hString+hString);
        case 6:
            let r = hString[0..<2]
            let g = hString[2..<4]
            let b = hString[4..<6]
            var rInt:UInt32 = 0x0,gInt:UInt32 = 0x0,bInt:UInt32 = 0x0
            
            NSScanner.init(string: r).scanHexInt(&rInt)
            NSScanner.init(string: g).scanHexInt(&gInt)
            NSScanner.init(string: b).scanHexInt(&bInt)
            
            let red = CGFloat(rInt)/255.0
            let green = CGFloat(gInt)/255.0
            let blue = CGFloat(bInt)/255.0
            WTLog("\(red) \(green) \(blue)")
            let color = UIColor(red: red, green: green, blue: blue,alpha: alpha!)
            return color;
        default:
            return UIColor.redColor();
        }
    }
    
    public func intFromString(string:String)->UInt32{
        var intValue:UInt32 = 0x0;
        NSScanner.init(string:string).scanHexInt(&intValue)
        return intValue
    }

    
    public func antiColor()->UIColor{
        var r:CGFloat=0
        var g:CGFloat=0
        var b:CGFloat=0
        var a:CGFloat=0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: 1-r, green: 1-g, blue: 1-b, alpha: a)
    }
    
    //TODO
    public func hexString()->String{
        return ""
    }
    
    private class func randomColorValue()->CGFloat{
        return CGFloat(random())%255.0
    }
    
    //随机产生一个颜色
    public class func randomColor()->UIColor{
        let color:UIColor
        color = UIColor(red: randomColorValue(), green: randomColorValue(), blue: randomColorValue(), alpha: 1.0);
        return color
    }
}

private let UIApplicationVersionsKey = "UI application version track key"
private let UIApplicationBuildsKey = "UI application version build key"
private var UIApplicationIsFirstEver:Void?
extension UIApplication{
    
    
  
    
    
       
    //---------------------------------------------------------------------
    public class func appBundleName()->String{
            return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
    }
    
    public class func appBundleID()->String{
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier") as! String
    }
    
    public class func buildVersion()->String{
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    }
    
    public static func appVersion()->String{
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    public static func documentsPath()->String{
        return String(format: "%@/Documents",NSHomeDirectory())
    }
    
    public static func libraryPath()->String{
    return String(format: "%@/Library",NSHomeDirectory())
    }
    
    
    //-----------version tracking-----------------
    
    /*!
        是否是当前版本的首次启动
     */
    public var isFirstLaunchEver:Bool{
    get{
        var isFirst:Bool? = objc_getAssociatedObject(self, &UIApplicationIsFirstEver) as? Bool
        if isFirst == nil {
            isFirst = UIApplication.isFirstLaunchMethod()
            objc_setAssociatedObject(self, &UIApplicationIsFirstEver, isFirst, .OBJC_ASSOCIATION_ASSIGN)
        }
        return isFirst!
    }
    }
    
    /*!
        记录一下当前版本
     */
    public static func track(){
        let first = self.isFirstLaunchMethod()
        objc_setAssociatedObject(UIApplication.sharedApplication(), &UIApplicationIsFirstEver, first, .OBJC_ASSOCIATION_ASSIGN)
        
        var versionArray:[String]! = NSUserDefaults.standardUserDefaults().arrayForKey(UIApplicationVersionsKey) as? Array<String>
        if versionArray == nil {
            versionArray = Array()
        }
        if !versionArray!.contains(self.appVersion()) {
            versionArray.append(self.appVersion())
        }
        
        
        var buildArray:[String]! = NSUserDefaults.standardUserDefaults().arrayForKey(UIApplicationBuildsKey) as? Array<String>
        if buildArray == nil {
            buildArray = Array()
        }
        if !buildArray.contains(self.buildVersion()) {
            buildArray.append(self.buildVersion())
        }
        
        
        NSUserDefaults.standardUserDefaults().setValue(versionArray, forKey: UIApplicationVersionsKey)
        NSUserDefaults.standardUserDefaults().setValue(buildArray, forKey: UIApplicationBuildsKey)
//        WTLog(versionArray)
//        WTLog(buildArray)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private class func isFirstLaunchMethod()->Bool{
        var isFirstLaunchEver = true
        let versionArray:[String]? = NSUserDefaults.standardUserDefaults().arrayForKey(UIApplicationVersionsKey) as? Array<String>
        if versionArray != nil {
            if versionArray!.contains(self.appVersion()) {
                isFirstLaunchEver = false
            }
        }
        return isFirstLaunchEver
    }
}
extension UIScreen{
    public static func screenWidth()->CGFloat{
        return CGRectGetWidth(UIScreen.mainScreen().bounds)
    }
    public static func screenHeight()->CGFloat{
        return CGRectGetHeight(UIScreen.mainScreen().bounds)
    }
}
extension UIDevice{
    public static func systemVersion()->String{
        return UIDevice.currentDevice().systemVersion
    }
    public static func systemFloatVersion()->Float{
        return UIDevice.currentDevice().systemVersion.floatValue
    }
    
    //
    public static func uuidString()->String{
        return (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
    }
    
    
    /*!
        is iPhone
     */
    public static func isPhone()->Bool{
        
        if UI_USER_INTERFACE_IDIOM() == .Phone {
            return true
        }
        return false
    }
    
    /*!
        硬盘空间
     */
    public func diskSpace()->Int64{
        var attributes:[String : AnyObject]?
        var fileSystemSize:Int64 = 0
        do{
           try attributes = NSFileManager.defaultManager().attributesOfItemAtPath(NSHomeDirectory())
            fileSystemSize = (attributes![NSFileSystemSize]?.longLongValue)!
        }catch{
            
        }
        return fileSystemSize
    }
    
    /*!
        可用空间
    */
    public func diskSpaceFree()->Int64{
        var attributes:[String : AnyObject]?
        var fileSystemSize:Int64 = 0
        do{
            try attributes = NSFileManager.defaultManager().attributesOfItemAtPath(NSHomeDirectory())
            fileSystemSize = (attributes![NSFileSystemFreeSize]?.longLongValue)!
        }catch{
            
        }
        return fileSystemSize
    }
    
    /*!
        已用空间
     */
    public func diskSpaceUsed()->Int64{
        return diskSpace() - diskSpaceFree()
    }
    
    /*!
        物理内存
     */
    public func memoryTotal()->UInt64{
        let mem = NSProcessInfo.processInfo().physicalMemory;
        return mem;
    }
    
}

//target - action block keys
private var UIControlTargetActionBlockKeys:Void?
extension UIControl{
    private var taBlockKeys:[UIControlTABlock]{
    get{
    var obj = objc_getAssociatedObject(self, &UIControlTargetActionBlockKeys)
    if( obj is Array<UIControlTABlock> ){
    
    }else{
    obj = [UIControlTABlock]()
    objc_setAssociatedObject(self, &UIControlTargetActionBlockKeys, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    return obj as! Array<UIControlTABlock>
    }
        set{
            objc_setAssociatedObject(self, &UIControlTargetActionBlockKeys, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func addtarget(block:(sender:UIControl)->Void, forControlEvents controlEvents: UIControlEvents)->Void{
        let taBlock = UIControlTABlock()
        taBlock.block = block
        let selector = #selector(UIControlTABlock.run(_:))
        self.addTarget(taBlock, action: selector, forControlEvents: controlEvents)
        self.taBlockKeys.append(taBlock)
    }
    public func reciveEvent(sender:UIControl){
        
    }
    
    class UIControlTABlock:NSObject{
        var block:((sender:UIControl)->Void)?
        var event:UIControlEvents?
        
        override init() {
            
            super.init()
        }
        
        deinit{
            WTLog("deinit")
        }
        
        func run(sender:UIControl){
            if block != nil{
                block?(sender: sender)
            }
        }
    }
 
}


//图片下载的key
private var UIButtonImageDownloadOperationKey:Void?
extension UIButton{
    
    internal var imageOperation:ImageDownloadOperaion?{
        get{
            let operation = objc_getAssociatedObject(self, &UIButtonImageDownloadOperationKey)
            if operation == nil {
                return nil
            }
            return operation as? ImageDownloadOperaion
        }
        set{
            let operation = self.imageOperation
            
            if (operation != nil) {
                operation?.cancel()
            }
            
            
            objc_setAssociatedObject(self, &UIButtonImageDownloadOperationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }

    
    public func setImageWith(url:String, forState:UIControlState,placeHolder:UIImage?=nil,complection:((image:UIImage?,error:NSError?)->Void)?=nil) {
        safeSyncInMain { 
            self.setImage(placeHolder, forState: forState)
        }
        
        NSOperationQueue.userInteractive {
            let operation = UIImage.imageOperationWithURL(url) { [weak self](image, error) in
                    safeSyncInMain({
                        self?.setImage(image, forState: forState)
                        self?.setNeedsLayout()
                        if complection != nil {
                            complection!(image:image,error: error)
                        }
                        
                    })
            };
            self.imageOperation = operation
            operation.start()
        }
    }
    
    public func cancelDownloadingImage(){
        self.imageOperation = nil
    }
}




//下载图片的operation
public class ImageDownloadOperaion:NSOperation{

    var _cancelled = false // Our read-write mirror of the super's read-only executing property
    override public func cancel(){
        self.cancelled = true
    }
    
    /// Override read-only superclass property as read-write.
    override public var cancelled: Bool {
        get { return _cancelled }
        set {
            willChangeValueForKey("isExecuting")
            _cancelled = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    
    let url:String
    let completionHandler: (image:UIImage?,error:NSError?)->Void
    init(url:String,completionHandler: (image:UIImage?,error:NSError?)->Void) {
        self.completionHandler = completionHandler
        self.url = url
        super.init()
    }
    
    
     deinit{
//        WTLog("ImageDownloadOperaion deinit")
    }
    override public func main() {
        
        let request = NSURLRequest(URL: NSURL.init(string: url)!)
        
        let sharedURLCache = UIImage.sharedURLCache()
        
        //找到对应的缓存
        let cachedResponseForRequest = sharedURLCache.cachedResponseForRequest(request);
        
        
        
        if (cachedResponseForRequest == nil){
            
            
            //weak self 使用场景:self 可能为空    unowned 使用场景:self 不能为空
            let task =  NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { [weak self](data, response, error1) -> Void in
                    if(error1 == nil){
                        NSOperationQueue.globalQueue({ 
                            let image = UIImage(data: data!)
                            
                            if self != nil{
                                if(!self!.cancelled){
                                    self!.completionHandler(image: image, error:error1)
                                }
                            }
                            
                            
                            let responseToCache = NSCachedURLResponse(response: response!, data: data!, userInfo: nil, storagePolicy: NSURLCacheStoragePolicy.Allowed)
                            sharedURLCache.storeCachedResponse(responseToCache, forRequest:request )
                        })
                        
                        
                        
                    }else{
                        if (self != nil){
                            if(!self!.cancelled){
                                self!.completionHandler(image: nil, error: error1)
                            }
                        }
                        
                        
                    }
                    
                })
                task.resume()
            
        }else{
            NSOperationQueue.globalQueue({ 
                let image = UIImage(data: (cachedResponseForRequest?.data)!)
                if !self.cancelled {
                    self.completionHandler(image: image, error: nil)
                }
            })
            
            
            
        }
        
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
    
    public class func sharedURLCache() -> NSURLCache {
        return NSURLCache.sharedURLCacheForUIImage()
    }
    
    
    //创建一个可以缓存图片的operation
    public class func imageOperationWithURL(url:String, completionHandler: (image:UIImage?,error:NSError?)->Void)->ImageDownloadOperaion!{
        return ImageDownloadOperaion.init(url: url, completionHandler: completionHandler)
    }
    //创建一个带圆角的图片
    public func imageWithRoundCornerRadius(radius:CGFloat) -> UIImage{
    
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let clipPath = UIBezierPath(roundedRect: CGRect(origin: CGPointZero,size: size), cornerRadius: radius)
        
        clipPath.addClip()
        
        drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    //根据滤镜名称和参数返回新的图片对象
    public func imageWithFilter(filterName:String,parameters:[String:AnyObject]?=nil) ->UIImage?{
        
        var image: CoreImage.CIImage? = CIImage
        
        if image == nil, let CGImage = self.CGImage {
            image = CoreImage.CIImage(CGImage: CGImage)
        }
        guard let coreImage = image else { return nil }
        
        let context = CIContext(options: [kCIContextPriorityRequestLow: true])
        
        var parameters: [String: AnyObject] = parameters ?? [:]
        parameters[kCIInputImageKey] = coreImage
        
        guard let filter = CIFilter(name: filterName, withInputParameters: parameters) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        let cgImageRef = context.createCGImage(outputImage, fromRect: outputImage.extent)
        
        return UIImage(CGImage: cgImageRef, scale: scale, orientation: imageOrientation)
    }
    
    public static func gifImageWith(data:NSData, scale:CGFloat?=UIScreen.mainScreen().scale)->UIImage?{
        var image:UIImage?
        let source = CGImageSourceCreateWithData(data, nil)
        let count = CGImageSourceGetCount(source!)
        if count <= 1 {
            image = UIImage(data: data)
        }else{
            var images:[UIImage] = Array()
            var duration = 0.0
            for i in 0...count-1{
                let cgImage = CGImageSourceCreateImageAtIndex(source!, i, nil)
                duration += (source?.getDurationAtIndex(i))!
                images.append(UIImage(CGImage: cgImage!, scale: scale!, orientation: UIImageOrientation.Up))
                
                
            }
            image = UIImage.animatedImageWithImages(images, duration: duration)
        }
        return image
    }
    
    
}



//图片下载的键值对
private var UIImageViewImageDownloadKey:Void?
private var UIImageViewHighLightedImageDownloadKey:Void?
extension UIImageView{
    
    public static func clearAllImageCache(){
        UIImage.sharedURLCache().removeAllCachedResponses()
    }
    


    internal var imageOperation:ImageDownloadOperaion?{
        get{
            let operation = objc_getAssociatedObject(self, &UIImageViewImageDownloadKey)
            if operation == nil {
                return nil
            }
            return operation as? ImageDownloadOperaion
        }
        set{
            let operation = self.imageOperation
                if (operation != nil) {
                    operation?.cancel()
                }
            objc_setAssociatedObject(self, &UIImageViewImageDownloadKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    internal var highlightedImageOperation:ImageDownloadOperaion?{
        get{
            let operation = objc_getAssociatedObject(self, &UIImageViewHighLightedImageDownloadKey)
            if operation == nil {
                return nil
            }
            return operation as? ImageDownloadOperaion
        }
        set{
            let operation = self.imageOperation
            if (operation?.executing == true) {
                operation?.cancel()
            }
            objc_setAssociatedObject(self, &UIImageViewHighLightedImageDownloadKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }

    /*!
        给出URL来请求图片
        swift 中对于方法做了优化,无需写多个方法来设置不同参数,写一个全的,然后需要填几个参数就填几个
        不想填的就填一个不加逗号就可以了.
     */
    func setImageWith(url:String?="" ,placeHolder:UIImage? = nil,complection:((image:UIImage?,error:NSError?)->Void)?=nil)->Void{
        safeSyncInMain { 
            self.image = placeHolder
        }
        NSOperationQueue.globalQueue {
            let operation = UIImage.imageOperationWithURL(url!) { [weak self](image:UIImage?, error:NSError?) -> Void in
                    safeSyncInMain({
                        self?.image = image
                        self?.setNeedsLayout()
                    })
                if complection != nil{
                    complection!(image:image,error:error)
                }
            }
            
            self.imageOperation = operation
            operation.start()
        }
    }
    
    /*!
        设置高亮图
     */
    func sethighlightedImageWith(url:String?="" ,placeHolder:UIImage? = nil){
        safeSyncInMain {
            self.highlightedImage = placeHolder
        }
        NSOperationQueue.globalQueue {
            let operation = UIImage.imageOperationWithURL(url!) { [weak self](image:UIImage?, error:NSError?) -> Void in
                safeSyncInMain({
                    self?.highlightedImage = image;
                    self?.setNeedsLayout()
                })
                
            }
            
            self.highlightedImageOperation = operation
            operation.start()
        }
    }
    
    
    
    
}


extension UIViewController{
    //弹出Alert
    public func showAlert(title:String?, message:String? , duration:Double){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            self.presentViewController(alert, animated: true) {
                self.performBlock({
                    alert.dismissViewControllerAnimated(true, completion: {
                        
                    })
                    }, afterDelay: duration)
            }
        }
    }
    
    
    

}


extension UIView{
    //绘制截图
    public func snapShot() -> UIImage!{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image;
    }
    
    /*!
        将UIView绘制成PDF
     */
    public func pdf()->NSData{
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil);
        UIGraphicsBeginPDFPage();
        let pdfContext:CGContext? = UIGraphicsGetCurrentContext();
        self.layer.renderInContext(pdfContext!)
        UIGraphicsEndPDFContext();
        
        return pdfData
    }
    
    
    /*!
        创建一个可缩放
     */
    public func setViewForImage(image:UIImage){
        
        let scrollview = UIScrollView(frame: self.bounds)
        addSubview(scrollview)
        
    }
    
    
    /*!
        清空所有子视图
     */
    public func removeAllSubViews(){
        while self.subviews.count != 0 {
            self.subviews.first?.removeFromSuperview()
        }
    }
    
    public func viewController()->UIViewController?{
        if self.nextResponder() is UIViewController {
            return self.nextResponder() as? UIViewController
        }else{
            return nil
        }
    }
}

extension UIWebView{
    /*!
        缓存网页
     */
    public func loadRequest(request: NSURLRequest, useCache:Bool){
        let req:NSMutableURLRequest = request.mutableCopy() as! NSMutableURLRequest
        if useCache {
            req.cachePolicy = .ReturnCacheDataElseLoad
        }
        loadRequest(request)
    }
}

public class RefreshHeader:UIView{
    var refreshBlock:()->Void
    weak var scrollView:UIScrollView?
    var state:ScrollViewRefreshState
    public var refreshHeight:CGFloat
    
    /*!
        这里5条数据可配置
     */
    public var pullDownToRefreshText:String = "pull down to refresh"
    public var releaseToRefreshText:String = "release to refresh"
    public var loadingText:String = "Loading..."
    public var lastUpdateText:String = "last update time:"
    public var dateStyle:String = "yyyy-MM-dd"
    var titleLabel:UILabel
    var timeLabel:UILabel
    
    /*!
        图片地址可配置,也可设置为本地的地址
     */
    let arrowImageURL:String = "http://ww4.sinaimg.cn/mw690/47449485jw1f4wq45lqu6j201i02gq2p.jpg"
    var arrowImageView:UIImageView
    var activityIndicator:UIActivityIndicatorView
    var lastUpdateDate:NSDate? = nil
    var dateFormatter:NSDateFormatter = NSDateFormatter()
    
    override init(frame: CGRect) {
        self.refreshBlock = {}
        state = .PullDownToRefresh
        refreshHeight = CGRectGetHeight(frame)
        titleLabel = UILabel()
        timeLabel = UILabel()
        arrowImageView = UIImageView()
        arrowImageView.setImageWith(arrowImageURL)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(arrowImageView)
        addSubview(activityIndicator)
        
        titleLabel.frame = CGRectMake(0, 0, UIScreen.screenWidth(), 40)
        titleLabel.textAlignment = .Center
        timeLabel.frame = CGRectMake(0, 40, UIScreen.screenWidth(), 20)
        timeLabel.textAlignment = .Center
        timeLabel.font = UIFont.systemFontOfSize(12)
        timeLabel.textColor = UIColor.colorWithHexString("3")
        arrowImageView.frame = CGRectMake(30, 0, 30, CGRectGetHeight(frame))
        activityIndicator.frame = arrowImageView.frame
        activityIndicator.hidesWhenStopped = true
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public enum ScrollViewRefreshState:Int{
        case PullDownToRefresh
        case ReleaseToRefresh
        case Loading
    }
    
    public func setTitle(title:String, forState:ScrollViewRefreshState){
        switch forState {
        case .PullDownToRefresh:
            pullDownToRefreshText = title
        case .ReleaseToRefresh:
            releaseToRefreshText = title
        case .Loading:
            loadingText = title
        }
    }

    public class func headerWithRefreshing(block:()->Void)->RefreshHeader{
        let width = UIScreen.screenWidth()
        let height:CGFloat = 60
        let header = RefreshHeader(frame: CGRectMake(0,-height,width,height))
        header.refreshBlock = block
        
        return header
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        
        if newSuperview is UIScrollView {
            self.scrollView = newSuperview as? UIScrollView
            addObservers()
        }
    }
    
    public override func willMoveToWindow(newWindow: UIWindow?) {
//        removeObservers()
        if newWindow == nil {
            removeObservers()
        }
    }
    func contentOffset()->String{
        return "contentOffset"
    }
    func dragging()->String{
        return "dragging"
    }
    func addObservers(){
//        self.scrollView?.contentOffset
//        self.scrollView?.dragging
        self.scrollView?.addObserver(self, forKeyPath: contentOffset(), options: .New, context: nil)
//        self.scrollView?.addObserver(self, forKeyPath: "dragging", options: .New, context: nil)
    }
    func removeObservers(){
        self.scrollView?.removeObserver(self, forKeyPath: contentOffset())
//        self.scrollView?.removeObserver(self, forKeyPath: "dragging")
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == contentOffset() {
            self.scrollViewContentOffsetDidChange(change)


        }else if keyPath == dragging(){
            
        }
    }
    public func scrollViewContentOffsetDidChange(change:AnyObject?)->Void{
        if self.scrollView != nil {
            if (self.scrollView!.dragging) {
                
                //如果正在拖拽,就刷新一下状态
                if self.state != .Loading {
                    if self.scrollView?.contentOffset.y > -refreshHeight {
                        self.state = .PullDownToRefresh
                        self.titleLabel.text = pullDownToRefreshText
                        
                        
//                        if scrollView != nil {
//                            arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * ((self.scrollView!.contentOffset.y - 30) / (refreshHeight - 30)))
//                        }
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            self.arrowImageView.transform = CGAffineTransformMakeRotation(0)
                            }, completion: nil)
                        
                    }else{
                        self.state = .ReleaseToRefresh
                        self.titleLabel.text = releaseToRefreshText
                        
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                            }, completion: nil)
                        
                    }
                    
                    if lastUpdateDate != nil {
                        dateFormatter.dateFormat = dateStyle
                        timeLabel.text = "\(lastUpdateText)\(dateFormatter.stringFromDate(lastUpdateDate!))"
                    }
                    
                    
                }

            }else{
                if state == .ReleaseToRefresh {
                    self.state = .Loading
                    self.arrowImageView.hidden = true
                    self.titleLabel.text = loadingText
                    refreshBlock()
                    self.scrollView?.startRefresh()
                    activityIndicator.startAnimating()
                }


            }
        }
    }
    
    

}
private var refreshHeaderKey:Void?
extension UIScrollView{
    
    
    
    
    public var refreshHeader:RefreshHeader?{
        get{
            let r = objc_getAssociatedObject(self, &refreshHeaderKey)
            return r as? RefreshHeader

        }
        set{
            let header = self.refreshHeader
            if ((header?.superview) != nil) {
                header?.removeFromSuperview()
            }
            self.addSubview(newValue!)
            objc_setAssociatedObject(self, &refreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    

    // state 1.PullDownToRefresh 2.loading
    /*!
        下拉
     */
    public func startRefresh()->Void{
        
//        self.setContentOffset(CGPointMake(0, 0), animated: true)
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.contentInset = UIEdgeInsetsMake((self.refreshHeader?.refreshHeight)!, 0, 0, 0);
            self.refreshHeader?.alpha = 1.0
            }) { (finish) in
                
        }
        self.refreshHeader?.setNeedsDisplay()
    }
    
    /*!
        回收
     */
    public func finishRefresh()->Void{
        refreshHeader?.activityIndicator.stopAnimating()
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.contentOffset = CGPointMake(0, 0)
            
        }) { (finish) in
            self.refreshHeader?.arrowImageView.hidden = false
            self.refreshHeader?.arrowImageView.transform = CGAffineTransformIdentity
            self.refreshHeader?.state = .PullDownToRefresh
            self.refreshHeader?.lastUpdateDate = NSDate()
        }
    }
    
    
    
    
    
    
}
extension UITextView{
    public func selectAllText(){
        let range = self.textRangeFromPosition(self.beginningOfDocument, toPosition: self.endOfDocument)
        self.selectedTextRange = range
    }
}
extension UICollectionView{
    //------------------图片查看----------------
}
extension CALayer{
    //绘制截图
    public func snapShot() -> UIImage!{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0)
        let context = UIGraphicsGetCurrentContext()
        self.renderInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
    
    /*!
        暂停动画
     */
    public func pauseAnimation(){
        let pausedTime = self.convertTime(CACurrentMediaTime(), fromLayer: nil)
        self.speed = 0.0;
        self.timeOffset = pausedTime;
    }
    /*!
        继续动画
     */
    public func resumeAnimation(){
        let pausedTime = self.timeOffset
        
        self.speed = 1.0;
        self.timeOffset = 0.0;
        self.beginTime = 0.0;
        let timeSincePause = self.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        self.beginTime = timeSincePause;
        
        
    }
}
extension NSLayoutConstraint{
    
}

    
//CG Kit
extension CGRect{
    public var centerPoint:CGPoint{
        return CGPointMake(CGRectGetMidX(self), CGRectGetMinY(self))
    }
}


// MARK: - 附加类



/*!
 图片缩放类
 用于可缩放的图片查看
 */
public class ImageViewerView:UIView,UIScrollViewDelegate{
    let scrollView:UIScrollView
    let imageView:UIImageView
    public init(frame: CGRect,image:UIImage?) {
        scrollView = UIScrollView()
        imageView = UIImageView()
        super.init(frame: frame)
        scrollView.frame = bounds
        scrollView.maximumZoomScale = 4;
        scrollView.minimumZoomScale = 1;
        imageView.frame = bounds
        imageView.image = image
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
    }
    
    /*!
     重置缩放比
     //离开当前页的时候推荐调用
     */
    public func resetScale()->Void{
        scrollView.zoomScale = 1.0
    }
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?{
        return imageView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/*!
 用于屏幕上方的网络指示器
 */
public class WTNetworkActivityIndicatorManager{
    
    public static let sharedManager = WTNetworkActivityIndicatorManager()
    private var activityCount: Int = 0
    private var enabled: Bool = true
    init(){
        
    }
    public func incrementActivityCount() {
        activityCount += 1
        updateVisible()
    }
    public func decrementActivityCount() {
        activityCount -= 1
        updateVisible()
    }
    func updateVisible(){
        if enabled {
            if activityCount>0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }else{
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
}
#endif