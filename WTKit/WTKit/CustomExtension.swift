//  https://github.com/swtlovewtt/WTKit
//  CustomExtension.swift
//  WTKit
//
//  Created by SongWentong on 5/26/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit
extension UIViewController{
    
    /*!
        提示文字
     */
    public func showHudWithTip(tip:NSString){
         WTTipView.showTip(tip)
    }
    /*!
        显示loading指示器(activity indicator)
     */
    public func showLoadingView(){
        WTHudView.showHudInView(self.view, animatied: true)
    }
    /*!
        隐藏loading指示器
     */
    public func hideLoadingView(){
        WTHudView.hideHudInView(self.view, animatied: true)
    }
}

public class WTTipView:UIView{
    var activity:UIActivityIndicatorView
    var label:UILabel
    public required override init(frame: CGRect) {
        label = UILabel(frame: frame);
        label.tag = 1
        label.numberOfLines = 2
        label.font = UIFont.systemFontOfSize(14)
        label.text = "test";
        label.backgroundColor = UIColor.clearColor()
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.redColor()
        self.addSubview(label)
//        self.addSubview(activity)
//        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
    }
    public static func showTip(tip:NSString){
        
        let hud = WTTipView()
        hud.showTip(tip)
        
    }
    public func showTip(tip:NSString){
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        var tipHeght:CGFloat = 30
        let size = tip.boundingRectWithSize(CGSizeMake(300, 60), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
        var width = size.width
        let height = size.height
        
        if width > 280 {
            width = 280
            tipHeght += 20
        }
        self.frame = CGRectMake((screenWidth - width - 20) / 2, screenHeight - 100, width + 20, tipHeght)
        self.label.frame = CGRectMake(10, (tipHeght - height - 6)/2, width, height + 6)
        self.label.text = tip as String
        backgroundColor = UIColor.colorWithHexString("3", alpha: 0.2)
        label.textColor = UIColor.whiteColor()
        let window = UIApplication.sharedApplication().windows[0]
        window.addSubview(self)
        
        self.alpha = 0
        self.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(0.3) { 
            self.alpha = 1
            self.transform = CGAffineTransformMakeScale(1,1)
        }
       self.performBlock({
           UIView.animateWithDuration(0.2, animations: { 
            self.alpha = 0
            self.transform = CGAffineTransformMakeScale(0, 0)
            
            }, completion: { (true) in
                self.transform = CGAffineTransformIdentity
                self.removeFromSuperview()
           })
        }, afterDelay: 2)
        
        
    }
    deinit{
       WTLog("Tip deinit")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


public enum WTHudMode{
    case CustomView
    case pieProgress
    case roundProgressIndicatorView
    case ActivityIndicatorView
}
public class WTProgressIndicatorView:UIView{
  
    public  var strokeColor:UIColor = UIColor.whiteColor()
    public  var lineWidth:CGFloat = 2.0
    public  var radius:CGFloat = 20.0{
        didSet{
            self.resetLayer()
        }
    }
    private var animationLayer:CAShapeLayer?
    
    override public var frame: CGRect{
        didSet{
            self.resetLayer()
        }
    }
    private func resetLayer(){
    
        self.layer.removeAllAnimations()
        if self.animationLayer != nil {
            self.animationLayer?.removeFromSuperlayer()
        }
        let aCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let path = UIBezierPath(arcCenter: aCenter, radius: self.radius, startAngle: CGFloat(M_PI*3/2), endAngle: CGFloat(M_PI/2 + M_PI*5), clockwise: true)
        let layer = CAShapeLayer()
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = self.strokeColor.CGColor
        layer.lineWidth = self.lineWidth
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinBevel
        layer.path = path.CGPath
        
        let timeFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.5
        animationGroup.repeatCount = HUGE
        animationGroup.removedOnCompletion = false
        animationGroup.timingFunction = timeFunction
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.fromValue = -1
        strokeStart.toValue = 1.0
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0.0
        strokeEnd.toValue = 1.0
        
        animationGroup.animations = [strokeStart,strokeEnd]
        layer.addAnimation(animationGroup, forKey: "stroke")
        self.animationLayer = layer
        self.layer.addSublayer(layer)
    }
    
    
}
public class WTHudView:UIView{
    public var mode:WTHudMode = .ActivityIndicatorView{
        didSet{
            self.updateIndicatorViewWithMode()
            self.setNeedsLayout()
        }
    }
    public var progress:Double = 0.0
    public var opacity:CGFloat = 0.0
    public var defaultFontSize:CGFloat = 14
    public var detailFefaultFontSize:CGFloat = 12
    public var titleLabel:UILabel?
    public var titleText = "loading..."{
        didSet{
            titleLabel?.text = titleText;
        }
    }
    public var defaultBgColor:UIColor = UIColor.colorWithHexString("3", alpha: 0.5)
    public var defaultTitleColor:UIColor = UIColor.whiteColor()
    private var backgroundView:UIView?
    private var indicatorView:UIView?
    private(set) public var detailText:String?
    private(set) public var detailLabel:UILabel?
    
    
    //MARK:INIT
    public init(view :UIView){
        super.init(frame:view.bounds)
        self.commonInit()
    }
    private func commonInit(){
        
        backgroundView = UIView(frame: CGRectZero)
        backgroundView?.backgroundColor = defaultBgColor
        backgroundView!.layer.cornerRadius = 10
        backgroundView!.clipsToBounds = true
        backgroundView?.alpha = 0
        self.addSubview(backgroundView!)
        
        self.updateIndicatorViewWithMode()
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel!.text = titleText
        titleLabel!.textColor = defaultTitleColor
        titleLabel?.textAlignment = .Center
        titleLabel!.font = UIFont.systemFontOfSize(defaultFontSize)
        backgroundView!.addSubview(titleLabel!)
        self.setNeedsLayout()
        
    }
    private func updateIndicatorViewWithMode(){
        if (self.indicatorView != nil) {
            self.indicatorView?.removeFromSuperview()
        }
        switch mode {
        case .ActivityIndicatorView:
            let indicatorView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White);
            indicatorView.frame = CGRectZero
            self.indicatorView = indicatorView
            backgroundView!.addSubview(indicatorView)
            indicatorView.startAnimating()
            break
        case .roundProgressIndicatorView:
            let indicatorView = WTProgressIndicatorView()
            self.indicatorView = indicatorView
            backgroundView!.addSubview(indicatorView)
            break
        default: break
            
        }
        
    }
    public override func layoutSubviews() {
        backgroundView!.setWidth(100)
        backgroundView!.setHeight(100)
        backgroundView!.setCenterX(self.centerX)
        backgroundView!.setCenterY(self.centerY)
        let indictor = self.indicatorView
        if indictor!.isKindOfClass(UIActivityIndicatorView) {
            indictor?.setSize(CGSizeMake(40, 40))
            indictor?.setTop(20)
            indictor?.setLeft(30)
          
        }else if indictor!.isKindOfClass(WTProgressIndicatorView){
            
            indictor?.frame = CGRectMake(30, 20, 40, 40)
        }
        titleLabel?.setX(10)
        titleLabel?.setWidth((backgroundView!.width) - titleLabel!.x * 2.0)
        titleLabel?.setHeight(20)
        titleLabel?.setTop(indictor!.bottom + 10)

    }
    public static func showHudInView(view:UIView,animatied:Bool) ->WTHudView{
        let hud = WTHudView(view: view)
        view.addSubview(hud)
        hud.showAnimated(animatied)
        return hud
    }
    public static func hudViewForView(view:UIView) ->WTHudView?{
        for v in view.subviews {
            if v.isKindOfClass(self) {
                return v as? WTHudView
            }
        }
        return nil
    }
    public static func hideHudInView(view:UIView,animatied:Bool){
        let hud = self.hudViewForView(view)
        if hud != nil {
            hud?.hideAnimated(animatied)
            
        }
    }
    public func showAnimated(animated:Bool){
        
        if animated {
            self.backgroundView?.transform = CGAffineTransformMakeScale(0.5, 0.5)
            let animaations = {self.backgroundView!.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.backgroundView!.alpha = 1.0
            }
            UIView.animateWithDuration(0.3, animations: animaations, completion: nil)
        }else{
            backgroundView?.alpha = 1.0
        }
    }
    public func hideAnimated(animated:Bool){
        if animated {
            let animaations = {self.backgroundView!.transform = CGAffineTransformMakeScale(0.0, 0.0)
                self.backgroundView!.alpha = 0.0
            }
            UIView.animateWithDuration(0.2, animations: animaations, completion: { (finish) in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
    }

    deinit{
        WTLog("hudView deinit")
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

extension UIView
{
    var width:      CGFloat { return self.frame.size.width }
    var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    func setWidth(width:CGFloat) {
        self.frame.size.width = width
    }
    
    func setHeight(height:CGFloat) {
        self.frame.size.height = height
    }
    
    func setSize(size:CGSize) {
        self.frame.size = size
    }
    
    func setOrigin(point:CGPoint) {
        self.frame.origin = point
    }
    
    func setX(x:CGFloat) {
        self.frame.origin = CGPointMake(x, self.frame.origin.y)
    }
    
    func setY(y:CGFloat) {
        self.frame.origin = CGPointMake(self.frame.origin.x, y)
    }
    
    func setCenterX(x:CGFloat) {
        self.center = CGPointMake(x, self.center.y)
    }
    
    func setCenterY(y:CGFloat) {
        self.center = CGPointMake(self.center.x, y)
    }
    
    func roundCorner(radius:CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func setTop(top:CGFloat) {
        self.frame.origin.y = top
    }
    
    func setLeft(left:CGFloat) {
        self.frame.origin.x = left
    }
    
    func setRight(right:CGFloat) {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(bottom:CGFloat) {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    

    
}
//K 线图
public class KlineView:UIView{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit{
        
    }
    
    var delegate:KlineViewDelegate?
    
}

public protocol KlineViewDataSource:NSObjectProtocol{
    
}

public protocol KlineViewDelegate:NSObjectProtocol{
    
}
#endif