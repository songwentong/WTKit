//
//  UIKit.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/12.
//  Copyright © 2019 宋文通. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit
public extension UIScreen{
    class func mainScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    class func mainScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
}
public extension UIDevice{
    static func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #endif
        return false
    }
}
public extension UIColor{
    //    func randomColor() -> UIColor {
    //        UIColor.init(red: CGFloat.random(in: ClosedRange.i), green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    //    }
    func createImage(with size:CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    class func colorWithHexString(_ string:String, alpha:CGFloat = 1.0, defaultColor:UIColor = .red) -> UIColor{
        //        let s = NSScanner(string: string)
        let mutableCharSet = NSMutableCharacterSet()
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
                var rInt:UInt32 = 0x0,gInt:UInt32 = 0x0,bInt:UInt32 = 0x0
                
                Scanner.init(string: r).scanHexInt32(&rInt)
                Scanner.init(string: g).scanHexInt32(&gInt)
                Scanner.init(string: b).scanHexInt32(&bInt)
                
                let red = CGFloat(rInt)/255.0
                let green = CGFloat(gInt)/255.0
                let blue = CGFloat(bInt)/255.0
                //            WTLog("\(red) \(green) \(blue)")
                let color = UIColor(red: red, green: green, blue: blue,alpha: alpha)
                return color;
            default:
                return UIColor.red;
        }
    }
}
public extension UIViewController{
    func requestPushToTopVC() { UIApplication.topViewController?.navigationController?.pushViewController(self, animated: true)
    }
    func requestTopVCPresent( animated flag: Bool, completion: (() -> Void)? = nil) {
        //    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil)
        UIApplication.topViewController?.present(self, animated: flag, completion: completion)
    }
    static func instanceFromStoryBoard<T:UIViewController>() -> T {
        guard let _ = Bundle.main.path(forResource: "\(self)", ofType: "storyboardc") else{
            print("storyboradc file not found class:\(self)")
            return T.init()
        }
        let sb = UIStoryboard.init(name: "\(self)", bundle: nil)
        if let vc = sb.instantiateInitialViewController() as? T{
            return vc
        }else{
            return T.init()
        }
    }
    static func instanceFromNib<T:UIViewController>() -> T{
        guard let _ = Bundle.main.path(forResource: "\(self)", ofType: "nib") else{
            print("nib file not found class:\(self)")
            return T.init()
        }
        let nib = UINib.init(nibName: "\(self)", bundle: nil)
        for ele in nib.instantiate(withOwner: nil, options: nil){
            if let obj = ele as? T{
                return obj
            }
        }
        return T.init()
    }
}
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
public extension UIView{
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
            return layer.borderColor?.convertToUIColor()
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    func turnOffMask()  {
        translatesAutoresizingMaskIntoConstraints = false
    }
    func loadReuseableNibContentView() {
        let view = instanceFromXibWithOwner()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    func instanceFromXibWithOwner<T:UIView>() -> T{
        let res = "\(self.classForCoder)"
        let bundle = Bundle.init(for: type(of: self))
        guard let path = Bundle.main.path(forResource: res, ofType: "nib") else{
            print("nib file not found")
            return T.init()
        }
        print("load file :\(path)")
        let nib = UINib.init(nibName: res, bundle: bundle)
        for ele in nib.instantiate(withOwner: self, options: nil){
            if let obj = ele as? T{
                return obj
            }
        }
        return T.init()
    }
    static func instanceFromXib<T:UIView>() -> T{
        let res = "\(self)"
        guard let _ = Bundle.main.path(forResource: res, ofType: "nib") else{
            print("nib file not found")
            return T.init()
        }
        let nib = UINib.init(nibName: "\(self)", bundle: nil)
        for ele in nib.instantiate(withOwner: nil, options: nil){
            if let obj = ele as? T{
                return obj
            }
        }
        return T.init()
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
}

public extension CALayer{
    func snapShot() -> UIImage {
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer.init(size: self.bounds.size)
            return render.image { [weak self](context) in
                self?.render(in: context.cgContext)
            }
        } else {
            // Fallback on earlier versions
            UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
            render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
}
public extension CGColor{
    func convertToUIColor() -> UIColor {
        return UIColor.init(cgColor: self)
    }
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
}

class GlobalImageLoadCache {
    var loadingURL:Set<String> = []
    var loadingPairs:[Int:String] = [:]
    static let shared:GlobalImageLoadCache = {
        return GlobalImageLoadCache.init()
    }()
}
public extension NSObject{
    //    func removeImageLoadNotificaion() {
    //    }
}
public extension UIImageView{
    func loadImage(with path:String) {
        self.image = nil
        let size = self.frame.size
        NotificationCenter.default.addObserver(forName: UIImage.ImageLoadFinishNotification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let result = notification.object as? ImageLoadResult else{
                return
            }
            guard let cself = self else{
                return
            }
            guard GlobalImageLoadCache.shared.loadingPairs[cself.hashValue] == result.url else{
                return
            }
            result.image.decodedImage(size) { (image) in
                cself.image = image
                cself.layoutIfNeeded()
            }
        }
        GlobalImageLoadCache.shared.loadingPairs[self.hashValue] = path
        UIImage.loadImage(with: path) { (img, res) in
            
        }
    }
    func cancelLoadImage() {
        URLSession.shared.getAllTasks { (list) in
            _ = list.filter { (task) -> Bool in
                guard let url = task.originalRequest?.url?.absoluteString else{
                    return false
                }
                if GlobalImageLoadCache.shared.loadingPairs[self.hashValue] == url{
                    return true
                }
                task.cancel()
                return false
            }
        }
    }
}
public extension UIButton{
    func setImage(with path:String, for state: UIControl.State = .normal){
        NotificationCenter.default.addObserver(forName: UIImage.ImageLoadFinishNotification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let result = notification.object as? ImageLoadResult else{
                return
            }
            guard let cself = self else{
                return
            }
            if GlobalImageLoadCache.shared.loadingPairs[cself.hashValue] == result.url{
                cself.setImage(result.image, for: state)
                cself.layoutIfNeeded()
            }
        }
        GlobalImageLoadCache.shared.loadingPairs[self.hashValue] = path
        UIImage.loadImage(with: path) { (img, res) in
            
        }
    }
    func setBackGroundImage(with path:String, for state: UIControl.State = .normal ){
        NotificationCenter.default.addObserver(forName: UIImage.ImageLoadFinishNotification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let result = notification.object as? ImageLoadResult else{
                return
            }
            guard let cself = self else{
                return
            }
            if GlobalImageLoadCache.shared.loadingPairs[cself.hashValue] == result.url{
                cself.setBackgroundImage(result.image, for: state)
                cself.layoutIfNeeded()
            }
        }
        GlobalImageLoadCache.shared.loadingPairs[self.hashValue] = path
        UIImage.loadImage(with: path) { (img, res) in
            
        }
    }
}
public extension UITabBarController{
    var topViewController:UIViewController? {
        if let navi = selectedViewController as? UINavigationController{
            return navi.topViewController
        }
        return selectedViewController
    }
}
public extension UIApplication{
    static var rootViewController:UIViewController?{
        guard let first = UIApplication.shared.windows.first else{
            return nil
        }
        guard let root = first.rootViewController else{
            return nil
        }
        return root
    }
    static var topViewController:UIViewController?{
        let root = rootViewController
        if let tabVC = root as? UITabBarController{
            return tabVC.topViewController
        }
        if let navi = root as? UINavigationController{
            return navi.topViewController
        }
        return root
    }
    static func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil){
        topViewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    static func pushViewController(_ viewController: UIViewController, animated: Bool) {
        topViewController?.navigationController?.pushViewController(viewController, animated: animated)
    }
    static func showLoadingView() {
        shared.windows.first?.showLoadingView()
    }
    static func hideLoadingView(){
        shared.windows.first?.hideLoadingView()
    }
    
}
struct ImageLoadResult {
    let image:UIImage
    let response:URLResponse
    let url:String
}
public extension UIImage{
    //加载一张图片需要0.015941143035888672左右,decode做分线程处理可以节约时间,减少卡顿
    func decodedImage(_ size:CGSize, callBack:@escaping ((UIImage)->Void)) {
        DispatchQueue.global().async {
            UIGraphicsBeginImageContext(size)
            guard let context = UIGraphicsGetCurrentContext() else{
                callBack(self)
                return
            }
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0, y: -size.height)
            guard let cgImage = self.cgImage else{
                callBack(self)
                return
            }
            context.draw(cgImage, in: CGRect.init(origin: .zero, size: size))
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else{
                callBack(self)
                return
            }
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                callBack(image)
            }
        }
    }
    
    
    func convertToCornerImage(_ cornerRadius:CGFloat = 5) -> UIImage {
        let iv = UIImageView.init(image: self)
        iv.frame = CGRect.init(origin: .zero, size: self.size)
        iv.layer.cornerRadius = cornerRadius
        iv.layer.masksToBounds = true
        return iv.snapShotImage()
    }
    @discardableResult
    static func loadImage(with path: String, complection:@escaping (UIImage?,URLResponse?)->Void) -> URLSessionDataTask? {
        guard let url = URL.init(string: path) else{
            complection(nil,nil)
            return nil
        }
        return loadImage(with: url, complection: complection)
    }
    static let ImageLoadFinishNotification:Notification.Name = Notification.Name.init("wtkit.uiimage.loadimagefinish")
    static func prefetchImage(with url:String){
        loadImage(with: url) { (image, res) in
            
        }
    }
    @discardableResult
    static func loadImage(with url: URL, complection:@escaping (UIImage?,URLResponse?)->Void) -> URLSessionDataTask? {
        let list = GlobalImageLoadCache.shared.loadingURL
        if list.contains(url.absoluteString) {
            complection(nil,nil)
            return nil
        }else{
            GlobalImageLoadCache.shared.loadingURL.insert(url.absoluteString)
            //            GlobalImageLoadCache.shared.loadingURL.append(url.absoluteString)
        }
        return URLSession.default.useCacheElseLoadURLData(with: url) { (data, response, err) in
            if GlobalImageLoadCache.shared.loadingURL.contains(url.absoluteString){
                GlobalImageLoadCache.shared.loadingURL.remove(url.absoluteString)
            }
            guard let data = data else{
                complection(nil,response)
                return
            }
            let image = UIImage.init(data: data)
            complection(image,response)
            guard let img = image else{
                return
            }
            guard let response = response else{
                complection(nil,nil)
                return
            }
            let result = ImageLoadResult.init(image: img, response: response, url: url.absoluteString)
            NotificationCenter.default.post(name: UIImage.ImageLoadFinishNotification, object: result, userInfo: nil)
        }
    }
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

open class LoadingView: UIView {
    var refreshIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
    var indicatorBGView:UIView = UIView.init()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        confgView()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        confgView()
    }
    open override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func confgView() {
        addSubview(indicatorBGView)
        addSubview(refreshIndicatorView)
        refreshIndicatorView.startAnimating()
        self.isUserInteractionEnabled = false
        indicatorBGView.translatesAutoresizingMaskIntoConstraints = false
        indicatorBGView.backgroundColor = UIColor.black.withAlphaComponent(0.66)
        indicatorBGView.layer.cornerRadius = 4
        indicatorBGView.layer.masksToBounds = true
        refreshIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        
        indicatorBGView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatorBGView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorBGView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        indicatorBGView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        refreshIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        refreshIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}
open class TextTip:UIView{
    var tipLabel:UILabel = UILabel.init()
    var tipLabelBGView:UIView = UIView.init()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configView()
    }
    func configView() {
        
    }
}
public extension UIView{
    func showLoadingView() {
        hideLoadingView()
        let loadingView = LoadingView.init(frame: self.bounds)
        addSubview(loadingView)
    }
    func hideLoadingView() {
        let views = subviews.filter { (view) -> Bool in
            if view is LoadingView{
                return true
            }
            return false
        }
        for v in views{
            v.removeFromSuperview()
        }
    }
}

public extension UIWindow{
    //    static func getMainWindow() -> UIWindow {
    //        UIApplication.shared.keyWindow
    //    }
    static func showLoadingView() {
        UIApplication.shared.windows.first?.showLoadingView()
    }
    static func hideLoadingView(){
        UIApplication.shared.windows.first?.hideLoadingView()
    }
}



/*
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
open class WebImageView:UIImageView{
    open var webImageTask:URLSessionDataTask? = nil
    //highlightedImage
    open var highlightedImageTask:URLSessionDataTask? = nil
    open func loadWebImage(with path:String) {
        webImageTask?.cancel()
        let size = self.frame.size
        webImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue()) { [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = UIImage.init(data: data) else{
                return
            }
            //            let date1 = Date.init()
            img.decodedImage(size) { (image) in
                //                let date2 = Date.init()
                //                let distance = date2.timeIntervalSince1970 - date1.timeIntervalSince1970
                //                print("distance:\(distance)")
                DispatchQueue.safeSyncInMain(execute:  {
                    self?.image = image
                    self?.layoutIfNeeded()
                })
            }
        }
        webImageTask?.resume()
    }
    open func loadhighlightedImage(with path:String) {
        highlightedImageTask?.cancel()
        let size = self.frame.size
        highlightedImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue()) { [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = UIImage.init(data: data) else{
                return
            }
            //            let date1 = Date.init()
            img.decodedImage(size) { (image) in
                //                let date2 = Date.init()
                //                let distance = date2.timeIntervalSince1970 - date1.timeIntervalSince1970
                //                print("distance:\(distance)")
                DispatchQueue.safeSyncInMain(execute:  {
                    self?.highlightedImage = image
                    self?.layoutIfNeeded()
                })
            }
        }
        highlightedImageTask?.resume()
    }
}
open class WebImageButton:UIButton{
    open var webImageTask:URLSessionDataTask? = nil
    open var backgroundImageImageTask:URLSessionDataTask? = nil
    open func loadWebImage(with path:String,for state:UIControl.State) {
        webImageTask?.cancel()
        let size = self.bounds.size
        webImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue(), completionHandler: { [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = UIImage.init(data: data) else{
                return
            }
            img.decodedImage(size) { (image) in
                DispatchQueue.safeSyncInMain(execute:  {
                    self?.setImage(image, for: state)
                    self?.layoutIfNeeded()
                })
            }
        })
        
        webImageTask?.resume()
    }
    open func loadBackgroundImageImage(with path:String,for state:UIControl.State){
        backgroundImageImageTask?.cancel()
        let size = self.frame.size
        backgroundImageImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue(), completionHandler: {  [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = UIImage.init(data: data) else{
                return
            }
            img.decodedImage(size) { (image) in
                DispatchQueue.safeSyncInMain(execute:  {
                    self?.setImage(image, for: state)
                    self?.layoutIfNeeded()
                })
            }
        })
        backgroundImageImageTask?.resume()
    }
}
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

public extension UITableViewCell{
    
}
public extension UICollectionViewCell{
    
}
open class WTVC:UIViewController{
    open var wtHeaderView:UIView = UIView()
    open var wtBottomAnchor:NSLayoutConstraint? = nil
    public static var wtDefaultHeaderBGColor:UIColor = UIColor.colorWithHexString("f8fafc")
    open var wtSeparateLine:UIView = UIView()
    open var wtBackButton:UIButton = UIButton.init(type: .custom)
    open var wtBackIconImageView:UIImageView = UIImageView()
    open var wtBackButtonLabel:UILabel = UILabel()
    open var wtTitleLabel:UILabel = UILabel.init()
    public static var wtBackButtonURL:String = "https://songwentong.github.io/projects/WTKit/backbutton.png"{
        didSet{
            
        }
    }
    public static var wtBackButtonImage:UIImage? = nil
    open override func viewDidLoad() {
        super.viewDidLoad()
        configMyHeaderView()
    }
    open override func loadView() {
        super.loadView()
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
        
        view.addSubview(wtSeparateLine)
        wtSeparateLine.turnOffMask()
        wtSeparateLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        wtSeparateLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        wtSeparateLine.bottomAnchor.constraint(equalTo: wtHeaderView.bottomAnchor).isActive = true
        wtSeparateLine.heightAnchor.constraint(equalToConstant: 0.33).isActive = true
        wtSeparateLine.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        
        view.addSubview(wtBackButton)
        wtBackButton.turnOffMask()
        wtBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        wtBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        wtBackButton.bottomAnchor.constraint(equalTo: wtHeaderView.bottomAnchor, constant: 0).isActive = true
        wtBackButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 69).isActive = true

        
        //        wtBackButton.setTitle("Back", for: .normal)
        wtBackButton.addTarget(self, action: #selector(wtBackButtonPressed), for: .touchUpInside)
        wtBackButton.addSubview(wtBackIconImageView)
        wtBackIconImageView.turnOffMask()
        //12 centerY  13 21
        //
        wtBackIconImageView.leadingAnchor.constraint(equalTo: wtBackButton.leadingAnchor, constant: 0).isActive = true
        wtBackIconImageView.bottomAnchor.constraint(equalTo: wtBackButton.bottomAnchor, constant: 0).isActive = true
        wtBackIconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        wtBackIconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        wtBackIconImageView.contentMode = .center
        wtBackIconImageView.image = WTVC.wtBackButtonImage
        if let url = URL.init(string: WTVC.wtBackButtonURL){
            URLSession.default.useCacheElseLoadURLData(with: url) { (data, res, err) in
                guard let data = data else{
                    return
                }
                let img = UIImage.init(data: data)
                self.wtBackIconImageView.image = img
            }
        }
        wtBackButton.addSubview(wtBackButtonLabel)
        wtBackButtonLabel.turnOffMask()
        wtBackButtonLabel.leadingAnchor.constraint(equalTo: wtBackButton.leadingAnchor, constant: 31).isActive = true
        wtBackButtonLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        wtBackButtonLabel.bottomAnchor.constraint(equalTo: wtBackButton.bottomAnchor, constant: 0).isActive = true
        wtBackButtonLabel.trailingAnchor.constraint(equalTo: wtBackButton.trailingAnchor, constant: 0).isActive = true
        wtBackButtonLabel.text = "Back"
        wtBackButtonLabel.textColor = .colorWithHexString("0077fa")
        
        view.addSubview(wtTitleLabel)
        wtTitleLabel.turnOffMask()
        wtTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        wtTitleLabel.textAlignment = .center
        wtTitleLabel.centerXAnchor.constraint(equalTo: wtHeaderView.centerXAnchor, constant: 0).isActive = true
        //view.safeAreaLayoutGuide.topAnchor
        if #available(iOS 11.0, *) {
            wtTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            wtTitleLabel.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        }
        wtTitleLabel.bottomAnchor.constraint(equalTo: wtHeaderView.bottomAnchor, constant: 0).isActive = true
        wtTitleLabel.text = title
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.viewControllers.first == self{
            wtBackButton.isHidden = true
        }else{
            wtBackButton.isHidden = false
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
#endif

