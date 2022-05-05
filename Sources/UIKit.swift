//
//  UIKit.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/12.
//  Copyright © 2019 宋文通. All rights reserved.
//
import Foundation
#if canImport(UIKit)
import UIKit
#if canImport(Combine)
import Combine
#endif
import WebKit
//#if canImport(WebKit)
// MARK: - String
public extension String{
    ///create color from self(if hexstring)
    var hexColor:UIColor{
        return UIColor.colorWithHexString(self)
    }
    var hexInt32Number:UInt32{
        var int32:UInt32 = 0x0
        Scanner.init(string: self).scanHexInt32(&int32)
        return int32
    }
    var hexInt64Number:UInt64{
        var int64:UInt64 = 0x0
        Scanner.init(string: self).scanHexInt64(&int64)
        return int64
    }
    ///crrate CGColor from self(if hexstring)
    var hexCGColor:CGColor{
        return hexColor.cgColor
    }
    ///create UIImage from name
    var namedUIImage:UIImage?{
        return UIImage.init(named: self)
    }
    ///create UIImageView from name
    var namedUIImageView:UIImageView{
        return UIImageView.init(image: self.namedUIImage)
    }
    ///create uiimage from path
    var urlUIImageView:UIImageView{
        let img = UIImageView()
        img.loadImage(with: self)
        return img
    }
    ///create UIButton from name
    var namedUIButton:UIButton{
        let button = UIButton.customButton
        button.setImage(namedUIImage, for: .normal)
        return button
    }
    ///create UILabel
    var badagelabel:UILabel{
        let l = UILabel.init()
        l.text = self
        return l
    }
    ///return UITextField with text
    var textField:UITextField{
        let tf = UITextField()
        tf.text = self
        return tf
    }
    ///return UITextField with placeholder
    var placeHolderTextField:UITextField{
        let tf = UITextField()
        tf.placeholder = self
        return tf
    }
    ///return UITextView with text
    var textView:UITextView{
        let tv = UITextView()
        tv.text = self
        return tv
    }
    ///create UIButton system type
    var titledSystemButton:UIButton{
        let l = UIButton.init(type: .system)
        l.setTitle(self, for: .normal)
        return l
    }
    ///create UIButton custom type
    var titledCustomButton:UIButton{
        let l = UIButton.init(type: .custom)
        l.setTitle(self, for: .normal)
        return l
    }
    ///调用系统分享
    func shareInSystemFormat() {
        let vc = UIActivityViewController.init(activityItems: [self], applicationActivities: nil)
        UIViewController.topVC()?.present(vc, animated: true)
    }
}
public extension UIScreen{
    class var mainScreenBounds:CGRect {
        return UIScreen.main.bounds
    }
    class var mainScreenSize:CGSize {
        return mainScreenBounds.size
    }
    class var mainScreenWidth:CGFloat {
        return mainScreenSize.width
    }
    class var mainScreenHeight:CGFloat {
        return mainScreenSize.height
    }
}

public extension UIDevice{
    static var isSimulator:Bool{
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    /// 可用内存空间，注：内存是一个动态分配的数据，可用内存是一个动态的概念
    /// 直接用这个数据并不一定是想要的数据
    static var freeMemoryInMib:Int64{
        var pagesize: vm_size_t = 0
        
        let host_port: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        host_page_size(host_port, &pagesize)
        
        var vm_stat: vm_statistics = vm_statistics_data_t()
        withUnsafeMutablePointer(to: &vm_stat) { (vmStatPointer) -> Void in
            vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                if (host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS) {
                    NSLog("Error: Failed to fetch vm statistics")
                }
            }
        }
        
        /* Stats in bytes */
        //        let mem_used: Int64 = Int64(vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * Int64(pagesize)
        //free_count   空余内存
        //purgeable_count 可清除内存
        //speculative_count 投机内存
        let mem_free: Int64 = Int64(vm_stat.free_count + vm_stat.purgeable_count - vm_stat.speculative_count) * Int64(pagesize)
        
        return mem_free
    }
}
// MARK: - UIColor
public extension UIColor{
    static var color3:UIColor{
        return "3".hexColor
    }
    static var color6:UIColor{
        return "6".hexColor
    }
    static var color9:UIColor{
        return "9".hexColor
    }
    
