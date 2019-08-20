//
//  Hud.swift
//  WTKit
//
//  Created by 李能 on 2017/3/16.
//  Copyright © 2017年 songwentong. All rights reserved.
//  https://github.com/songwentong/WTKit
//

import Foundation
#if os(iOS)
import UIKit
import CoreGraphics

@available(iOS 2.0, *)
public class WTTipView:UIView{
    var activity:UIActivityIndicatorView
    var label:UILabel
    public required override init(frame: CGRect) {
        label = UILabel(frame: frame);
        label.tag = 1
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "test";
        label.backgroundColor = UIColor.clear
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.red
        self.addSubview(label)
        //        self.addSubview(activity)
        //        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
    }
    public static func showTip(_ tip:NSString){
        
        let hud = WTTipView()
        hud.showTip(tip)
        
    }
    public func showTip(_ tip:NSString){
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var tipHeght:CGFloat = 30
        let size = tip.boundingRect(with: CGSize(width: 300, height: 60), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil)
        var width = size.width
        let height = size.height
        
        if width > 280 {
            width = 280
            tipHeght += 20
        }
        self.frame = CGRect(x: (screenWidth - width - 20) / 2, y: screenHeight - 100, width: width + 20, height: tipHeght)
        self.label.frame = CGRect(x: 10, y: (tipHeght - height - 6)/2, width: width, height: height + 6)
        self.label.text = tip as String
        backgroundColor = UIColor.colorWithHexString("3", alpha: 0.2)
        label.textColor = UIColor.white
        let window = UIApplication.shared.windows[0]
        window.addSubview(self)
        
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1,y: 1)
        }
        self.performBlock({
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
            }, completion: { (true) in
                self.transform = CGAffineTransform.identity
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
    case customView
    case pieProgress
    case roundProgressIndicatorView
    case activityIndicatorView
}
public class WTPieProgressView:UIView{
    
    public var progress:CGFloat = 0.0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    public override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let cPoint = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = rect.size.width / 2
        //    ctx?.addArc(tangent1End: <#T##CGPoint#>, tangent2End: <#T##CGPoint#>, radius: <#T##CGFloat#>)
        //        ctx?.addArc(centerX: cPoint.x, y: cPoint.y, radius: radius-2, startAngle:0,endAngle:CGFloat(Double.pi)*2, clockwise: 0);
        
        
        ctx?.addArc(center: cPoint, radius: radius-2, startAngle: 0, endAngle: CGFloat(Double.pi)*2, clockwise: false)
        UIColor.white.setStroke();
        ctx?.drawPath(using:CGPathDrawingMode.stroke);
        ctx?.move(to: cPoint)
        ctx?.addArc(center: cPoint, radius: radius-4, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi*3/2)+CGFloat(Double.pi)*2*progress, clockwise: false)
        
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill();
        ctx?.drawPath(using: CGPathDrawingMode.fill);
    }
    
}

public class WTProgressIndicatorView:UIView{
    
