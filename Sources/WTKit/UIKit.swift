//
//  UIKit.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/12.
//  Copyright © 2019 宋文通. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit
public extension UIScreen{
    class func mainScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    class func mainScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
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
    class func colorWithHexString(_ string:String,alpha:CGFloat? = 1.0) -> UIColor{
        //        let s = NSScanner(string: string)
        let mutableCharSet = NSMutableCharacterSet()
        mutableCharSet.addCharacters(in: "#")
        mutableCharSet.formUnion(with: CharacterSet.whitespaces);
        
        
        let hString:String = string.trimmingCharacters(in: mutableCharSet as CharacterSet)
        
        
        switch hString.count {
        case 0:
            return UIColor.red;
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
            let color = UIColor(red: red, green: green, blue: blue,alpha: alpha!)
            return color;
        default:
            return UIColor.red;
        }
    }
}
// MARK: - UINibReusableCell
public protocol UINibReusableCell:NSObjectProtocol {
    static func nib() -> UINib
    static var reuseIdentifier: String{get}
}
public extension UINibReusableCell{
    //这段代码的神奇之处是到了这里已经无法打印self了，报错内容是：error: <EXPR>:1:11: error: use of undeclared type '$__lldb_context'
    static func nib() -> UINib {
        return UINib.init(nibName: self.reuseIdentifier, bundle: nil)
    }
    static var reuseIdentifier: String{
        return "\(self)"
    }
}
public extension UITableView{
    func registNibReuseableCell<T:UINibReusableCell>(_ cellType:T.Type) -> Void {
        register(cellType.nib(), forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    func registNibReuseableCell<T:UINibReusableCell>(_ cellType:T.Type, forHeaderFooterViewReuseIdentifier:String) -> Void {
        register(cellType.nib(), forHeaderFooterViewReuseIdentifier: cellType.reuseIdentifier)
    }
}
public extension UICollectionView{
    func registNibReuseableCell<T:UINibReusableCell>(_ cellType:T.Type) -> Void {
        let nib = cellType.nib()
        let rid = cellType.reuseIdentifier
        register(nib, forCellWithReuseIdentifier: rid)
    }
}
protocol UITableViewModel {
    var sectionList:[UITableViewSectionModel]{get set}
}
protocol UITableViewSectionModel {
    var title:String?{get}
    var headerView:UIView?{get}
    var footerView:UIView?{get}
    var cellInSection:[UITableViewCellModel]{get set}
}
public protocol UITableViewCellModel{
    var reuseId:String{get}
}
public protocol UICollectionViewCellModel {
    var reuseId:String{get}
}
public protocol UITableViewCellDetailModel:UITableViewCellModel {
    var title:String?{get}
    var height:CGFloat?{get}
    var action:DispatchWorkItem?{get}
}
public protocol UITableViewCellModelHolder {
    var model:UITableViewCellModel!{get set}
}
public protocol UICollectionViewCellModelHolder {
    var model:UICollectionViewCellModel!{get set}
}
public extension UITableView{
    func dequeueReusableCellModel(withModel model:UITableViewCellModel, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: model.reuseId, for: indexPath)
        if var c = cell as? UITableViewCellModelHolder{
            c.model = model
        }
        return cell
    }
}
public extension UICollectionView{
    func dequeueReusableCellModel(withModel model:UICollectionViewCellModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: model.reuseId, for: indexPath)
        if var c = cell as? UICollectionViewCellModelHolder{
            c.model = model
        }
        return cell
    }
}
struct SampleTableViewCellModel:UITableViewCellModel {
    var reuseId:String = ""
    var height:CGFloat = 44
    var action = DispatchWorkItem.init {}
    var customAction = ((UITableViewCell)->Void).self
}