    //    func randomColor() -> UIColor {
    //        UIColor.init(red: CGFloat.random(in: ClosedRange.i), green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    //    }
    func createImage(with size:CGSize) -> UIImage? {
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer.init(size: size)
            let img = render.image { context in
                self.setFill()
                context.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
            }
            return img
        } else {
            // Fallback on earlier versions
            let rect = CGRect(origin: .zero, size: size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            setFill()
            UIRectFill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    class func colorWithHexString(_ string:String, alpha:CGFloat = 1.0, defaultColor:UIColor = .red) -> UIColor{
        let mutableCharSet = "".mutableCharacterSet
        mutableCharSet.addCharacters(in: "#")
        mutableCharSet.formUnion(with: CharacterSet.whitespaces);
        let hString:String = string.trimmingCharacters(in: mutableCharSet as CharacterSet)
        switch hString.count {
        case 0:
            return defaultColor;
        case 1:
            return UIColor.colorWithHexString(hString+hString);
        case 2:
            return UIColor.colorWithHexString(hString+hString+hString);
        case 6:
            let rIndex = hString.index(hString.startIndex, offsetBy: 2)
            let gIndex = hString.index(rIndex, offsetBy: 2)
            let bIndex = hString.index(gIndex, offsetBy: 2)
            let r = String.init(hString[..<rIndex])
            let g = String.init(hString[rIndex..<gIndex])
            let b = String.init(hString[gIndex..<bIndex])
            let rInt:UInt32 = r.hexInt32Number
            let gInt:UInt32 = g.hexInt32Number
            let bInt:UInt32 = b.hexInt32Number
            let red = CGFloat(rInt)/255.0
            let green = CGFloat(gInt)/255.0
            let blue = CGFloat(bInt)/255.0
            //            WTLog("\(red) \(green) \(blue)")
            let color = UIColor(red: red, green: green, blue: blue,alpha: alpha)
            return color;
        default:
            return defaultColor;
        }
    }
}
// MARK: - UIViewController
public extension UIViewController{
    func printAppear() {
        //you can use this print to check appearing VC
        print("📱----->will Appear:----->\(self)")
    }
    /**
     在控制器链中获取当前顶部控制器
     获取顶部控制器的方案既适用于简单结构,比如常见的
     UIWindow---> UITabBarController ---> [UINavigationController] ---> [UIViewController]
     或者
     UIWindow---> UINavigationController ---> [UIViewController]
    
     也适用于复杂结构
     UIWindow ---> UITabBarController ---> UINavigationController ---> UIViewController  ---> present --->  UINavigationController ---> UIViewController
     和这种复杂结构
     UIWindow ---> UIViewController ---> present ---> UIViewController ---> present ---> UIViewController
     和以上所有结构的混合结构
     */
    static func topVC()->UIViewController? {
        return UIApplication.rootViewController?.topVC()
    }
    
    ///获取顶部控制器，不需要直接用,用静态方法就行了
    fileprivate func topVC() -> UIViewController {
        if let vc = presentedViewController{
            return vc.topVC()
        }
        return self
    }
    
    ///检测导航器来push
    func requestPushToTopVC() {
        UIViewController.topVC()?.navigationController?.pushViewController(self, animated: true)
    }
    ///检测顶部控制器来push
    func requestTopVCPresent( animated flag: Bool, completion: (() -> Void)? = nil) {
        UIViewController.topVC()?.present(self, animated: flag, completion: completion)
    }

}

public extension UITableViewController{}

public extension UIPageViewController{
//    fileprivate func topVC() -> UIViewController {
//        
//    }
//    
}

public extension UICollectionViewController{}

public extension UIAlertController{}

public extension UITextField{
    var safeText:String{
        get{
            return text ?? ""
        }
    }
}

public extension UITextView{
}

public extension UILabel{
    @IBInspectable var adjustFont:Bool{
        get{
            return self.adjustsFontSizeToFitWidth
        }
        set{
            self.adjustsFontSizeToFitWidth = newValue
        }
    }
}
public extension CGFloat{
    
}
public extension UIView {
    func removeAllSubviews() {
        let subviews:[UIView] = self.subviews
        for v in subviews{
            v.removeFromSuperview()
        }
    }
    func removeAllSubViewsConstraints(){
        for v in subviews{
            v.removelAllConstraints()
            v.removeAllSubViewsConstraints()
        }
    }
    func removelAllConstraints() {
        removeConstraints(constraints)
    }
    func addSubviews(_ views: [UIView]) {
        for v in views{
            addSubview(v)
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor?{
        get {
            return layer.borderColor?.uiColor
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    /**
     4个方向可选圆角
     左上角的话用UIRectCorner.topLeft
     左上角+右下角的话用[UIRectCorner.topLeft,UIRectCorner.bottomRight]
     */
    func cornerRadiusBy(corners: UIRectCorner, cornerRadii:CGFloat) {
        let path = UIBezierPath(roundedRect:bounds,
                                byRoundingCorners:corners,
                                cornerRadii: CGSize(width: cornerRadii, height:  cornerRadii))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    func addSubViewAndTurnOffMask(_ view: UIView) {
        addSubview(view)
        view.turnOffMask()
    }
    func turnOffMask()  {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func snapShotImage() -> UIImage {
        return layer.snapShot()
    }
    func addShapLayer(with cornerRadius:CGFloat) {
        let sl = CAShapeLayer.init()
        sl.fillColor = nil
        sl.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        sl.frame = self.bounds
        sl.strokeColor = UIColor.clear.cgColor
        sl.lineWidth = cornerRadius * 2.0
        self.layer.mask = sl
    }
    
    @discardableResult
    func maskView(with cornerRadius:CGFloat) -> UIView {
        let v = UIView.init(frame: bounds)
        v.cornerRadius = cornerRadius
        self.mask = v
        return v
    }
    
}

public extension UIActivityViewController{
    static func shareItems(with activityItems:[Any]){
        let vc = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
        vc.requestTopVCPresent(animated: true)
    }
}
// MARK: CALayer
public extension CALayer{
    func removeAllSubLayers() {
        guard let sublayers:[CALayer] = self.sublayers else{
            return
        }
        for l in sublayers{
            l.removeFromSuperlayer()
        }
    }
    ///截图
    func snapShot() -> UIImage {
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer.init(size: self.bounds.size)
            return render.image { [weak self](context) in
                self?.render(in: context.cgContext)
            }
        } else {
            // Fallback on earlier versions
            if let context = UIGraphicsGetCurrentContext(){
                UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
                render(in: context)
                if let image = UIGraphicsGetImageFromCurrentImageContext(){
                    UIGraphicsEndImageContext()
                    return image
                }else{
                    return UIImage()
                }
            }else{
                return UIImage()
            }
        }
    }
    func pause() {
        /*
         timeOffset用于动画延时
         speed用于动画速度
         */
        //拿到暂停的时间
        let pausedTime = convertTime(CACurrentMediaTime(), to: nil)
        //暂停动画
        speed = 0
        //设置延时时间
        timeOffset = pausedTime
    }
    func resume() {
        //拿到延时的时间
        let pausedTime = timeOffset
        //速度恢复
        speed = 1
        //延时设置为0
        timeOffset = 0
        //开始时间设置为0
        beginTime = 0
        //从暂停到现在的时间 = 当前时间 - 暂停时间
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        //设置开始时间
        beginTime = timeSincePause
    }
}

public extension CGColor{
    var uiColor:UIColor{
        return UIColor.init(cgColor: self)
    }
}
public extension CGRect{
    
}
public extension CGPoint{
    func distance(from point: CGPoint) -> CGFloat {
        return CGPoint.distance(from: self, p2: point)
    }
    static func distance(from p1:CGPoint, p2:CGPoint) -> CGFloat {
        let a = p1.x - p2.x
        let b = p1.y - p2.y
        let c_c = a * a + b * b
        return c_c.squareRoot()
    }
    func addNewPoint(with p:CGPoint) -> CGPoint {
        return CGPoint.init(x: x+p.x, y: y+p.y)
    }
}

private class EmptyModel: Codable {
    var a:Int
}
extension Data{
    var uiImage:UIImage?{
        UIImage.init(data: self, scale: UIScreen.main.scale)
    }
    var cgImage:CGImage?{
        uiImage?.cgImage
    }
}

private enum AssociatedKeys {
    static var imageURL = "UIImageView.wt.loadingURL"
    static var downloadTask = "UIImageView.wt.downloadTask"
    static var loadingURLOfBG = "UIButton.wt.loadingURLOfBG"
}

// MARK: - UIImageView
public extension UIImageView{
    
    ///  用于保存加载图片的路径，在重用中路径可能会反复更新，回掉是一个异步返回
    ///  如果不保存url的话，回掉的可能不是预期的数据
    var loadingURL: URL? {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.imageURL)
            return value as? URL
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.imageURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 保存下载的task
    var loadingTask:URLSessionDataTask? {
        get{
            let v = objc_getAssociatedObject(self, &AssociatedKeys.downloadTask)
            return v as? URLSessionDataTask
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.downloadTask, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
#if canImport(Combine)
    private func testingCombine(){
        if #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            let _ = URLSession.default.dataTaskPublisher(for: "https://www.apple.com".urlValue).map { (data,res) -> UIImage? in
                return data.uiImage
            }.receive(on: RunLoop.main).sink(receiveCompletion: { (err) in
                dprint("error:\(err)")
            }) { (img) in
                self.image = img
            }
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    func setImageName(with name:String) {
        image = name.namedUIImage
    }
    func loadImage(with path:String) {
        self.image = nil
        loadingURL = path.urlValue
        loadingTask?.cancel()
        let task = UIImage.loadImage(with: path) {[weak self] img in
            if self?.loadingURL != path.urlValue{
                return
            }
            
            img.decodedImage(with: self?.frame.size ?? .zero, callBack: { [weak self] image in
                self?.image = image
                self?.layoutIfNeeded()
            })
        } error: { err in
        }
        loadingTask = task
    }
    func setResizableImage(with image:UIImage, withCapInsets: UIEdgeInsets = .zero, resizingMode:UIImage.ResizingMode = .tile) {
        self.image = image.resizableImage(withCapInsets: withCapInsets, resizingMode: resizingMode)
    }
}
// MARK: - UIButton
public extension UIButton{
    ///  用于保存加载图片的路径，在重用中路径可能会反复更新，回掉是一个异步返回
    ///  如果不保存url的话，回掉的可能不是预期的数据
    var loadingURL: URL? {
        get {
            let value = objc_getAssociatedObject(UIButton.self, &AssociatedKeys.imageURL)
            return value as? URL
        }
        set {
            objc_setAssociatedObject(UIButton.self, &AssociatedKeys.imageURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var loadingURLOfBG: URL? {
        get {
            let value = objc_getAssociatedObject(UIButton.self, &AssociatedKeys.loadingURLOfBG)
            return value as? URL
        }
        set {
            objc_setAssociatedObject(UIButton.self, &AssociatedKeys.loadingURLOfBG, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    static var systemButton:UIButton{
        return .init(type: .system)
    }
    static var customButton:UIButton{
        return .init(type: .custom)
    }
    func setImage(with path:String, for state: UIControl.State = .normal){
        loadingURLOfBG = path.urlValue
        UIImage.loadImage(with: path) { [weak self]image in
            if self?.loadingURL != path.urlValue{
                return
            }
            image.decodedImage(with: self?.frame.size ?? .zero) { [weak self] img in
                self?.setImage(img, for: state)
                self?.layoutIfNeeded()
            }
        } error: { err in
            
        }
    }
    func setBackGroundImage(with path:String, for state: UIControl.State = .normal ){
        loadingURLOfBG = path.urlValue
        UIImage.loadImage(with: path) {[weak self] image in
            if self?.loadingURLOfBG != path.urlValue{
                return
            }
            image.decodedImage(with: self?.frame.size ?? .zero) {[weak self] img in
                self?.setBackgroundImage(image, for: state)
                self?.layoutIfNeeded()
            }
        } error: { err in
            
        }
    }
}
public extension UITabBarController{
    ///不需要直接使用
    fileprivate func topVC() -> UIViewController? {
        return selectedViewController?.topVC()
    }
    var topNavigationController:UINavigationController?{
        if let navi = selectedViewController as? UINavigationController{
            return navi
        }
        return nil
    }
}
public extension UINavigationController{
    ///不需要直接使用
    fileprivate func topVC() -> UIViewController? {
        return topViewController?.topVC()
    }
}
// MARK: - UIApplication
public extension UIApplication{
    class func buildVersion()->String{
        Bundle.buildVersion()
    }
    static func appVersion()->String{
        Bundle.appVersion()
    }
    @available(iOS 13.0, *)
    static func appendNewWindow<T:UIWindow>() -> T? {
        let sceneList = UIApplication.shared.connectedScenes.compactMap { (s:UIScene) -> UIWindowScene? in
            if let s2 = s as? UIWindowScene{
                return s2
            }
            return nil
        }
        guard let first = sceneList.first else{
            return nil
        }
        let win = T.init(windowScene: first)
        win.windowLevel = UIWindow.Level.statusBar + 1
        win.backgroundColor = UIColor.clear
        win.frame = UIScreen.mainScreenBounds
        win.rootViewController = UIViewController()
        win.makeKeyAndVisible()
        return win
    }
    static var rootViewController:UIViewController?{
        return UIApplication.shared.keyWindow?.rootViewController
    }
    func findKeyWindow() -> UIWindow? {
        windows.filter { window in
            if window.isKeyWindow{
                return true
            }
            return false
        }.first
    }
}

@available(iOS 10.0, *)

public extension UIGraphicsRenderer{
    
}
@available(iOS 10.0, *)
public extension UIGraphicsImageRenderer{
}

public extension CGContext{
    
}
// MARK: - UIImage
public extension UIImage{
    func imageButton() -> UIButton {
        let b = UIButton.customButton
        b.setImage(self, for: .normal)
        return b
    }
    var imageView:UIImageView{
        UIImageView.init(image: self)
    }
    func applyImage(to imageView:UIImageView) {
        imageView.image = self
    }
    /// 绘制为小型的图
    func downSize(with size:CGSize)->UIImage{
        if #available(iOS 10.0, *) {
            let imageRenderer = UIGraphicsImageRenderer.init(size: size)
            let image = imageRenderer.image { (context:UIGraphicsImageRendererContext) in
                let cgContext = context.cgContext
                cgContext.scaleBy(x: 1.0, y: -1.0)
                cgContext.translateBy(x: 0, y: -size.height)
                guard let cgImage = cgImage else{
                    return
                }
                cgContext.draw(cgImage, in: CGRect.init(origin: .zero, size: size))
            }
            return image
        }else{
            UIGraphicsBeginImageContext(size)
            guard let cgContext = UIGraphicsGetCurrentContext() else{
                return self
            }
            cgContext.scaleBy(x: 1.0, y: -1.0)
            cgContext.translateBy(x: 0, y: -size.height)
            guard let cgImage = cgImage else{
                return self
            }
            cgContext.draw(cgImage, in: CGRect.init(origin: .zero, size: size))
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else{
                return self
            }
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    /**
     decode image to bitmap using UIGraphicsImageRenderer,
     loading one image may need 0.015s or more,using global dispatch queue
     can improve main thread performance
     */
    func decodedImage(with size:CGSize, callBack:@escaping ((UIImage)->Void)) {
        DispatchQueue.global().async {
            let img = self.downSize(with: size)
            DispatchQueue.safeAsyncInMain {
                callBack(img)
            }
        }
    }
    
    /**
     draw an new image with corner radius.
     */
    func convertToCornerImage(_ cornerRadius:CGFloat = 5) -> UIImage {
        let iv = UIImageView.init(image: self)
        iv.frame = CGRect.init(origin: .zero, size: self.size)
        iv.layer.cornerRadius = cornerRadius
        iv.layer.masksToBounds = true
        return iv.snapShotImage()
    }
    /*
     load image
     */
    @discardableResult
    static func loadImage(with path:String, image:@escaping(UIImage)->Void , error:@escaping(Error)->Void) -> URLSessionDataTask{
        let task = URLSession.default.useCacheElseLoadURLData(with: path.urlValue) { data, res, err in
            guard let data = data else{
                if let err = err{
                    error(err)
                }else{
                    //todo no data
                }
                return
            }
            guard let img = UIImage.init(data: data) else{
                //todo data can't create image
//                error()
                return
            }
            image(img)
        }
        return task
    }
    /**
     prefetch image
     */
    static func prefetchImage(with url:String){
        loadImage(with:url) { img in
            
        } error: { err in
            
        }
        
    }
    ///get a color at position
    func getPixelColor(pos: CGPoint) -> UIColor? {
        let rect = CGRect.init(origin: .zero, size: self.size)
        guard rect.contains(pos) else{
            return nil
        }
        guard let cgImage = self.cgImage else{
            return nil
        }
        guard let dataProvider = cgImage.dataProvider else {
            return nil
        }
        guard let pixelData:CFData = dataProvider.data else{
            return nil
        }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        //        let bitsPerPixel = cgImage.bitsPerPixel
        
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

public extension UIResponder{
    
}


// MARK: - UIScrollView
public extension UIScrollView {
    /// SwifterSwift: Takes a snapshot of an entire ScrollView
    ///
    ///    AnySubclassOfUIScroolView().snapshot
    ///    UITableView().snapshot
    ///
    /// - Returns: Snapshot as UIimage for rendered ScrollView
    var snapshot: UIImage? {
        // Original Source: https://gist.github.com/thestoics/1204051
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        //defer 延时到return之后执行
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = frame
        frame = CGRect(origin: frame.origin, size: contentSize)
        layer.render(in: context)
        frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
// MARK: - IB
public extension UIView{
    ///获取当前view的nib文件
    ///注意:class和nib文件必须同名
    static func nib() -> UINib {
        //这段代码的神奇之处是到了这里已经无法打印self了，报错内容是：error: <EXPR>:1:11: error: use of undeclared type '$__lldb_context'
        return UINib.init(nibName: self.reuseIdentifier, bundle: nil)
    }
    ///重用ID
    static var reuseIdentifier: String{
        return "\(self)"
    }
    static func instanceFromXib() -> UIView?{
        for ele in nib().instantiate(withOwner: nil, options: nil){
            if let obj = ele as? UIView{
                return obj
            }
        }
        return nil
    }
}
public extension UIViewController{
    ///重用ID
    static var reuseIdentifier: String{
        return "\(self)"
    }
    ///获取当前view的nib文件
    ///注意:class和nib文件必须同名
    static func nib() -> UINib {
        //这段代码的神奇之处是到了这里已经无法打印self了，报错内容是：error: <EXPR>:1:11: error: use of undeclared type '$__lldb_context'
        return UINib.init(nibName: self.reuseIdentifier, bundle: nil)
    }
    static func storyboard() -> UIStoryboard{
        return UIStoryboard.init(name: reuseIdentifier, bundle: nil)
    }
    
    /// 从同名的storyboardc文件中取到根控制器的实例
    static func instanceFromStoryBoard() -> UIViewController? {
        storyboard().instantiateInitialViewController()
    }
    static func instanceFromNib() -> UIViewController?{
        for ele in nib().instantiate(withOwner: nil, options: nil){
            if let obj = ele as? UIViewController{
                return obj
            }
        }
        return nil
    }
}

public extension UITableViewCell{
    
}

public extension UICollectionViewCell{
    
}

public extension UIWindow{
    
}
public extension Bundle{
    ///load file from UINib,if you want to use class from,please use UITableViewCell subclass to avoid file's owner issue
    func loadViewFromNibFile<T:UIView>(with type:T.Type) -> T? {
        guard let list = loadNibNamed(T.reuseIdentifier, owner: nil, options: nil) else{
            return nil
        }
        for ele in list{
            if let o = ele as? T{
                return o
            }
        }
        return nil
    }
    ///从本bundle中读取图片文件
    func loadImageWith(name str:String) -> UIImage?{
        if #available(iOS 13.0, *) {
            return UIImage.init(named: str, in: self, with: nil)
        } else {
            return UIImage.init(named: str, in: self, compatibleWith: nil)
        }
    }
    
    ///load 本地数据
    func loadData(with name:String?, ofType:String?, completionHandler: @escaping (Data?) -> Void) {
        let path = path(forResource: name, ofType: ofType)
        guard let path = path else{
            completionHandler(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: path.urlValue) { d, u, e in
            DispatchQueue.main.async {
                completionHandler(d)
            }
        }
        task.resume()
    }
}

@available(iOS 13.0, *)
public extension UIWindowScene{
}
// MARK: - NSAttributedString
public extension NSAttributedString{
    /**
     根据给出的宽度来计算文本的高度
     */
    @available(iOS 6.0, *)
    func heightForWidth(with width:CGFloat) -> CGFloat {
        let rect = boundingRect(with: CGSize.init(width: width, height: 1000),options: [.usesLineFragmentOrigin], context: nil)
        return ceil(rect.height)
    }
    
    ///将一个NSAttributedString异步绘制为一个CALayer,耗时大约为0.1-0.2秒左右
    @available(iOS 10.0, *)
    func layerForWidth(with width:CGFloat, callBack:@escaping (CALayer)->Void){
        DispatchQueue.global().async {
            let layer = CALayer.init()
            let height = self.heightForWidth(with: width)
            let size = CGSize.init(width: width, height: height)
            let render = UIGraphicsImageRenderer.init(size: size)
            let frame = CGRect.init(origin: .zero, size: size)
            let image = render.image { (imageRender:UIGraphicsImageRendererContext) in
                let cgContext = imageRender.cgContext
                UIGraphicsPushContext(cgContext)
                self.draw(with: frame, options: [.usesLineFragmentOrigin], context: nil)
                UIGraphicsPopContext()
            }
            layer.contents = image.cgImage
            layer.frame = frame
            DispatchQueue.main.async {
                callBack(layer)
            }
        }
    }
}

///图片body
open class MultiPartBodyImage:MultipartBodyObject{
    open var image:UIImage? = nil{
        didSet{
            updateDataAndContentType()
        }
    }
    public override init() {
        super.init()
    }
    func updateDataAndContentType(){
        guard let img = image else{
            return
        }
        if let pngData = img.pngData() {
            contentType = "image/png"
            data = pngData
        }
        if let jpgData = img.jpegData(compressionQuality: 1){
            contentType = "image/jpeg"
            data = jpgData
        }
    }
}

/**
 CAGradientLayer的封装
 example
 layer.colors = [UIColor(red: 0.32, green: 0.77, blue: 0.93, alpha: 1).cgColor, UIColor(red: 0.21, green: 0.46, blue: 0.96, alpha: 1).cgColor]
 layer.locations = [0, 1]
 layer.startPoint = CGPoint(x: 0, y: 0.5)
 layer.endPoint = CGPoint(x: 1, y: 0.5)
 */
open class WTGradientView:UIView{
    override open class var layerClass: AnyClass{
        return CAGradientLayer.self
    }
    var gradientLayer:CAGradientLayer{
        return layer as! CAGradientLayer
    }
    open var colors: [Any]?{
        didSet{
            gradientLayer.colors = colors
        }
    }
    
    open var locations: [NSNumber]?{
        didSet{
            gradientLayer.locations = locations
        }
    }
    
    open var startPoint: CGPoint{
        get{
            return gradientLayer.startPoint
        }
        set{
            gradientLayer.startPoint = newValue
        }
        
    }
    
    open var endPoint: CGPoint{
        get{
            return gradientLayer.endPoint
        }
        set{
            gradientLayer.endPoint = newValue
        }
    }
    
    open var type: CAGradientLayerType{
        get{
            return gradientLayer.type
        }
        set{
            gradientLayer.type = newValue
        }
    }
}

open class AlignLeftFlowLayout: UICollectionViewFlowLayout {
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}

// MARK: - WTUINavigationController
open class WTUINavigationController:UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printAppear()
    }
    /*
     func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning{
     return self
     }
     func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
     return 0.25
     }
     func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
     
     }
     */
}

/**
 自制TabBar
 */
open class WTTabBar : UIView{
    
}
// MARK: - WTVC
///控制器状态
public enum VCStatus{
    ///无操作
    case idle
    ///请求数据
    case loading
    ///无数据
    case noData
    ///网络异常
    case networkError
}
/**
  这个控制器主要的功能是自制导航栏
 */
open class WTVC:UIViewController{
    open var status:VCStatus = .idle{
        didSet{
            updateToStatus()
        }
    }
    open var wtHeaderView:UIView = UIView()
    open var wtBottomAnchor:NSLayoutConstraint? = nil
    public static var wtDefaultHeaderBGColor:UIColor = "f8fafc".hexColor
    open var wtSeparateLine:UIView = UIView()
    open var wtBackButton:UIButton = UIButton.init(type: .custom)
    open var wtBackIconImageView:UIImageView = UIImageView()
    open var wtBackButtonLabel:UILabel = UILabel()
    open var wtTitleLabel:UILabel = UILabel.init()
    /// 静态变量，用于保存返回按钮地址
    public static var wtBackButtonURL:String = "https://songwentong.github.io/projects/WTKit/backbutton.png"
    public static var wtBackButtonImage:UIImage? = nil
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func loadView() {
        super.loadView()
        configMyHeaderView()
    }
    func configMyHeaderView() {
        view.addSubview(wtHeaderView)
        wtHeaderView.turnOffMask()
        wtHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        wtHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        wtHeaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        wtHeaderView.clipsToBounds = false
        if #available(iOS 11.0, *) {
            wtBottomAnchor = wtHeaderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ,constant: 44)
        } else {
            wtBottomAnchor = wtHeaderView.bottomAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor ,constant: 44)
        }
        wtBottomAnchor?.isActive = true
        wtHeaderView.backgroundColor = WTVC.wtDefaultHeaderBGColor
        
        wtHeaderView.addSubview(wtSeparateLine)
        wtSeparateLine.turnOffMask()
        wtSeparateLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        wtSeparateLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        wtSeparateLine.bottomAnchor.constraint(equalTo: wtHeaderView.bottomAnchor).isActive = true
        wtSeparateLine.heightAnchor.constraint(equalToConstant: 0.33).isActive = true
        wtSeparateLine.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        
        wtHeaderView.addSubview(wtBackButton)
        wtBackButton.turnOffMask()
        wtBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        wtBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        wtBackButton.bottomAnchor.constraint(equalTo: wtHeaderView.bottomAnchor, constant: 0).isActive = true
        wtBackButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 69).isActive = true
        
        
        //        wtBackButton.setTitle("Back", for: .normal)
        wtBackButton.addTarget(self, action: #selector(wtBackButtonPressed), for: .touchUpInside)
        wtBackButton.addTarget(self, action: #selector(wtBackButtonEvents), for: .allEvents)
        wtBackButton.addSubview(wtBackIconImageView)
        wtBackIconImageView.turnOffMask()
        //   size 37   63
        // 37/3 =   12.3
        // 63/3 = 21
        // bottom = (44-21)/2 = 11.5
        //12 centerY  13 21
        //
        wtBackIconImageView.leadingAnchor.constraint(equalTo: wtBackButton.leadingAnchor, constant: 12).isActive = true
        wtBackIconImageView.bottomAnchor.constraint(equalTo: wtBackButton.bottomAnchor, constant: -11.5).isActive = true
        wtBackIconImageView.widthAnchor.constraint(equalToConstant: 12.3).isActive = true
        wtBackIconImageView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        wtBackIconImageView.contentMode = .scaleAspectFill
        wtBackIconImageView.image = WTVC.wtBackButtonImage
        wtBackIconImageView.loadImage(with: WTVC.wtBackButtonURL)

        wtBackButton.addSubview(wtBackButtonLabel)
        wtBackButtonLabel.turnOffMask()
        wtBackButtonLabel.leadingAnchor.constraint(equalTo: wtBackIconImageView.trailingAnchor, constant: 6).isActive = true
        wtBackButtonLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        wtBackButtonLabel.bottomAnchor.constraint(equalTo: wtBackButton.bottomAnchor, constant: 0).isActive = true
        wtBackButtonLabel.trailingAnchor.constraint(equalTo: wtBackButton.trailingAnchor, constant: 0).isActive = true
        wtBackButtonLabel.text = "Back"
        wtBackButtonLabel.textColor = "0077fa".hexColor
        
        wtHeaderView.addSubview(wtTitleLabel)
        wtTitleLabel.turnOffMask()
        wtTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        wtTitleLabel.textAlignment = .center
        wtTitleLabel.centerXAnchor.constraint(equalTo: wtHeaderView.centerXAnchor, constant: 0).isActive = true
        //view.safeAreaLayoutGuide.topAnchor
        var titleTop = topLayoutGuide.topAnchor
        if #available(iOS 11.0, *) {
            titleTop = view.safeAreaLayoutGuide.topAnchor
        } else {
        }
        wtTitleLabel.topAnchor.constraint(equalTo: titleTop).isActive = true
        wtTitleLabel.bottomAnchor.constraint(equalTo: wtHeaderView.bottomAnchor, constant: 0).isActive = true
        wtTitleLabel.text = title
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printAppear()
        if navigationController?.viewControllers.first == self{
            wtBackButton.isHidden = true
        }else{
            wtBackButton.isHidden = false
        }
    }
    open func updateToStatus() {
        
    }
    @objc func wtBackButtonEvents(){
        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            if self.wtBackButton.isHighlighted{
                self.wtBackButtonLabel.alpha = 0.2
                self.wtBackIconImageView.alpha = 0.2
            }else{
                self.wtBackButtonLabel.alpha = 1.0
                self.wtBackIconImageView.alpha = 1.0
            }
        }) { (flag) in
            
        }
    }
    @objc func wtBackButtonPressed() {
        guard let count = navigationController?.viewControllers.count else{
            return
        }
        guard count >= 2 else {
            return
        }
        navigationController?.popViewController(animated: true)
    }
    @IBInspectable var titleBarHeight:CGFloat{
        set{
            wtBottomAnchor?.constant = newValue
        }
        get{
            return wtBottomAnchor?.constant ?? 0
        }
    }
    @IBInspectable var titleBarColor:UIColor?{
        set{
            wtHeaderView.backgroundColor = newValue
        }
        get{
            return wtHeaderView.backgroundColor
        }
    }
}
///所有的Int，包含Uint和各种Int8/Int16/Int32/Int64的扩展
public extension BinaryInteger{
    var cgFloatValue:CGFloat{
        return CGFloat.init(self)
    }
}
public extension BinaryFloatingPoint{
    var cgFloatValue:CGFloat{
        return CGFloat.init(self)
    }
}
// MARK: - WTTableVC
/**
 自制tableview
 */
open class WTTableVC:WTVC{
    open var myTableView:UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        if #available(iOS 10.0, *) {
            table.refreshControl = UIRefreshControl.init()
        } else {
            
        }
        return table
    }()
    open override func loadView() {
        super.loadView()
        view.addSubview(myTableView)
        myTableView.turnOffMask()
        myTableView.topAnchor.constraint(equalTo: wtHeaderView.bottomAnchor, constant: 0).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
}
public extension CGImage{
    var toUIImage:UIImage{
        UIImage.init(cgImage: self)
    }
    ///testing method
    var to8Bit:CGImage{
        guard let colorSpace = colorSpace else{
            return self
        }
        guard let context = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else{
            return self
        }
        let imgV = UIImageView.init(image: UIImage.init(cgImage: self))
        imgV.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        UIGraphicsPushContext(context)
        imgV.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else{
            UIGraphicsEndImageContext()
            return self
        }
        UIGraphicsEndImageContext()
        guard let cg = image.cgImage else{
            return self
        }
        return cg
    }
}
public class WTView:UIView{
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
#if canImport(Combine)
//iOS 13+
#endif
#else
#endif
#if compiler(>=5)
#endif
