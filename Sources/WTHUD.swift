//
//  LoadingView.swift
//  
//
//  Created by 宋文通 on 2020/2/4.
//

import Foundation
#if os(iOS)
import UIKit
public extension UIApplication{
    static func showLoadingView() {
        shared.windows.first?.showLoadingView()
    }
    static func hideLoadingView(){
        shared.windows.first?.hideLoadingView()
    }
    ///tip view show only in debug mode
    static func debugTip(with string:String){
        #if DEBUG
        showTextTip(with: string)
        #endif
    }
    static func showTextTip(with string:String, hideDelay:TimeInterval = 2) {
        shared.findKeyWindow()?.showTextTip(with: string, hideDelay: hideDelay)
    }
}
public extension UIView{
    ///tip view show only in debug mode
    static func debugTip(with string:String){
        #if DEBUG
        UIApplication.showTextTip(with: string)
        #endif
    }
    
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
    func showTextTip(with string:String, hideDelay:TimeInterval = 2) {
        hideTipTextView()
        let tip = WTTextTip.init(frame: self.bounds)
        tip.tipLabel.text = string
        tip.isUserInteractionEnabled = false
        addSubview(tip)
        DispatchQueue.main.asyncAfterTime(hideDelay) {
            tip.removeFromSuperview()
        }
    }
    func hideTipTextView() {
        for v in subviews{
            if v is WTTextTip{
                v.removeFromSuperview()
            }
        }
    }
}
// MARK: - LoadingView
///LoadingView
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
// MARK: - WTTextTip
///tip view
open class WTTextTip:UIView{
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
        addSubview(tipLabelBGView)
        addSubview(tipLabel)
        tipLabel.turnOffMask()
        tipLabelBGView.turnOffMask()
        tipLabelBGView.cornerRadius = 7
        tipLabelBGView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        tipLabel.font = .systemFont(ofSize: 15)
        tipLabel.textColor = .white
        tipLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tipLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tipLabelBGView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tipLabelBGView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tipLabelBGView.leadingAnchor.constraint(equalTo: tipLabel.leadingAnchor, constant: -15).isActive = true
        tipLabelBGView.topAnchor.constraint(equalTo: tipLabel.topAnchor, constant: -18).isActive = true
    }
}
#endif