public extension UIViewController{
    @objc func setBackArrowButton(image:UIImage?) -> Void {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(recieveBackButtonPressed))
    }
    @objc func setBackArrowButton() -> Void {
        setBackArrowButton(image: UIImage.init(named: "arrrwImage"))
    }
    @objc func recieveBackButtonPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
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
    func loadReuseableNibContentView() {
        let view = instanceFromXibWithOwner()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    func instanceFromXibWithOwner() -> UIView{
        let res = "\(self.classForCoder)"
        let bundle = Bundle.init(for: type(of: self))
        guard let path = Bundle.main.path(forResource: res, ofType: "nib") else{
            print("nib file not found")
            return UIView.init()
        }
        print("load file :\(path)")
        let nib = UINib.init(nibName: res, bundle: bundle)
        if let first = nib.instantiate(withOwner: self, options: nil).first as? UIView{
            return first
        }
        return UIView.init()
    }
    static func instanceFromXib() -> UIView{
        let res = "\(self)"
        guard let _ = Bundle.main.path(forResource: res, ofType: "nib") else{
            print("nib file not found")
            return self.init()
        }
        let nib = UINib.init(nibName: "\(self)", bundle: nil)
        if let first = nib.instantiate(withOwner: nil, options: nil).first as? UIView{
            return first
        }
        return self.init()
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
public extension UIViewController{
    @objc static func instanceFromStoryBoard() -> UIViewController {
        guard let _ = Bundle.main.path(forResource: "\(self)", ofType: "storyboardc") else{
            print("storyboradc file not found class:\(self)")
            return self.init()
        }
        let sb = UIStoryboard.init(name: "\(self)", bundle: nil)
        if let vc = sb.instantiateInitialViewController(){
            return vc
        }else{
            return self.init()
        }
    }
    @objc static func instanceFromNib() -> UIViewController{
        guard let _ = Bundle.main.path(forResource: "\(self)", ofType: "nib") else{
            print("nib file not found class:\(self)")
            return self.init()
        }
        let nib = UINib.init(nibName: "\(self)", bundle: nil)
        guard let objects:[UIViewController] = nib.instantiate(withOwner: nil, options: nil) as? [UIViewController] else{
            return UIViewController()
        }
        if let first = objects.first{
            return first
        }
        return self.init()
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
    static func distance(from p1:CGPoint, p2:CGPoint) -> CGFloat {
        let a = p1.x - p2.x
        let b = p1.y - p2.y
        let c_c = a * a + b * b
        return c_c.squareRoot()
    }
}
public extension UILabel{}
//IBInspectable IBDesignable
@IBDesignable
class UILabelIBDesignable: UILabel {}
@IBDesignable
class UIViewIBDesignable: UIView {}
@IBDesignable
class UIButtonIBDesignable: UIButton {}
private var UIImageViewLoadImagePathKey: Void?
public extension UIImageView{
    func loadImage(with path:String) {
        objc_setAssociatedObject(self, &UIImageViewLoadImagePathKey,path,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        UIImage.loadImage(with: path) { (image, response) in
            guard let resPath = response?.url?.absoluteString else{
                return
            }
            guard let path = objc_getAssociatedObject(self, &UIImageViewLoadImagePathKey) as? String else{
                return
            }
            guard image != nil else{
                return
            }
            if resPath == path{
                self.image = image
                self.layoutIfNeeded()
            }
        }
    }
}
public extension UIButton{
    
}
public extension UIApplication{
    static var topNavigationController:UINavigationController?{
        get{
            return nil
        }
    }
}
public extension UIImage{
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
    @discardableResult
    static func loadImage(with url: URL, complection:@escaping (UIImage?,URLResponse?)->Void) -> URLSessionDataTask {
        return URLSession.useCacheElseLoadURLData(with: url) { (data, response, err) in
            guard let data = data else{
                complection(nil,response)
                return
            }
            let image = UIImage.init(data: data)
            complection(image,response)
        }
    }
}
class AlignLeftFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
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
open class LoadingView: UIView {
    var indicator:UIRefreshControl = UIRefreshControl.init()
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
        addSubview(indicator)
        indicator.beginRefreshing()
        self.isUserInteractionEnabled = false
        indicatorBGView.translatesAutoresizingMaskIntoConstraints = false
        indicatorBGView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatorBGView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorBGView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        indicatorBGView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        indicatorBGView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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
        }
        for v in views{
            v.removeFromSuperview()
        }
    }
}
public extension UIViewController{
    
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
#endif