    public  var strokeColor:UIColor =  UIColor.white.withAlphaComponent(0.8)
    public  var lineWidth:CGFloat = 1.5
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
        let path = UIBezierPath(arcCenter: aCenter, radius: self.radius, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2 + Double.pi*5), clockwise: true)
        let layer = CAShapeLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = self.strokeColor.cgColor
        layer.lineWidth = self.lineWidth
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinBevel
        layer.path = path.cgPath
        
        let timeFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.5
        animationGroup.repeatCount = HUGE
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction = timeFunction
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.fromValue = -1
        strokeStart.toValue = 1.0
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0.0
        strokeEnd.toValue = 1.0
        
        animationGroup.animations = [strokeStart,strokeEnd]
        layer.add(animationGroup, forKey: "stroke")
        self.animationLayer = layer
        self.layer.addSublayer(layer)
    }
    
    
}
public class WTHudView:UIView{
    public var mode:WTHudMode = .activityIndicatorView{
        didSet{
            self.updateIndicatorViewWithMode()
            self.updateFrames()
        }
    }
    public var progress:Double = 0.0
    public var opacity:CGFloat = 0.0
    public var defaultFontSize:CGFloat = 14
    public var detailFefaultFontSize:CGFloat = 12
    public var titleLabel:UILabel?
    public var titleText = UIViewController.defaultLoadingText(){
        didSet{
            titleLabel?.text = titleText;
        }
    }
    public var defaultBgColor:UIColor = UIColor.colorWithHexString("3", alpha: 0.5)
    public var defaultTitleColor:UIColor = UIColor.white
    private var backgroundView:UIView?
    public var indicatorView:UIView?
    private(set) public var detailText:String?
    private(set) public var detailLabel:UILabel?
    
    
    //MARK:INIT
    public init(view :UIView){
        super.init(frame:view.bounds)
        self.commonInit()
    }
    private func commonInit(){
        
        backgroundView = UIView(frame: CGRect.zero)
        backgroundView?.backgroundColor = defaultBgColor
        backgroundView!.layer.cornerRadius = 10
        backgroundView!.clipsToBounds = true
        backgroundView?.alpha = 0
        self.addSubview(backgroundView!)
        
        self.updateIndicatorViewWithMode()
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel!.text = titleText
        titleLabel!.textColor = defaultTitleColor
        titleLabel?.textAlignment = .center
        titleLabel!.font = UIFont.systemFont(ofSize: defaultFontSize)
        backgroundView!.addSubview(titleLabel!)
        self.updateFrames()
        
    }
    private func updateIndicatorViewWithMode(){
        if (self.indicatorView != nil) {
            self.indicatorView?.removeFromSuperview()
        }
        switch mode {
        case .activityIndicatorView:
            let indicatorView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white);
            indicatorView.frame = CGRect.zero
            self.indicatorView = indicatorView
            backgroundView!.addSubview(indicatorView)
            indicatorView.startAnimating()
            break
        case .roundProgressIndicatorView:
            let indicatorView = WTProgressIndicatorView()
            self.indicatorView = indicatorView
            backgroundView!.addSubview(indicatorView)
            break
        case.pieProgress:
            let indicatorView = WTPieProgressView()
            indicatorView.backgroundColor = UIColor.clear
            self.indicatorView = indicatorView
            backgroundView!.addSubview(indicatorView)
            break
        default: break
            
        }
        
    }
    
    public func updateFrames(){
        backgroundView!.setWidth(100)
        backgroundView!.setHeight(100)
        backgroundView!.setCenterX(self.centerX)
        backgroundView!.setCenterY(self.centerY)
        let indictor = self.indicatorView
        
        if indictor is UIActivityIndicatorView {
            indictor?.setSize(CGSize(width: 40, height: 40))
            indictor?.setTop(20)
            indictor?.setLeft(30)
            
        }else if indictor is WTProgressIndicatorView{
            
            indictor?.frame = CGRect(x: 30, y: 20, width: 40, height: 40)
        }else if indictor is WTPieProgressView {
            indictor?.frame = CGRect(x: 30, y: 20, width: 40, height: 40)
        }
        titleLabel?.setX(10)
        titleLabel?.setWidth((backgroundView!.width) - titleLabel!.x * 2.0)
        titleLabel?.setHeight(20)
        titleLabel?.setTop(indictor!.bottom + 10)
        
    }
    public override func layoutSubviews() {
        
    }
    public static func showHudInView(_ view:UIView,animatied:Bool) ->WTHudView{
        let hud = WTHudView(view: view)
        view.addSubview(hud)
        hud.showAnimated(animatied)
        return hud
    }
    public static func hudViewForView(_ view:UIView) ->WTHudView?{
        for v in view.subviews {
            if v.isKind(of: self) {
                return v as? WTHudView
            }
        }
        return nil
    }
    public static func hideHudInView(_ view:UIView,animatied:Bool){
        let hud = self.hudViewForView(view)
        if hud != nil {
            hud?.hideAnimated(animatied)
            
        }
    }
    public func showAnimated(_ animated:Bool){
        
        if animated {
            self.backgroundView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            let animaations = {self.backgroundView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.backgroundView!.alpha = 1.0
            }
            UIView.animate(withDuration: 0.3, animations: animaations, completion: nil)
        }else{
            backgroundView?.alpha = 1.0
        }
    }
    public func hideAnimated(_ animated:Bool){
        if animated {
            let animaations = {self.backgroundView!.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.backgroundView!.alpha = 0.0
            }
            UIView.animate(withDuration: 0.3, animations: animaations, completion: { (finish) in
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
#endif
